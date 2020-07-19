# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

when defined(gcc) and defined(windows):
  when defined(x86):
    {.link: "appres_386.o".}
  else:  
    {.link: "appres_amd64.o".}

import strutils,vcl,types,fns

var 
  memo: TMemo
  edit: TEdit
  lbl1: TLabel

# 单击事件测试
proc onButton1Click(sender: pointer) =
  let btn = AsButton(sender)
  if edit != nil:
    edit.Text = btn.Caption
  ShowMessage("Hello Nim! Hello 世界！")  
  # ShowMessageFmt("Hello Nim! Hello 世界！ $1", "xxx")


# 拖放文件测试
proc onDropFiles(sender: pointer, fileNames: pointer, len: int) =
  for i in 0..len-1:
    let fName = GetFPStringArrayMember(fileNames, i)
    echo(i, ":", fName)
    if memo != nil:
      memo.Append(fName)

# 窗口鼠标移动
proc onFormMouseMove(sender: pointer, shift: TShiftState, x: int32, y: int32) =
  if lbl1 != nil:
    let sp = Mouse.CursorPos
    lbl1.Caption = format("p: x=$1, y=$2, screen: x=$3, y=$4", x, y, sp.x, sp.y)
  # discard

###########################################################################

echo("start gui")

Application.Title = "Nim: LCL Application"
Application.MainFormOnTaskBar =true
Application.Initialize

# form
let form = Application.CreateForm(false)
form.Position = poScreenCenter
form.Caption = "Nim: LCL Form"
form.AllowDropFiles = true
form.OnDropFiles = onDropFiles
form.Height = 550
form.OnMouseMove = onFormMouseMove

#label
lbl1 = NewLabel(form)
lbl1.Parent = form
lbl1.Left = 100
lbl1.Top = 20


# button
let btn = NewButton(form)
btn.Parent = form
btn.Caption = "hello"
btn.Left = 100
btn.Top = 50
btn.OnClick = onButton1Click



# edit
edit = NewEdit(form)
edit.Parent = form
edit.Left = 100
edit.Top = 90
edit.Width = 500

# opendialog
let dlgOpen = NewOpenDialog(form)
# 测试集合类型
dlgOpen.Options = dlgOpen.Options + {ofAllowMultiSelect, ofViewDetail, ofAutoPreview}

# button
let btn2 = NewButton(form)
btn2.Parent = form
btn2.Caption = "open dialog"
btn2.Left = 100
btn2.Top = 120
btn2.Width = 100
btn2.OnClick = proc(sender: pointer)=
  if dlgOpen.Execute:
    edit.Text = dlgOpen.FileName

# ResForm
let form2 = Application.CreateForm(false)
LoadResFormFile("./Form1.gfm", form2)
# 这里测试直接查找form2的按钮
let obj = form2.FindComponent("Button1")
if obj != nil:
  cast[TButton](obj).OnClick = onButton1Click

# openfiledialog
let btnOpenForm2 = NewButton(form)
btnOpenForm2.Parent = form
btnOpenForm2.Caption = "Open Form2"
btnOpenForm2.Left = 100
btnOpenForm2.Top = btn2.Top + btn2.Height + 10
btnOpenForm2.Width = 100
btnOpenForm2.OnClick = proc(sender: pointer)=
  form2.Show


# opencolordialog
let dlgColor = NewColorDialog(form)
let btnOpenColordlg = NewButton(form)
btnOpenColordlg.Parent = form
btnOpenColordlg.Caption = "Open dlgColor"
btnOpenColordlg.Left = 100 + btnOpenForm2.Width + 10
btnOpenColordlg.Top = btnOpenForm2.Top
btnOpenColordlg.Width = 100
btnOpenColordlg.OnClick = proc(sender: pointer)=
  if dlgColor.Execute:
    lbl1.Font.Color = dlgColor.Color

# memo
memo = NewMemo(form)
memo.Parent = form
memo.Left = 100
memo.Top = btnOpenForm2.Top + btnOpenForm2.Height + 10
memo.Width = 500
memo.Height = 300
memo.ScrollBars = ssVertical

# run
Application.Run

echo("end.")