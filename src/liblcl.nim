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
  
  # TForm
proc Form_SetPosition*(obj: pointer, val: TPosition)  {.importc: "Form_SetPosition", dynlib: dllname.}
proc Form_SetCaption*(obj: pointer, val: cstring) {.importc: "Form_SetCaption", dynlib: dllname.}

  # TButton
proc Button_Create*(owner: pointer): pointer  {.importc: "Button_Create", dynlib: dllname.}
proc Button_SetParent*(obj: pointer, parent: pointer)  {.importc: "Button_SetParent", dynlib: dllname.}
proc Button_SetOnClick*(obj: pointer, event: TNotifyEvent)  {.importc: "Button_SetOnClick", dynlib: dllname.}
proc Button_SetCaption*(obj: pointer, val: cstring)  {.importc: "Button_SetCaption", dynlib: dllname.}
proc Button_SetLeft*(obj: pointer, val: int32)  {.importc: "Button_SetLeft", dynlib: dllname.}
proc Button_SetTop*(obj: pointer, val: int32)  {.importc: "Button_SetTop", dynlib: dllname.}
proc Button_GetCaption*(obj: pointer): cstring  {.importc: "Button_GetCaption", dynlib: dllname.}

  # callback
proc SetEventCallback(callback: pointer)  {.importc: "SetEventCallback", dynlib: dllname.}
proc SetMessageCallback(callback: pointer)  {.importc: "SetMessageCallback", dynlib: dllname.}
proc SetThreadSyncCallback(callback: pointer)  {.importc: "SetThreadSyncCallback", dynlib: dllname.}

proc DShowMessage*(msg: cstring) {.importc: "DShowMessage", dynlib: dllname.}

 
# 开始 

proc doEventCallbackProc(f: pointer, args: pointer, argCount: int32): uint =

  # args为一个数组，长度为argCount,argCount最大为12
  var val = proc (index: int): uint {.nimcall.} =
    return cast[ptr uint](cast[uint](args) + cast[uint](index * sizeof(int)))[]

  echo("doEventCallbackProc: f: ", cast[uint](f), ", args: ",cast[uint](args), ", count: ", argCount)
  # echo("args:", cast[uint](getParamOf(0, args)))
  case argCount
  of 0: 
    cast[proc(){.nimcall.}](f)()
  of 1:
    cast[proc(a1:uint) {.nimcall.} ](f)(val(0))
  of 2:
    cast[proc(a1,a2:uint) {.nimcall.} ](f)(val(0), val(1))
  of 3:
    cast[proc(a1,a2,a3:uint) {.nimcall.} ](f)(val(0), val(1), val(2))
  of 4:
    cast[proc(a1,a2,a3,a4:uint) {.nimcall.} ](f)(val(0), val(1), val(2), val(3))
  # of 5:
  #    echo(1)
  # of 6:
  #    echo(1)
  # of 7:
  #    echo(1)
  # of 8:
  #    echo(1)
  # of 9:
  #    echo(1)
  # of 10:
  #    echo(1)
  # of 11:
  #    echo(1)
  # of 12:  
  #    echo(1)
  else:
    echo("参数超出12个了")

  return 0


# set callback
SetEventCallback(cast[pointer](doEventCallbackProc))
