#! /opt/homebrew/bin/python3
from __future__ import annotations

import argparse
import enum
import re
from dataclasses import dataclass
from datetime import date, timedelta
from pathlib import Path
from typing import Generic, TypeVar, Iterable, List

from mistletoe.block_token import BlockToken, ThematicBreak, Paragraph, ListItem
from mistletoe.markdown_renderer import MarkdownRenderer
from mistletoe.span_token import RawText, LineBreak, HTMLSpan
from mistletoe.token import Token

T = TypeVar("T")
K = TypeVar("K")


@dataclass
class Range(Generic[T]):
    start: T
    end: T


def date_range(start: date, end: date, step: int = 1) -> Iterable[date]:
    delta_days = (end - start).days
    return (
        start + timedelta(days=d)
        for d in range(0, delta_days, step)
    )


class Actions(enum.Enum):
    CREATE: str = "CREATE"


@dataclass
class Arguments:
    action: Actions
    directory: Path
    range: Range[date]

    @classmethod
    def parse(cls) -> Arguments:
        today: date = date.today()
        yesterday: date = today - timedelta(days=1)

        parser = argparse.ArgumentParser(
            prog='Journal',
            description='Helps creating journal-related .md files',
        )
        parser.add_argument('action', choices=["create"])  # positional argument
        parser.add_argument('--dir', default="~/.canelhasmateus/journal")  # positional argument
        parser.add_argument('--start', default=yesterday.isoformat())  # positional argument
        parser.add_argument('--end', default=today.isoformat())  # positional argument

        parsed_args = parser.parse_args()
        return Arguments(
            action=parsed_args.action,
            directory=Path(parsed_args.dir),
            range=Range(
                date.fromisoformat(parsed_args.start),
                date.fromisoformat(parsed_args.end)
            ),
        )

    def __iter__(self) -> Iterable[Path]:
        def in_range(p: Path) -> bool:
            return self.range.start.isoformat() <= p.stem <= self.range.end.isoformat()

        return sorted(
            filter(in_range, self.directory.expanduser().glob('*.md')),
            key=lambda f: f.stem,
        ).__iter__()


@dataclass
class Journal:
    tasks: List[Todo]

    @classmethod
    def parse(cls, content: str) -> Journal:
        ...


@dataclass
class Todo:
    token: Token


todo_pattern = re.compile(r"\s*\*?\s*\[ ]")


def __from_item(item: ListItem) -> Todo:
    content = "???"
    childs = []
    for child in item.children:

        if isinstance(child, Paragraph):
            for txt in child.children:
                if isinstance(txt, RawText):
                    if todo_pattern.match(txt.content):
                        content = txt.content

        elif isinstance(child, mistletoe.block_token.List):
            for subitem in child.children:
                if isinstance(subitem, ListItem):
                    childs.append(__from_item(subitem))

    return Todo(token=item)


def todos(block: BlockToken) -> Iterable[Todo]:
    for tk in dfs(block, ListItem.__instancecheck__):
        if isinstance(tk, RawText) and todo_pattern.match(tk.content):
            yield Todo(token=tk)

        elif isinstance(tk, ListItem):
            for child in tk.children:
                if isinstance(child, Paragraph):
                    for txt in child.children:
                        if isinstance(txt, RawText) and todo_pattern.match(txt.content):
                            yield Todo(token=tk)


def dfs(block: BlockToken, filter=lambda x: False) -> Iterable[Token]:
    stack = [block]
    while len(stack):
        current = stack.pop()
        yield current

        if filter(current):
            continue

        if isinstance(current, (ThematicBreak, RawText, LineBreak, HTMLSpan)):
            # these are terminal and have no children
            continue

        children = current.children
        if isinstance(children, Iterable):
            stack.extend(children)
        else:
            stack.append(children)


if __name__ == '__main__':
    import mistletoe

    args = Arguments.parse()

    fragments = []
    with MarkdownRenderer() as renderer:
        for file in args:
            with file.open() as f:
                doc = mistletoe.Document(f)
                for todo in todos(doc):
                    fragments.append(
                        renderer.render(todo.token)
                    )

    print("".join(fragments))