#!/usr/bin/env python3
"""Daily NYT-style puzzle booklet generator (personal-use print workflow).

Phase 1 focuses on manual/semi-manual input with stable PDF generation.
"""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from datetime import date
from pathlib import Path
from typing import Any

import typer
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.platypus import (
    PageBreak,
    Paragraph,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)

app = typer.Typer(help="Generate daily A4 puzzle booklets with end-of-booklet solutions.")

ATTRIBUTION = "Source attribution: NYT game format/content reference. Personal-use print copy only."


@dataclass
class WordlePuzzle:
    answer_length: int = 5
    max_rows: int = 6
    allowed_guesses: list[str] = field(default_factory=list)
    solution: str = ""


@dataclass
class SudokuPuzzle:
    grid: list[list[int]] = field(default_factory=list)
    solution: list[list[int]] = field(default_factory=list)


@dataclass
class CrosswordPuzzle:
    rows: int = 0
    cols: int = 0
    blocked: list[list[bool]] = field(default_factory=list)
    numbering: list[list[int]] = field(default_factory=list)
    across_clues: list[str] = field(default_factory=list)
    down_clues: list[str] = field(default_factory=list)
    solution_grid: list[list[str]] = field(default_factory=list)


@dataclass
class SpellingPuzzle:
    center: str = ""
    outer: list[str] = field(default_factory=list)
    pangrams: list[str] = field(default_factory=list)
    answers: list[str] = field(default_factory=list)


@dataclass
class DailyPackage:
    date_str: str
    source: str
    wordle: WordlePuzzle | None = None
    sudoku: SudokuPuzzle | None = None
    crossword: CrosswordPuzzle | None = None
    spelling: SpellingPuzzle | None = None


def _validate_square_grid(grid: list[list[Any]], n: int, name: str) -> None:
    if len(grid) != n:
        raise ValueError(f"{name} must have {n} rows.")
    for row in grid:
        if len(row) != n:
            raise ValueError(f"{name} must have {n} columns in every row.")


def load_package(path: Path) -> DailyPackage:
    raw = json.loads(path.read_text(encoding="utf-8"))

    pkg = DailyPackage(
        date_str=raw.get("date", str(date.today())),
        source=raw.get("source", "NYT"),
    )

    if "wordle" in raw and raw["wordle"]:
        w = raw["wordle"]
        pkg.wordle = WordlePuzzle(
            answer_length=int(w.get("answer_length", 5)),
            max_rows=int(w.get("max_rows", 6)),
            allowed_guesses=list(w.get("allowed_guesses", [])),
            solution=str(w.get("solution", "")).upper(),
        )

    if "sudoku" in raw and raw["sudoku"]:
        s = raw["sudoku"]
        grid = s.get("grid", [])
        solution = s.get("solution", [])
        _validate_square_grid(grid, 9, "Sudoku grid")
        _validate_square_grid(solution, 9, "Sudoku solution")
        pkg.sudoku = SudokuPuzzle(grid=grid, solution=solution)

    if "crossword" in raw and raw["crossword"]:
        c = raw["crossword"]
        rows, cols = int(c.get("rows", 0)), int(c.get("cols", 0))
        blocked = c.get("blocked", [])
        numbering = c.get("numbering", [])
        solution_grid = c.get("solution_grid", [])
        if len(blocked) != rows or any(len(r) != cols for r in blocked):
            raise ValueError("Crossword blocked grid shape does not match rows/cols.")
        if len(numbering) != rows or any(len(r) != cols for r in numbering):
            raise ValueError("Crossword numbering grid shape does not match rows/cols.")
        if len(solution_grid) != rows or any(len(r) != cols for r in solution_grid):
            raise ValueError("Crossword solution grid shape does not match rows/cols.")

        pkg.crossword = CrosswordPuzzle(
            rows=rows,
            cols=cols,
            blocked=blocked,
            numbering=numbering,
            across_clues=list(c.get("across_clues", [])),
            down_clues=list(c.get("down_clues", [])),
            solution_grid=solution_grid,
        )

    if "spelling" in raw and raw["spelling"]:
        sp = raw["spelling"]
        pkg.spelling = SpellingPuzzle(
            center=str(sp.get("center", "")).upper(),
            outer=[str(x).upper() for x in sp.get("outer", [])],
            pangrams=[str(x).upper() for x in sp.get("pangrams", [])],
            answers=[str(x).upper() for x in sp.get("answers", [])],
        )

    return pkg


