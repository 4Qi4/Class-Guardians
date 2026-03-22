@echo off
echo 正在启动班级小助手...
echo 请确保已安装 Python 并已配置环境变量
python --version >nul 2>&1
if errorlevel 1 (
    echo 未检测到 Python，请先安装 Python 并勾选 "Add Python to PATH"
    echo 按任意键退出...
    pause >nul
    exit /b
)
start python start.py
timeout /t 2 /nobreak >nul
start http://localhost:8000
echo 服务器已启动，浏览器将自动打开。
echo 关闭命令提示符窗口即可停止服务。
pause