#---------------------------------------------------------------
import liblcl, vcl, strutils

proc ShowMessage*(msg: string) =
  DShowMessage(msg)

proc ShowMessageFmt*(formatstr: string, a: varargs[string, `$`]) =
  ShowMessage(strutils.format(formatstr, a))

proc GetStringArrOf*(p: pointer, index: int): string =
  return $DGetStringArrOf(p, index)

proc LoadResFormFile*(fileName: string, root: TObject) =
  ResFormLoadFromFile(fileName, CheckPtr(root))