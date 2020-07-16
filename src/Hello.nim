# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

when defined(gcc) and defined(windows):
  when defined(x86):
    {.link: "appres.res".}
  else:  
    {.link: "appres.o".}

import vcl,types


# 单击事件测试
proc onButton1Click(sender: pointer) =
  #echo("Button1 Click: ", Button_GetCaption(sender))
  ShowMessage("Hello Nim! Hello 世界！")

# 拖放文件测试
proc onDropFiles(sender: pointer, fileNames: pointer, len: int) =
  for i in 0..len-1:
    echo("len:", GetStringArrOf(fileNames, i))

###########################################################################

echo("start gui")

Application.SetTitle("Nim: LCL Application")
Application.SetMainFormOnTaskBar(true)
Application.Initialize()

# form
let form = Application.CreateForm()
form.SetPosition(poScreenCenter)
form.SetCaption("Nim: LCL Form")
form.SetAllowDropFiles(true)
form.SetOnDropFiles(onDropFiles)

# button
let btn = NewButton(form)
btn.SetParent(form)
btn.SetCaption("hello")
btn.SetLeft(100)
btn.SetTop(50)
btn.SetOnClick(onButton1Click)



# edit
let edit = NewEdit(form)
edit.SetParent(form)
edit.SetLeft(100)
edit.SetTop(90)
edit.SetWidth(500)

# opendialog
let dlgOpen = NewOpenDialog(form)
let opts = dlgOpen.Options() # 测试集合类型
dlgOpen.SetOptions(opts + {ofAllowMultiSelect,ofViewDetail,ofAutoPreview})

# button
let btn2 = NewButton(form)
btn2.SetParent(form)
btn2.SetCaption("open dialog")
btn2.SetLeft(100)
btn2.SetTop(120)
btn2.SetWidth(100)
btn2.SetOnClick(proc(sender: pointer)=
  if dlgOpen.Execute():
    edit.SetText(dlgOpen.FileName())
)

# 异常捕捉测试
# let ico = Application.GetIcon()
# ico.LoadFromFile("ff.jpg")

# run
Application.Run()

echo("end.")