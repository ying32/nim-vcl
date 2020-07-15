# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

when defined(gcc) and defined(windows):
  when defined(x86):
    {.link: "appres.res".}
  else:  
    {.link: "appres.o".}

import vcl,types



proc onButton1Click(sender: pointer) =
  #echo("Button1 Click: ", Button_GetCaption(sender))
  ShowMessage("Hello Nim! Hello 世界！")

###########################################################################

echo("start gui")

Application.SetTitle("Nim: LCL Application")
Application.SetMainFormOnTaskBar(true)
Application.Initialize()

let form = Application.CreateForm()
form.SetPosition(poScreenCenter)
form.SetCaption("Nim: LCL Form")

let btn = NewButton(form)
btn.SetParent(form)
btn.SetCaption("button1")
btn.SetLeft(100)
btn.SetTop(50)
btn.SetOnClick(onButton1Click)


Application.Run()

echo("end.")