def _footer(canvas, doc):
    canvas.saveState()
    canvas.setFont("Helvetica", 8)
    canvas.setFillColor(colors.grey)
    canvas.drawString(20 * mm, 10 * mm, ATTRIBUTION)
    canvas.drawRightString(A4[0] - 20 * mm, 10 * mm, f"Page {doc.page}")
    canvas.restoreState()


def _render_wordle_story(story: list[Any], styles: dict[str, ParagraphStyle], puzzle: WordlePuzzle):
    story.append(Paragraph("Wordle", styles["Heading2"]))
    story.append(Paragraph("Guess the 5-letter word in 6 tries.", styles["BodyText"]))
    size = 22
    data = [["" for _ in range(puzzle.answer_length)] for _ in range(puzzle.max_rows)]
    t = Table(data, colWidths=[size for _ in range(puzzle.answer_length)], rowHeights=[size for _ in range(puzzle.max_rows)])
    t.setStyle(
        TableStyle(
            [
                ("GRID", (0, 0), (-1, -1), 1, colors.black),
                ("ALIGN", (0, 0), (-1, -1), "CENTER"),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
            ]
        )
    )
    story.append(t)
    story.append(Spacer(1, 6 * mm))


def _render_sudoku_story(story: list[Any], styles: dict[str, ParagraphStyle], puzzle: SudokuPuzzle):
    story.append(Paragraph("Sudoku", styles["Heading2"]))
    story.append(Paragraph("Fill each row, column, and 3×3 box with digits 1-9.", styles["BodyText"]))
    size = 18
    data = [[str(v) if v else "" for v in row] for row in puzzle.grid]
    t = Table(data, colWidths=[size] * 9, rowHeights=[size] * 9)
    tbl_style = [("GRID", (0, 0), (-1, -1), 0.5, colors.black), ("ALIGN", (0, 0), (-1, -1), "CENTER")]
    for i in range(0, 10, 3):
        if i > 0:
            tbl_style.append(("LINEABOVE", (0, i), (-1, i), 1.5, colors.black))
            tbl_style.append(("LINEBEFORE", (i, 0), (i, -1), 1.5, colors.black))
    t.setStyle(TableStyle(tbl_style))
    story.append(t)
    story.append(Spacer(1, 6 * mm))


def _render_crossword_story(story: list[Any], styles: dict[str, ParagraphStyle], puzzle: CrosswordPuzzle):
    story.append(Paragraph("Crossword", styles["Heading2"]))
    story.append(Paragraph("Fill entries using Across and Down clues.", styles["BodyText"]))

    cell = 16
    data: list[list[str]] = [["" for _ in range(puzzle.cols)] for _ in range(puzzle.rows)]
    t = Table(data, colWidths=[cell] * puzzle.cols, rowHeights=[cell] * puzzle.rows)
    ts = [("GRID", (0, 0), (-1, -1), 0.5, colors.black)]
    for r in range(puzzle.rows):
        for c in range(puzzle.cols):
            if puzzle.blocked[r][c]:
                ts.append(("BACKGROUND", (c, r), (c, r), colors.black))
            elif puzzle.numbering[r][c] > 0:
                ts.append(("TEXTCOLOR", (c, r), (c, r), colors.darkblue))
                data[r][c] = str(puzzle.numbering[r][c])
    t.setStyle(TableStyle(ts))
    story.append(t)
    story.append(Spacer(1, 3 * mm))
    story.append(Paragraph("Across", styles["Heading3"]))
    for clue in puzzle.across_clues:
        story.append(Paragraph(clue, styles["BodyText"]))
    story.append(Spacer(1, 2 * mm))
    story.append(Paragraph("Down", styles["Heading3"]))
    for clue in puzzle.down_clues:
        story.append(Paragraph(clue, styles["BodyText"]))


def _render_spelling_story(story: list[Any], styles: dict[str, ParagraphStyle], puzzle: SpellingPuzzle):
    story.append(Paragraph("Spelling Bee", styles["Heading2"]))
    story.append(Paragraph("Build words of 4+ letters using the center letter in every word.", styles["BodyText"]))
    letters = " ".join(puzzle.outer[:3]) + f"   [{puzzle.center}]   " + " ".join(puzzle.outer[3:])
    story.append(Paragraph(f"Letters: {letters}", styles["BodyText"]))
    story.append(Spacer(1, 6 * mm))


