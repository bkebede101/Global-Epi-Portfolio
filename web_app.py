#!/usr/bin/env python3
"""Local web interface for the puzzle booklet pipeline."""

from __future__ import annotations

import json
import tempfile
from datetime import date
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, HTTPServer
from pathlib import Path

from puzzle_booklet import build_pdf, load_package

HOST = "127.0.0.1"
PORT = 8080
WEB_DIR = Path(__file__).parent / "web"


def make_template() -> dict:
    return {
        "date": str(date.today()),
        "source": "NYT",
        "wordle": {"answer_length": 5, "max_rows": 6, "allowed_guesses": [], "solution": ""},
        "sudoku": {"grid": [[0] * 9 for _ in range(9)], "solution": [[0] * 9 for _ in range(9)]},
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


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            self._serve_file(WEB_DIR / "index.html", "text/html; charset=utf-8")
            return
        if self.path == "/styles.css":
            self._serve_file(WEB_DIR / "styles.css", "text/css; charset=utf-8")
            return
        if self.path == "/template":
            self._json_response(make_template())
            return
        if self.path == "/health":
            self._json_response({"ok": True})
            return
        self.send_error(HTTPStatus.NOT_FOUND)

    def do_POST(self):
        if self.path != "/generate":
            self.send_error(HTTPStatus.NOT_FOUND)
            return

        length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(length)

        try:
            payload = json.loads(body.decode("utf-8"))
            with tempfile.TemporaryDirectory() as td:
                td_path = Path(td)
                input_path = td_path / "input.json"
                output_path = td_path / "booklet.pdf"
                input_path.write_text(json.dumps(payload), encoding="utf-8")

                pkg = load_package(input_path)
                build_pdf(pkg, output_path)
                pdf = output_path.read_bytes()

            self.send_response(HTTPStatus.OK)
            self.send_header("Content-Type", "application/pdf")
            self.send_header("Content-Length", str(len(pdf)))
            self.end_headers()
            self.wfile.write(pdf)
        except Exception as exc:
            self.send_response(HTTPStatus.BAD_REQUEST)
            self.send_header("Content-Type", "text/plain; charset=utf-8")
            msg = str(exc).encode("utf-8")
            self.send_header("Content-Length", str(len(msg)))
            self.end_headers()
            self.wfile.write(msg)

    def _serve_file(self, path: Path, content_type: str):
        if not path.exists():
            self.send_error(HTTPStatus.NOT_FOUND)
            return
        data = path.read_bytes()
        self.send_response(HTTPStatus.OK)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def _json_response(self, payload: dict):
        data = json.dumps(payload).encode("utf-8")
        self.send_response(HTTPStatus.OK)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)


def main() -> None:
    server = HTTPServer((HOST, PORT), Handler)
    print(f"Puzzle web app running at http://{HOST}:{PORT}")
    server.serve_forever()


if __name__ == "__main__":
    main()
