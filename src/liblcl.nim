{.deadCodeElim: on.}

# DLL
when defined(windows):
  {.push, callconv: stdcall.}
else:
  {.push, callconv: cdecl.}

when defined(windows):
  const dllname = "liblcl.dll"
elif defined(macosx):
  const dllname = "liblcl.dylib"
else:
  const dllname = "liblcl.so"    

import types

  # windows= stdcall; linux and macOS = cdecl
  # TApplication
proc Application_Instance*(): pointer  {.importc: "Application_Instance", dynlib: dllname.}
proc Application_SetMainFormOnTaskBar*(obj: pointer, val: bool) {.importc: "Application_SetMainFormOnTaskBar", dynlib: dllname.}
proc Application_Initialize*(obj: pointer)  {.importc: "Application_Initialize", dynlib: dllname.}
proc Application_Run*(obj: pointer)  {.importc: "Application_Run", dynlib: dllname.}
proc Application_CreateForm*(obj: pointer, initScale: bool): pointer  {.importc: "Application_CreateForm", dynlib: dllname.}
proc Application_SetTitle*(obj: pointer, val: cstring)  {.importc: "Application_SetTitle", dynlib: dllname.}
proc Application_GetIcon*(obj: pointer): pointer {.importc: "Application_GetIcon", dynlib: dllname.}
  
  # TIcon
proc Icon_Create*(): pointer {.importc: "Icon_Create", dynlib: dllname.}
proc Icon_Free*(obj: pointer) {.importc: "Icon_Free", dynlib: dllname.}
proc Icon_LoadFromFile*(obj: pointer, fileName: cstring) {.importc: "Icon_LoadFromFile", dynlib: dllname.}

  # TForm
proc Form_SetPosition*(obj: pointer, val: TPosition)  {.importc: "Form_SetPosition", dynlib: dllname.}
proc Form_SetCaption*(obj: pointer, val: cstring) {.importc: "Form_SetCaption", dynlib: dllname.}
proc Form_SetAllowDropFiles*(obj: pointer, allow: bool) {.importc: "Form_SetAllowDropFiles", dynlib: dllname.}
proc Form_SetOnDropFiles*(obj: pointer, event: TDropFilesEvent) {.importc: "Form_SetOnDropFiles", dynlib: dllname.}

  # TButton
proc Button_Create*(owner: pointer): pointer  {.importc: "Button_Create", dynlib: dllname.}
proc Button_SetParent*(obj: pointer, parent: pointer)  {.importc: "Button_SetParent", dynlib: dllname.}
proc Button_SetOnClick*(obj: pointer, event: TNotifyEvent)  {.importc: "Button_SetOnClick", dynlib: dllname.}
proc Button_SetCaption*(obj: pointer, val: cstring)  {.importc: "Button_SetCaption", dynlib: dllname.}
proc Button_SetLeft*(obj: pointer, val: int32)  {.importc: "Button_SetLeft", dynlib: dllname.}
proc Button_SetTop*(obj: pointer, val: int32)  {.importc: "Button_SetTop", dynlib: dllname.}
proc Button_GetCaption*(obj: pointer): cstring  {.importc: "Button_GetCaption", dynlib: dllname.}
proc Button_SetWidth*(obj: pointer, value: int32)  {.importc: "Button_SetWidth", dynlib: dllname.}

  # TEdit
proc Edit_Create*(owner: pointer): pointer {.importc: "Edit_Create", dynlib: dllname.}
proc Edit_Free*(obj: pointer) {.importc: "Edit_Free", dynlib: dllname.}
proc Edit_SetText*(obj: pointer, value: cstring) {.importc: "Edit_SetText", dynlib: dllname.}
proc Edit_SetLeft*(obj: pointer, val: int32)  {.importc: "Edit_SetLeft", dynlib: dllname.}
proc Edit_SetTop*(obj: pointer, val: int32)  {.importc: "Edit_SetTop", dynlib: dllname.}
proc Edit_SetParent*(obj: pointer, parent: pointer)  {.importc: "Edit_SetParent", dynlib: dllname.}
proc Edit_SetWidth*(obj: pointer, value: int32)  {.importc: "Edit_SetWidth", dynlib: dllname.}

  # TOpenDialog
