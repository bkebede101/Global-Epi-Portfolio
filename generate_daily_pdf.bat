@echo off
setlocal

REM Run from repository root.
cd /d %~dp0

if not exist .venv\Scripts\python.exe (
  echo [ERROR] Virtual environment not found at .venv\Scripts\python.exe
  echo Run setup_windows.bat first.
  exit /b 1
)

.venv\Scripts\python.exe puzzle_booklet.py build --input examples\daily_input.json --output out\daily_booklet.pdf
if errorlevel 1 (
  echo [ERROR] PDF generation failed.
  exit /b 1
)

echo [OK] PDF generated: out\daily_booklet.pdf
endlocal
