#---------------------------------------------------------------
import liblcl, vcl, strutils

proc ShowMessage*(msg: string) =
  DShowMessage(msg)

proc ShowMessageFmt*(formatstr: string, a: varargs[string, `$`]) =
  ShowMessage(strutils.format(formatstr, a))

proc GetFPStringArrayMember*(p: pointer, index: int): string =
  return $DGetStringArrOf(p, index)

proc LoadResFormFile*(fileName: string, root: TObject) =
  ResFormLoadFromFile(fileName, CheckPtr(root))


# type
#   Test1*  {.inheritable.} = ref object
#     width: int

#   Test2* = ref object of Test1



# proc `width=`*(s: var Test1, value: int) {.inline} =
#   echo("call Test1 set width")
#   #s.width = value

# proc width*(s: Test1): int {.inline} = 
#   echo("call Test1 get width")
#   #s.width

# proc `width=`*(s: var Test2, value: int) {.inline} =
#   echo("call Test2 set width")
#   #s.width = value

# proc width*(s: Test2): int {.inline} = 
#   echo("call Test2 get width")
#   #s.width