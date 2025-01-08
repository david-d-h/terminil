import terminil/clear.{type ClearType}
import terminil/cursor/style.{type Style as CursorStyle} as cursor_style
import terminil/escape
import terminil/style/attribute.{type Attribute}
import terminil/style/bundle.{type Bundle}
import terminil/style/color.{type Color}

import gleam/int
import gleam/list
import gleam/option.{type Option}

pub type Batch =
  List(Command)

/// Represents all supported terminal commands.
///
/// Commands manipulate the terminal in some way, they can be used to,
/// for example, hide and show the cursor, leave and enter an alternate
/// screen, and more.
///
/// ### Note
///
/// A `Command` does nothing on it's own, it *must* be executed.
pub type Command {
  /// Represents a "noop", no command.
  Noop

  /// Holds multiple commands that are to be executed at the same time.
  Batch(Batch)

  /// Prints the given string.
  Print(String)

  /// Shows the cursor if it is hidden.
  ShowCursor
  /// Hides the cursor if it is visible.
  HideCursor
  /// Enables cursor blinking if it is not currently.
  EnableBlinking
  /// Disables cursor blinking if currently is enabled.
  DisableBlinking
  /// Sets the cursor style.
  StyleCursor(CursorStyle)
  /// Saves the cursor position, which can be restored using `RestoreCursorPosition`.
  SaveCursorPosition
  /// Restores the saved cursor position, if any.
  RestoreCursorPosition

  /// Moves the cursor to the given column and row.
  ///
  /// Both the column and row must be positive.
  MoveCursorTo(x: Int, y: Int)

  /// Moves the cursor to the given column.
  ///
  /// Negative columns do not exist, the given column must be positive.
  MoveCursorToColumn(Int)

  /// Moves the cursor to the given row.
  ///
  /// Negative rows do not exist, the given row must be positive.
  MoveCursorToRow(Int)

  /// Moves the cursor up by `lines`.
  ///
  /// `lines` should be positive, use `MoveCursorDown` to move down.
  MoveCursorUp(lines: Int)

  /// Moves the cursor down by `lines`.
  ///
  /// `lines` should be positive, use `MoveCursorUp` to move up.
  MoveCursorDown(lines: Int)

  /// Moves the cursor left by `columns`.
  ///
  /// `columns` should be positive, use `MoveCursorRight` to move right.
  MoveCursorLeft(columns: Int)

  /// Moves the cursor right by `columns`.
  ///
  /// `columns` should be positive, use `MoveCursorLeft` to move left.
  MoveCursorRight(columns: Int)

  /// Scrolls the terminal up. Given amount must be positive.
  ScrollTerminalUp(Int)
  /// Scrolls the terminal down. Given amount must be positive.
  ScrollTerminalDown(Int)
  /// Enters the alternate buffer.
  EnterAlternateScreen
  /// Leaves the alternate buffer.
  LeaveAlternateScreen
  /// Clears some contents from the screen.
  Clear(ClearType)
  /// Set this terminal screen's size.
  SetSize(columns: Int, rows: Int)
  /// Set the title of this terminal instance.
  SetTitle(String)
  /// Disable line wrapping.
  DisableLineWrap
  /// Enable line wrapping.
  EnableLineWrap

  /// Set the background and foreground color that text will be rendered with.
  SetColor(Color)
  /// Set an attribute that text will be rendered with.
  SetAttribute(Attribute)
  /// Apply a bundle which consists of an optional background and
  /// foreground color, and many attributes.
  ApplyBundle(fn() -> Bundle)
}

/// Returns the string representation of a given `Command`, the
/// representation includes escape sequences.
pub fn repr(command: Command) -> String {
  case command {
    Noop -> ""

    // Join multiple commands into one
    Batch(commands) -> repr_batch("", commands)

    Print(content) -> content

    // Cursor commands
    ShowCursor -> escape.csi <> "?25h"
    HideCursor -> escape.csi <> "?25l"
    EnableBlinking -> escape.csi <> "?12h"
    DisableBlinking -> escape.csi <> "?12l"
    StyleCursor(style) -> escape.csi <> cursor_style.repr(style)
    SaveCursorPosition -> escape.esc <> "7"
    RestoreCursorPosition -> escape.esc <> "8"
    MoveCursorTo(x, y) -> {
      escape.csi <> int.to_string(x + 1) <> ";" <> int.to_string(y + 1) <> "H"
    }
    MoveCursorToColumn(column) -> escape.csi <> int.to_string(column + 1) <> "G"
    MoveCursorToRow(row) -> escape.csi <> int.to_string(row + 1) <> "d"
    MoveCursorUp(lines) -> escape.csi <> int.to_string(lines) <> "A"
    MoveCursorDown(lines) -> escape.csi <> int.to_string(lines) <> "B"
    MoveCursorLeft(columns) -> escape.csi <> int.to_string(columns) <> "D"
    MoveCursorRight(columns) -> escape.csi <> int.to_string(columns) <> "C"

    // Terminal commands
    ScrollTerminalUp(lines) -> escape.csi <> int.to_string(lines) <> "S"
    ScrollTerminalDown(lines) -> escape.csi <> int.to_string(lines) <> "T"
    EnterAlternateScreen -> escape.csi <> "?1049h"
    LeaveAlternateScreen -> escape.csi <> "?1049l"

    // Misc. terminal commands
    Clear(clear_type) -> escape.csi <> clear.repr(clear_type)
    SetSize(columns, rows) -> {
      escape.csi
      <> ";"
      <> int.to_string(rows)
      <> ";"
      <> int.to_string(columns)
      <> ";t"
    }
    SetTitle(title) -> "\u{001b}]0;" <> title <> "\u{0007}"
    DisableLineWrap -> escape.csi <> "?7l"
    EnableLineWrap -> escape.csi <> "?8h"

    // Style commands
    SetColor(color) -> {
      let repr = color.ansi_value(color)
      escape.csi <> int.to_string(repr) <> "m"
    }
    SetAttribute(attribute) -> {
      let repr = attribute.ansi_value(attribute)
      escape.csi <> int.to_string(repr) <> "m"
    }
    ApplyBundle(style) -> repr(compute_style(style()))
  }
}

fn repr_batch(acc: String, commands: Batch) -> String {
  case commands {
    [command, ..remaining] -> {
      repr_batch(acc <> repr(command), remaining)
    }
    [] -> acc
  }
}

fn maybe_paint_color(
  type_: fn(color.Variant) -> Color,
  color: Option(color.Variant),
) -> Command {
  case color {
    option.Some(color) -> SetColor(type_(color))
    option.None -> Noop
  }
}

fn compute_style(style: Bundle) -> Command {
  Batch([
    maybe_paint_color(color.Foreground, style.foreground),
    maybe_paint_color(color.Background, style.background),
    ..list.map(style.attributes, SetAttribute)
  ])
}
