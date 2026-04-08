@echo off
setlocal

cd /d %~dp0

if not exist .venv\Scripts\python.exe (
  echo [ERROR] Virtual environment not found at .venv\Scripts\python.exe
  echo Run setup_windows.bat first.
  exit /b 1
)

echo Starting web app on http://127.0.0.1:8080 ...
.venv\Scripts\python.exe web_app.py
endlocal
