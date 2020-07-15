
import liblcl, types

type
    TObject* {.inheritable.} = ref object
      FInstance: pointer

    TComponent*  = ref object of TObject

    TControl*  = ref object of TComponent

    TWinControl* = ref object of TControl

    TIcon*  = ref object of TObject
    
    TForm* = ref object of TWinControl

    TApplication* = ref object of TComponent

    TButton* = ref object of TWinControl
   


#---------------------------------------------------------------

proc ShowMessage*(msg: string) =
  DShowMessage(msg)

proc GetStringArrOf*(p: pointer, index: int): string =
  return $DGetStringArrOf(p, index)

proc CheckPtr*(obj: TObject): pointer =
  if obj != nil:
    return obj.FInstance
  else:
    return nil

#------------- TApplication-------------------------

proc NewApplication(owner: TComponent): TApplication =
  new(result)
  result.FInstance = Application_Instance()
    
method SetTitle*(this: TApplication, value: string) {.base.} =
   Application_SetTitle(this.FInstance, value)

method SetMainFormOnTaskBar*(this: TApplication, value: bool) {.base.} =
   Application_SetMainFormOnTaskBar(this.FInstance, value)

method Initialize*(this: TApplication) {.base.} =
   Application_Initialize(this.FInstance)

method CreateForm*(this: TApplication): TForm {.base.} =
   new(result)
   result.FInstance = Application_CreateForm(this.FInstance, false)

method Run*(this: TApplication) {.base.} =
   Application_Run(this.FInstance)

method GetIcon*(this: TApplication): TIcon {.base.} =
   new(result)
   result.FInstance = Application_GetIcon(this.FInstance)

#------------ TIcon -------------------------
proc NewIcon*(): TIcon =
   new(result)
   result.FInstance = Icon_Create()

method Free*(this: TIcon) {.base.} =
  if this != nil:
     Icon_Free(this.FInstance)
     this.TObject.FInstance = nil
   
method LoadFromFile*(this: TIcon, fileName: string) {.base.} =
  Icon_LoadFromFile(this.FInstance, fileName)
   

#------------- TForm -------------------------

# proc NewForm*(owner: TComponent): TForm =
#   new(result)
#   result.FInstance = Form_Create(checkPtr(owner))
    
method SetCaption*(this: TForm, value: string) {.base.} =
   Form_SetCaption(this.FInstance, value)

method SetPosition*(this: TForm, value: TPosition) {.base.} =
   Form_SetPosition(this.FInstance, value)

method SetAllowDropFiles*(this: TForm, allow: bool) {.base.} =
   Form_SetAllowDropFiles(this.FInstance, allow)

method SetOnDropFiles*(this: TForm, event: TDropFilesEvent) {.base.} =
   Form_SetOnDropFiles(this.FInstance, event)

 
#------------- TButton -------------------------

proc NewButton*(owner: TComponent): TButton =
  new(result)
  result.FInstance = Button_Create(CheckPtr(owner))
    
method SetCaption*(this: TButton, value: string) {.base.} =
   Button_SetCaption(this.FInstance, value)

method SetParent*(this: TButton, value: TWinControl) {.base.} =
   Button_SetParent(this.FInstance, CheckPtr(value))

method SetLeft*(this: TButton, value: int32) {.base.} =
   Button_SetLeft(this.FInstance, value)

method SetTop*(this: TButton, value: int32) {.base.} =
   Button_SetTop(this.FInstance, value)

method SetOnClick*(this: TButton, event: TNotifyEvent) {.base.} =
   Button_SetOnClick(this.FInstance, event)

 

#------------ global vars ----------------------

var
   Application* = NewApplication(nil)


