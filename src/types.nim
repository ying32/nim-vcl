type
  TNotifyEvent* = proc(sender: pointer) {.nimcall.}
  
  TDropFilesEvent* = proc(sender: pointer, aFileNames: pointer, len: int) {.nimcall.}

  TPosition* = enum poDesigned,poDefault,poDefaultposOnly,poDefaultSizeOnly,poScreenCenter,poDesktopCenter,poMainFormCenter,poOwnerFormCenter,poWorkAreaCenter

