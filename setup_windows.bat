@echo off
setlocal

REM Run from repository root.
cd /d %~dp0

python -m venv .venv
if errorlevel 1 (
  echo [ERROR] Failed to create virtual environment.
  exit /b 1
)

call .venv\Scripts\activate
if errorlevel 1 (
  echo [ERROR] Failed to activate virtual environment.
  exit /b 1
)

python -m pip install --upgrade pip
python -m pip install -r requirements.txt
if errorlevel 1 (
  echo [ERROR] Failed to install dependencies.
  exit /b 1
)

echo [OK] Setup complete.
echo Next steps:
echo   1) Edit examples\daily_input.json
echo   2) Double-click generate_daily_pdf.bat
endlocal