def build_pdf(pkg: DailyPackage, output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    doc = SimpleDocTemplate(str(output_path), pagesize=A4, leftMargin=18 * mm, rightMargin=18 * mm, topMargin=18 * mm, bottomMargin=18 * mm)
    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle(name="Muted", parent=styles["BodyText"], textColor=colors.grey))

    story: list[Any] = []
    story.append(Paragraph(f"Daily Puzzle Booklet — {pkg.date_str}", styles["Title"]))
    story.append(Spacer(1, 2 * mm))
    story.append(Paragraph("A4 print-ready booklet for personal daily cognitive practice.", styles["BodyText"]))
    story.append(Paragraph(f"Source: {pkg.source}", styles["Muted"]))
    story.append(Spacer(1, 5 * mm))

    if pkg.wordle:
        _render_wordle_story(story, styles, pkg.wordle)
    if pkg.sudoku:
        _render_sudoku_story(story, styles, pkg.sudoku)
    if pkg.crossword:
        _render_crossword_story(story, styles, pkg.crossword)
    if pkg.spelling:
        _render_spelling_story(story, styles, pkg.spelling)

    story.append(PageBreak())
    story.append(Paragraph("Solutions", styles["Title"]))
    story.append(Spacer(1, 2 * mm))

    if pkg.wordle:
        story.append(Paragraph(f"Wordle: {pkg.wordle.solution}", styles["BodyText"]))
    if pkg.sudoku:
        story.append(Spacer(1, 2 * mm))
        story.append(Paragraph("Sudoku", styles["Heading2"]))
        data = [[str(v) for v in row] for row in pkg.sudoku.solution]
        t = Table(data, colWidths=[14] * 9, rowHeights=[14] * 9)
        t.setStyle(TableStyle([("GRID", (0, 0), (-1, -1), 0.5, colors.black), ("ALIGN", (0, 0), (-1, -1), "CENTER")]))
        story.append(t)
    if pkg.crossword:
        story.append(Spacer(1, 3 * mm))
        story.append(Paragraph("Crossword", styles["Heading2"]))
        rows = []
        for r in range(pkg.crossword.rows):
            row = []
            for c in range(pkg.crossword.cols):
                row.append("■" if pkg.crossword.blocked[r][c] else pkg.crossword.solution_grid[r][c])
            rows.append(row)
        t = Table(rows, colWidths=[12] * pkg.crossword.cols, rowHeights=[12] * pkg.crossword.rows)
        t.setStyle(TableStyle([("GRID", (0, 0), (-1, -1), 0.5, colors.black), ("ALIGN", (0, 0), (-1, -1), "CENTER")]))
        story.append(t)
    if pkg.spelling:
        story.append(Spacer(1, 3 * mm))
        story.append(Paragraph("Spelling Bee", styles["Heading2"]))
        story.append(Paragraph(f"Pangrams: {', '.join(pkg.spelling.pangrams)}", styles["BodyText"]))
        story.append(Paragraph(f"Accepted answers ({len(pkg.spelling.answers)}):", styles["BodyText"]))
        story.append(Paragraph(", ".join(pkg.spelling.answers), styles["BodyText"]))

    doc.build(story, onFirstPage=_footer, onLaterPages=_footer)


@app.command()
def init_template(output: Path = Path("daily_template.json")):
    """Write a starter JSON template for daily puzzle inputs."""
    template = {
        "date": str(date.today()),
        "source": "NYT",
        "wordle": {"answer_length": 5, "max_rows": 6, "allowed_guesses": [], "solution": ""},
        "sudoku": {
            "grid": [[0] * 9 for _ in range(9)],
            "solution": [[0] * 9 for _ in range(9)],
        },
        "crossword": {
            "rows": 5,
            "cols": 5,
            "blocked": [[False] * 5 for _ in range(5)],
            "numbering": [[0] * 5 for _ in range(5)],
            "across_clues": ["1. Example clue"],
            "down_clues": ["1. Example clue"],
            "solution_grid": [["A"] * 5 for _ in range(5)],
        },
        "spelling": {"center": "A", "outer": ["B", "C", "D", "E", "F", "G"], "pangrams": [], "answers": []},
    }
    output.write_text(json.dumps(template, indent=2), encoding="utf-8")
    typer.echo(f"Template written to {output}")


@app.command()
def build(input_json: Path = typer.Option(..., "--input", help="Path to daily input JSON."), output_pdf: Path = typer.Option(Path("out/daily_booklet.pdf"), "--output", help="Output PDF path.")):
    """Build the daily A4 puzzle booklet PDF from input JSON."""
    pkg = load_package(input_json)
    build_pdf(pkg, output_pdf)
    typer.echo(f"PDF written to {output_pdf}")


if __name__ == "__main__":
    app()
