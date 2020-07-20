# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

when defined(gcc) and defined(windows):
  when defined(x86):
    {.link: "appres_386.o".}
  else:  
    {.link: "appres_amd64.o".}

import strutils, vcl, types, fns


type
  TMainForm = ref object of TForm
    memo: TMemo
    edit: TEdit
    lbl1: TLabel
    dlgOpen: TOpenDialog
    # dlgColor: TColorDialog

var 
  mainForm: TMainForm
  form2: TForm

# 单击事件测试
proc onButton1Click(sender: pointer) =
  let btn = AsButton(sender)
  if mainForm.edit != nil:
    mainForm.edit.Text = btn.Caption
  ShowMessage("Hello Nim! Hello 世界！")  
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

# 打开文件对话框测试
proc onBtn2Click(sender: pointer) =
  if mainform.dlgOpen.Execute:
    mainForm.edit.Text = mainform.dlgOpen.FileName
###########################################################################

 
echo("start gui")

Application.Title = "Nim: LCL Application"
Application.MainFormOnTaskBar =true
Application.Initialize

# mainForm，使用lazarus风格的
Application.CreateForm(mainForm)

mainForm.Position = poScreenCenter
mainForm.Caption = "Nim: LCL Form"
mainForm.AllowDropFiles = true
mainForm.OnDropFiles = onDropFiles
mainForm.Height = 550
mainForm.OnMouseMove = onFormMouseMove

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
LoadResFormFile("./Form1.gfm", form2)
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

# memo
mainForm.memo = NewMemo(mainForm)
mainForm.memo.Parent = mainForm
mainForm.memo.Left = 100
mainForm.memo.Top = btnOpenForm2.Top + btnOpenForm2.Height + 10
mainForm.memo.Width = 500
mainForm.memo.Height = 300
mainForm.memo.ScrollBars = ssVertical

# run
Application.Run

echo("end.")