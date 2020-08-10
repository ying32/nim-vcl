# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

when defined(gcc) and defined(windows):
  when defined(x86):
    {.link: "appres_386.o".}
  else:  
    {.link: "appres_amd64.o".}

import  
  strutils, 
  ../../src/[vcl, types, fns],   
  typeinfo #, macros

## 如何实现这种的?????? 
## TMainForm = lclClass(TForm)
# macro lclClass(class: untyped, parent: untyped): untyped = 
#   result = newStmtList()    
#   result.add parseExpr($class & "= ref object of" & $parent)
 
  
## 如何实现反射填充ref object的字段？？     
## 

type 
  TMainForm = ref object of TForm
    memo: TMemo
    edit: TEdit
    lbl1: TLabel
    dlgOpen: TOpenDialog
    mainMenu: TMainMenu
    pmMenu: TPopupMenu
    listbox1: TListBox
        # dlgColor: TColorDialog

type
  TTest1 = ref object
  Test2 = object
     val: int

proc Free(obj: TTest1) =
  echo "call free." 

var 
  mainForm: TMainForm
  form2: TForm
  # thr: Thread[void]

# proc threadFunc() {.thread.} =
#   echo("threadid-2: ", CurrentThreadId())
#   在线程中操作ui必须使用ThreadSync方法切换到主线程执行
#   ThreadSync(proc()=
#     echo("threadid-3: ", CurrentThreadId())
#   )

# 单击事件测试
proc onButton1Click(sender: pointer) =
  let btn = sender.AsButton  #AsButton(sender)
  var test1: TTest1
  new(test1, Free)
  
  echo("handle: ", Application.Handle)
  echo("mainThreadId: ", MainThreadId())
  echo("threadid-1: ", CurrentThreadId())
  
  # 创建一条线程，并开始运行
  # createThread(thr, threadFunc)
  # joinThread(thr) 这里是会wait，造成主线程阻塞，然后ThreadSync就会卡死的
  # echo("结束测试")

  #invokeNew
  # var test2 = Test2(val:1)
  # var x3 = toAny(test2)
  # echo test2.val
  # for key, val in fields(x3):
  #   echo key, "  " ,typedesc val, ", " #cast[ptr int](val)[]
  #   cast[ptr int](val.value)[] = int(4)
    
  echo typedesc(test1)

  if mainForm.edit != nil:
    mainForm.edit.Text = btn.Caption
  ShowMessage("Hello Nim! Hello 世界！")  
  # GC_fullCollect()   
  # ShowMessageFmt("Hello Nim! Hello 世界！ $1", "xxx")


# 拖放文件测试
proc onDropFiles(sender: pointer, fileNames: pointer, len: int) =
  for i in 0..len-1:
    let fName = GetFPStringArrayMember(fileNames, i)
    echo(i, ":", fName)
    if mainForm.memo != nil:
      mainForm.memo.Append(fName)

# 窗口鼠标移动
proc onFormMouseMove(sender: pointer, shift: TShiftState, x: int32, y: int32) =
  if mainForm.lbl1 != nil:
    let sp = Mouse.CursorPos
    mainForm.lbl1.Caption = format("p: x=$1, y=$2, screen: x=$3, y=$4", x, y, sp.x, sp.y)
  # discard

# 窗口消息测试
proc onFormWndProc(msg: var TMessage) = 
  # 在WndProc必需要调用InheritedWndProc，以便让消息传递，至于放在哪个位置这个根据需求决定
  mainForm.InheritedWndProc(msg)
  case msg.msg
  of 0x0201: # WM_LBUTTONDOWN
    echo "mouse down"
  of 0x0202: # WM_LBUTTONUP
    echo "mouse up" 
  else:
    discard
  

# 打开文件对话框测试
proc onBtn2Click(sender: pointer) =
  if mainform.dlgOpen.Execute:
    let fName = mainform.dlgOpen.FileName
    mainForm.edit.Text = fName
    mainForm.memo.Lines.LoadFromFile(fName)

###########################################################################

echo "Test"

# proc TestFunc1(p: var TPoint) =
  # echo p.x, ",", p.y 

# proc TestFunc2(p: TPoint) = 
  # TestFunc1(p.unsafeAddr)
