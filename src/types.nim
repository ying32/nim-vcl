type
  TNotifyEvent* = proc(sender: pointer) {.nimcall.}

  TPosition* = enum poDesigned,poDefault,poDefaultposOnly,poDefaultSizeOnly,poScreenCenter,poDesktopCenter,poMainFormCenter,poOwnerFormCenter,poWorkAreaCenter

