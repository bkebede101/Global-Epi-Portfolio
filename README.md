# Overview
Data Science/Epidemiology

## NYT Personal Puzzle-to-Print Pipeline (MVP)

This repository now includes a **manual-first daily booklet generator** to convert NYT-style daily puzzle content into an **A4 printable PDF** with a dedicated **solutions section at the end**.

### What it does
- Builds one daily PDF booklet covering:
  - Wordle-style grid
  - Sudoku grid
  - Crossword grid + across/down clues
  - Spelling Bee-style letters section
- Appends solutions in a separate end section.
- Adds per-page attribution/footer for personal-use compliance reminders.

### Files
- `puzzle_booklet.py`: CLI tool that reads JSON input and builds a PDF.
- `requirements.txt`: Python dependencies.
- `examples/daily_input.json`: Starter daily input template.
- `web_app.py`: Local website server to generate PDFs visually.
- `web/`: Front-end files (HTML/CSS) for the visual pipeline UI.
- `run_web_app.bat`: One-click launcher for the website UI on Windows.


## Visual website workflow (recommended)

Start a local web app and use a browser interface instead of the terminal:

```bash
python web_app.py
```

Then open `http://127.0.0.1:8080` and:
1. Click **Load Template** (or upload your own JSON).
2. Fill puzzle content.
3. Click **Generate PDF** to download the print-ready booklet.

## Quick Start

### 1) Create a Python environment
```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

### 2) Initialize a template
```bash
python puzzle_booklet.py init-template --output examples/daily_input.json
```

### 3) Fill `examples/daily_input.json`
- Replace placeholders with the day’s puzzle content.
- Keep the JSON structure intact.

### 4) Build the PDF
```bash
python puzzle_booklet.py build --input examples/daily_input.json --output out/daily_booklet.pdf
```


## One-click Windows usage

If you prefer not to run terminal commands manually:

1. Double-click `setup_windows.bat` (first-time setup).
2. For website mode, double-click `run_web_app.bat` and use `http://127.0.0.1:8080`.
3. For direct PDF mode, edit `examples\daily_input.json` and double-click `generate_daily_pdf.bat`.

## Windows daily automation (Task Scheduler)

Use a scheduled task to run once daily.

Example command target:
```text
C:\Path\To\Python\python.exe
```

Arguments:
```text
C:\Path\To\Repo\puzzle_booklet.py build --input C:\Path\To\Repo\examples\daily_input.json --output C:\Path\To\Repo\out\daily_booklet.pdf
```

## Input JSON Notes

- `wordle.solution`: used in answer section.
- `sudoku.grid`: 9x9 with `0` for empty cells.
- `sudoku.solution`: required 9x9 completed grid.
- `crossword.blocked`: boolean grid (`true` for black cells).
- `crossword.numbering`: integer numbering grid for clue starts.
- `crossword.solution_grid`: full solution letters.
- `spelling.center` + `spelling.outer`: letters set.

## Legal/Usage Note

This tool is intended for **personal-use print workflows** only. Puzzle sources and content rights remain with their original owners (e.g., NYT).