# let p = TPoint(x:1, y:1)
# TestFunc1(p)
# TestFunc2(TPoint(x:13, y:21))

echo("libInfo: \r\n", LibAbout())
echo("start gui")
echo cast[uint](Application.Instance)
let guid = CreateGUID()
echo("guid: ", GUIDToString(guid)) 


# 全局异常处理
# Application.OnException= proc(e: ref Exception) =
#   ShowMessage("exception: " & e.msg)

Application.Title = "Nim: LCL Application"
Application.MainFormOnTaskBar =true
Application.Initialize

# mainForm，使用lazarus风格的
Application.CreateForm(mainForm)


# echo typeof(mainForm) is TObject
# for key, val in mainForm.toAny.fields:
#   echo "key:", key, "val:", val


mainForm.Position = poScreenCenter
mainForm.Caption = "Nim: LCL Form"
mainForm.AllowDropFiles = true
mainForm.OnDropFiles = onDropFiles
mainForm.Height = 550
mainForm.OnMouseMove = onFormMouseMove
mainForm.OnWndProc = onFormWndProc

#label
mainForm.lbl1 = NewLabel(mainForm)
mainForm.lbl1.Parent = mainForm
mainForm.lbl1.Left = 100
mainForm.lbl1.Top = 20


# button
let btn = NewButton(mainForm)
btn.Parent = mainForm
btn.Caption = "hello"
btn.Left = 100
btn.Top = 50
btn.OnClick = onButton1Click



# edit
mainForm.edit = NewEdit(mainForm)
mainForm.edit.Parent = mainForm
mainForm.edit.Left = 100
mainForm.edit.Top = 90
mainForm.edit.Width = 500

# opendialog
mainform.dlgOpen = NewOpenDialog(mainForm)
# 测试集合类型
mainform.dlgOpen.Options = mainform.dlgOpen.Options + {ofAllowMultiSelect, ofViewDetail, ofAutoPreview}
mainForm.dlgOpen.Filter = "Nim Source|*.nim|C Source|*.c;*.h"

# button
let btn2 = NewButton(mainForm)
btn2.Parent = mainForm
btn2.Caption = "open dialog"
btn2.Left = 100
btn2.Top = 120
btn2.Width = 100
btn2.OnClick = onBtn2Click

# ResForm，不使用重定义类型的方式
form2 = Application.CreateForm() 
when defined(windows):
  # 已经打包到资源中了
  #
  ResFormLoadFromResourceName(GetMainInstance(), "TFORM2", form2)
  #ResFormLoadFromFile("./Form1.gfm", form2)
  # 这里测试直接查找form2的按钮
  let obj = form2.FindComponent("Button1")
  if obj != nil:
    cast[TButton](obj).OnClick = onButton1Click

# openfiledialog
let btnOpenForm2 = NewButton(mainForm)
btnOpenForm2.Parent = mainForm
btnOpenForm2.Caption = "Open Form2"
btnOpenForm2.Left = 100
btnOpenForm2.Top = btn2.Top + btn2.Height + 10
btnOpenForm2.Width = 100
# 闭包方式
btnOpenForm2.OnClick = proc(sender: pointer)=
  form2.Show


# opencolordialog
let dlgColor = NewColorDialog(mainForm)
let btnOpenColordlg = NewButton(mainForm)
btnOpenColordlg.Parent = mainForm
btnOpenColordlg.Caption = "Open dlgColor"
btnOpenColordlg.Left = 100 + btnOpenForm2.Width + 10
btnOpenColordlg.Top = btnOpenForm2.Top
btnOpenColordlg.Width = 100
btnOpenColordlg.OnClick = proc(sender: pointer)=
  if dlgColor.Execute:
    mainForm.lbl1.Font.Color = dlgColor.Color


# exception button
let btnTestException = NewButton(mainForm)
btnTestException.Parent = mainForm
btnTestException.Caption = "Exception Test"
btnTestException.Left = btnOpenColordlg.Left + btnOpenColordlg.Width + 10
btnTestException.Top = btnOpenColordlg.Top
btnTestException.Width = 100
btnTestException.OnClick = proc(sender: pointer)=
   # exception test
  try:
    let jpg = NewJPEGImage() # TJPEGImage new的时候传入了Free，所以调用Free不是必须的。 
    jpg.LoadFromFile("abc.jpg") # 不存在abc.jpg
  except Exception as e:
    discard MessageDlg("ERROR: " & e.msg, mtError, {mbYes}, 0)
    #ShowMessage(e.msg)
  except:
    echo "Unknown exception!"