proc OpenDialog_Create*(owner: pointer): pointer {.importc: "OpenDialog_Create", dynlib: dllname.}
proc OpenDialog_Free*(obj: pointer) {.importc: "OpenDialog_Free", dynlib: dllname.}
proc OpenDialog_Execute*(obj: pointer): bool {.importc: "OpenDialog_Execute", dynlib: dllname.}
proc OpenDialog_GetOptions*(obj: pointer): TOpenOptions {.importc: "OpenDialog_GetOptions", dynlib: dllname.}
proc OpenDialog_SetOptions*(obj: pointer, value: TOpenOptions) {.importc: "OpenDialog_SetOptions", dynlib: dllname.}
proc OpenDialog_GetFileName*(obj: pointer): cstring {.importc: "OpenDialog_GetFileName", dynlib: dllname.}


  # callback
proc SetEventCallback(callback: pointer)  {.importc: "SetEventCallback", dynlib: dllname.}
proc SetMessageCallback(callback: pointer)  {.importc: "SetMessageCallback", dynlib: dllname.}
proc SetThreadSyncCallback(callback: pointer)  {.importc: "SetThreadSyncCallback", dynlib: dllname.}

# others
proc DShowMessage*(msg: cstring) {.importc: "DShowMessage", dynlib: dllname.}
proc DGetStringArrOf*(p: pointer, index: int): cstring {.importc: "DGetStringArrOf", dynlib: dllname.}

 
# 开始 

# 普通事件回调函数
proc doEventCallbackProc(f: pointer, args: pointer, argCount: int32): uint =

  # args为一个数组，长度为argCount, argCount最大为12
  var val = proc(index: int): pointer {.nimcall.} =
    return cast[pointer](cast[ptr uint](cast[uint](args) + cast[uint](index * sizeof(int)))[])

  # echo("doEventCallbackProc: f: ", cast[uint](f), ", args: ",cast[uint](args), ", count: ", argCount)

  case argCount
  of 0: 
    cast[proc(){.nimcall.}](f)()
  of 1:
    cast[proc(a1:pointer) {.nimcall.} ](f)(val(0))
  of 2:
    cast[proc(a1,a2:pointer) {.nimcall.} ](f)(val(0), val(1))
  of 3:
    cast[proc(a1,a2,a3:pointer) {.nimcall.} ](f)(val(0), val(1), val(2))
  of 4:
    cast[proc(a1,a2,a3,a4:pointer) {.nimcall.} ](f)(val(0), val(1), val(2), val(3))
  of 5:
    cast[proc(a1,a2,a3,a4,a5:pointer) {.nimcall.} ](f)(val(0), val(1), val(2), val(3), val(4))
  of 6:
    cast[proc(a1,a2,a3,a4,a5,a6:pointer) {.nimcall.} ](f)(val(0), val(1), val(2), val(3), val(4), val(5))
  of 7:
    cast[proc(a1,a2,a3,a4,a5,a6,a7:pointer) {.nimcall.} ](f)(val(0), val(1), val(2), val(3), val(4), val(5), val(6))
  of 8:
    cast[proc(a1,a2,a3,a4,a5,a6,a7,a8:pointer) {.nimcall.} ](f)(val(0), val(1), val(2), val(3), val(4), val(5), val(6), val(7))
  of 9:
    cast[proc(a1,a2,a3,a4,a5,a6,a7,a8,a9:pointer) {.nimcall.} ](f)(val(0), val(1), val(2), val(3), val(4), val(5), val(6), val(7), val(8))
  of 10:
    cast[proc(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10:pointer) {.nimcall.} ](f)(val(0), val(1), val(2), val(3), val(4), val(5), val(6), val(7), val(8), val(9))
  of 11:
    cast[proc(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11:pointer) {.nimcall.} ](f)(val(0), val(1), val(2), val(3), val(4), val(5), val(6), val(7), val(8), val(9), val(10))
  of 12:  
    cast[proc(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12:pointer) {.nimcall.} ](f)(val(0), val(1), val(2), val(3), val(4), val(5), val(6), val(7), val(8), val(9), val(10), val(11))
  else:
    echo("There are more than 12 parameters.")

  return 0

# 窗口消息专用回调
proc doMessageCallbackProc(f: pointer, msg: pointer): uint =
  # 这里要转发消息
  cast[proc(a1:pointer) {.nimcall.} ](f)(msg)
  return 0

# 线程同步专用回调
proc doThreadSyncCallbackProc(): uint =
  return 0

# set callback
SetEventCallback(cast[pointer](doEventCallbackProc))
SetMessageCallback(cast[pointer](doMessageCallbackProc))
SetThreadSyncCallback(cast[pointer](doThreadSyncCallbackProc))