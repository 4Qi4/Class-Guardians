' 班级小助手启动器 - VBS版本
' 无需修改PowerShell策略，双击即可运行

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' 获取当前脚本所在目录
strPath = objFSO.GetParentFolderName(WScript.ScriptFullName)
objShell.CurrentDirectory = strPath

' 显示启动信息
objShell.Popup "班级小助手启动中..." & vbCrLf & vbCrLf & "正在检测Python环境...", 2, "班级小助手", 64

' 检查 Python 是否已安装
Set objExec = objShell.Exec("python --version")
strPythonVersion = ""

Do While objExec.StdOut.AtEndOfStream <> True
    strPythonVersion = objExec.StdOut.ReadLine()
Loop

If strPythonVersion = "" Then
    ' Python未安装，询问是否自动安装
    intAnswer = objShell.Popup("未检测到Python环境！" & vbCrLf & vbCrLf & _
                                "是否自动下载并安装Python 3.12.4？" & vbCrLf & _
                                "(安装过程约需2-3分钟，需要联网)" & vbCrLf & vbCrLf & _
                                "安装完成后需要重启电脑才能生效。", _
                                0, "班级小助手 - 需要Python", 4 + 32)
    
    If intAnswer = 6 Then
        ' 用户选择是，下载并安装Python
        objShell.Popup "正在下载Python安装包..." & vbCrLf & vbCrLf & _
                       "请稍候，约25MB，网速不同可能需要1-3分钟", 3, "班级小助手", 64
        
        ' 下载Python安装包
        strPythonInstaller = strPath & "\python-3.12.4-amd64.exe"
        strPythonUrl = "https://www.python.org/ftp/python/3.12.4/python-3.12.4-amd64.exe"
        
        Set objXML = CreateObject("MSXML2.XMLHTTP")
        objXML.Open "GET", strPythonUrl, False
        objXML.Send
        
        If objXML.Status = 200 Then
            ' 保存文件
            Set objStream = CreateObject("ADODB.Stream")
            objStream.Type = 1
            objStream.Open
            objStream.Write objXML.ResponseBody
            objStream.SaveToFile strPythonInstaller, 2
            objStream.Close
            
            objShell.Popup "Python安装包下载完成！" & vbCrLf & vbCrLf & _
                           "正在安装Python...", 2, "班级小助手", 64
            
            ' 静默安装Python
            objShell.Run """" & strPythonInstaller & """ /quiet InstallAllUsers=1 PrependPath=1", 0, True
            
            ' 删除安装文件
            objFSO.DeleteFile strPythonInstaller
            
            objShell.Popup "Python安装完成！" & vbCrLf & vbCrLf & _
                           "请重启电脑后再次运行本程序。" & vbCrLf & vbCrLf & _
                           "按确定后退出。", 5, "班级小助手", 64
            WScript.Quit
        Else
            objShell.Popup "下载Python失败，请检查网络连接。" & vbCrLf & vbCrLf & _
                           "或者手动访问 https://www.python.org/downloads/ 下载安装。" & vbCrLf & _
                           "安装时务必勾选 'Add Python to PATH'", 10, "班级小助手", 16
            WScript.Quit
        End If
    Else
        WScript.Quit
    End If
Else
    objShell.Popup "检测到Python环境：" & strPythonVersion, 2, "班级小助手", 64
End If

' 检查 index.html 文件是否存在
If Not objFSO.FileExists(strPath & "\index.html") Then
    objShell.Popup "未找到 index.html 文件！" & vbCrLf & vbCrLf & _
                   "请将班级小助手的HTML文件（index.html）放入本文件夹。" & vbCrLf & vbCrLf & _
                   "按确定后退出。", 10, "班级小助手", 16
    WScript.Quit
End If

' 创建 start.py 文件（如果不存在）
If Not objFSO.FileExists(strPath & "\start.py") Then
    Set objFile = objFSO.CreateTextFile(strPath & "\start.py", True)
    objFile.WriteLine "#!/usr/bin/env python3"
    objFile.WriteLine "# -*- coding: utf-8 -*-"
    objFile.WriteLine "import http.server"
    objFile.WriteLine "import socketserver"
    objFile.WriteLine "import webbrowser"
    objFile.WriteLine "import threading"
    objFile.WriteLine "import os"
    objFile.WriteLine ""
    objFile.WriteLine "PORT = 8000"
    objFile.WriteLine "Handler = http.server.SimpleHTTPRequestHandler"
    objFile.WriteLine ""
    objFile.WriteLine "def open_browser():"
    objFile.WriteLine "    webbrowser.open(f'http://localhost:{PORT}')"
    objFile.WriteLine ""
    objFile.WriteLine "if __name__ == '__main__':"
    objFile.WriteLine "    os.chdir(os.path.dirname(os.path.abspath(__file__)))"
    objFile.WriteLine "    with socketserver.TCPServer(('', PORT), Handler) as httpd:"
    objFile.WriteLine "        print(f'\n? 班级小助手已启动！')"
    objFile.WriteLine "        print(f'?? 访问地址: http://localhost:{PORT}')"
    objFile.WriteLine "        print('?? 按 Ctrl+C 可关闭服务器\n')"
    objFile.WriteLine "        threading.Timer(1, open_browser).start()"
    objFile.WriteLine "        try:"
    objFile.WriteLine "            httpd.serve_forever()"
    objFile.WriteLine "        except KeyboardInterrupt:"
    objFile.WriteLine "            print('\n?? 服务器已关闭')"
    objFile.Close
End If

' 启动服务器（在新窗口中）
objShell.Popup "正在启动班级小助手服务器..." & vbCrLf & vbCrLf & _
               "服务器窗口即将打开，请勿关闭！", 2, "班级小助手", 64

objShell.Run "cmd /c start python start.py", 0, False

' 等待服务器启动
WScript.Sleep 3000

' 打开浏览器
objShell.Run "http://localhost:8000", 1, False

' 显示提示信息
objShell.Popup "班级小助手已启动！" & vbCrLf & vbCrLf & _
               "服务器正在后台运行。" & vbCrLf & _
               "浏览器应该已经自动打开。" & vbCrLf & vbCrLf & _
               "如需关闭服务器：" & vbCrLf & _
               "1. 找到标题为 'python' 的命令提示符窗口" & vbCrLf & _
               "2. 关闭该窗口即可停止服务" & vbCrLf & vbCrLf & _
               "按确定继续...", 8, "班级小助手", 64