#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
班级小助手 - 本地服务器启动器
双击运行即可在 http://localhost:8000 访问班级小助手
"""

import http.server
import socketserver
import webbrowser
import threading
import os

PORT = 8000
Handler = http.server.SimpleHTTPRequestHandler

def open_browser():
    """延迟1秒打开浏览器"""
    webbrowser.open(f'http://localhost:{PORT}')

if __name__ == "__main__":
    # 切换到脚本所在目录，确保能正确加载 index.html
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print(f"\n✅ 班级小助手已启动！")
        print(f"📌 访问地址：http://localhost:{PORT}")
        print("🔒 按 Ctrl+C 可关闭服务器\n")
        
        # 自动打开浏览器
        threading.Timer(1, open_browser).start()
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n🛑 服务器已关闭")