# memo
mainForm.memo = NewMemo(mainForm)
mainForm.memo.Parent = mainForm
mainForm.memo.Left = 100
mainForm.memo.Top = btnOpenForm2.Top + btnOpenForm2.Height + 10
mainForm.memo.Width = 500
mainForm.memo.Height = 200
mainForm.memo.ScrollBars = ssVertical

# TMainMenu
mainForm.mainMenu = NewMainMenu(mainForm)
let fItem = NewMenuItem(mainForm)
fItem.Caption = "&File"

# new
var subItem = NewMenuItem(mainForm)
subItem.Caption = "&New"
subItem.ShortCutText = "Ctrl+N"
subItem.OnClick = proc(sender: pointer)=
  mainForm.memo.Clear
  discard
fItem.Add(subItem)

# open
subItem = NewMenuItem(mainForm)
subItem.Caption = "&Open"
subItem.ShortCutText = "Ctrl+O"
subItem.OnClick = proc(sender: pointer)= 
  ShowMessage("Open")
  discard
fItem.Add(subItem)
# -
subItem = NewMenuItem(mainForm)
subItem.Caption = "-"
fItem.Add(subItem)

#exit
subItem = NewMenuItem(mainForm)
subItem.Caption = "&Exit"
subItem.OnClick = proc(sender: pointer)=
  Application.Terminate
  discard
fItem.Add(subItem)

# add fItem
mainForm.mainMenu.Items.Add(fItem)

# TPopupMenu    
mainForm.pmMenu = NewPopupMenu(mainForm)
mainForm.PopupMenu = mainForm.pmMenu

try:
#exit
  subItem = NewMenuItem(mainForm)
  subItem.Caption = "&Exit"
  subItem.OnClick = proc(sender: pointer)=
    Application.Terminate
    discard
  mainForm.pmMenu.Items.Add(subItem)
except Exception as e:
  ShowMessage(e.msg)
except:
  discard


# TListBox
mainForm.listbox1 = NewListBox(mainForm)
mainForm.listbox1.Parent = mainForm
mainForm.listbox1.Left = mainForm.memo.Left
mainForm.listbox1.Top = mainForm.memo.Top + mainForm.memo.Height + 10
mainForm.listbox1.Width = mainForm.memo.Width
mainForm.listbox1.Height = 120
mainForm.listbox1.OnClick=proc(sender: pointer)=
  let idx = mainForm.listbox1.ItemIndex
  if idx != -1:
    echo mainForm.listbox1.Items.Strings(idx)  
  discard
mainForm.listbox1.Style = lbOwnerDrawFixed
mainForm.listbox1.ItemHeight = 30
mainForm.listbox1.OnDrawItem=proc(control: pointer, index: int32, aRect: var TRect, state: TOwnerDrawState)=
  let canvas = mainForm.listbox1.Canvas
  let s = mainForm.listbox1.Items.Strings(index)
  let fw = canvas.TextWidth(s)
  let fh = canvas.TextHeight(s)
  canvas.Font.Color = clBlack
  canvas.Brush.Color = TColor(clBtnFace)
  canvas.FillRect(aRect)
  canvas.Brush.Color = 0x00FFF7F7
  canvas.Pen.Color = clSkyblue
  canvas.Rectangle(aRect.left + 1, aRect.top + 1, aRect.right - 1, aRect.bottom - 1)
  canvas.Rectangle(aRect.left, aRect.top, aRect.right, aRect.bottom)
  if odSelected in state:
    canvas.Brush.Color = 0x00FFB2B5
    canvas.Rectangle(aRect.left + 1, aRect.top + 1, aRect.right - 1, aRect.bottom - 1)
    canvas.Font.Color = clBlue
    if odFocused in state:
      canvas.DrawFocusRect(aRect)
      discard

  canvas.TextOut(aRect.left + (aRect.right - fw) div 2, aRect.top + (30 - fh) div 2, s)
  discard

for i in 0..10:
  discard mainForm.listbox1.Items.Add(format("item=$1", i))  




# run
Application.Run

echo("end.")