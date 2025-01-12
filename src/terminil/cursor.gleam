import gleam/int
import gleam/order
import terminil/command.{type Command}
import terminil/cursor/style
import terminil/util.{assert_}

pub type Style =
  style.Style

/// The default cursor style, configured by the user
pub const default = style.Default

/// A blinking cursor block (■) style
pub const blinking_block = style.BlinkingBlock

/// A cursor block (■) style
pub const block = style.Block

/// A blinking cursor underscore (_) style
pub const blinking_underscore = style.BlinkingUnderscore

/// A cursor underscore (_) style
pub const underscore = style.Underscore

/// A blinking cursor bar (|) style
pub const blinking_bar = style.BlinkingBar

/// A cursor bar (|) style
pub const bar = style.Bar

/// Shows the cursor if it is hidden.
pub const show = command.ShowCursor

/// Hides the cursor if it is visible.
pub const hide = command.HideCursor

/// A command that saves the cursor's current position.
/// Restore the position using `restore_position`.
pub const save_position = command.SaveCursorPosition

/// Restores a cursor position saved with `save_position`.
pub const restore_position = command.RestoreCursorPosition

pub fn style(style: Style) -> Command {
  command.StyleCursor(style)
}

pub fn to(x: Int, y: Int) -> Command {
  assert_(x >= 0 && y >= 0)
  command.MoveCursorTo(x, y)
}

pub fn to_row(row n: Int) -> Command {
  assert_(n >= 0)
  command.MoveCursorToRow(n)
}

pub fn to_column(column n: Int) -> Command {
  assert_(n >= 0)
  command.MoveCursorToColumn(n)
}

pub fn to_beginning_of(line: Int) -> Command {
  command.Batch([command.MoveCursorToRow(line), command.MoveCursorToColumn(0)])
}

pub fn to_beginning_of_relative(lines: Int) -> Command {
  case int.compare(lines, 0) {
    order.Gt ->
      command.Batch([command.MoveCursorUp(lines), command.MoveCursorToColumn(0)])
    order.Eq -> command.MoveCursorToColumn(0)
    order.Lt ->
      command.Batch([
        command.MoveCursorDown(-lines),
        command.MoveCursorToColumn(0),
      ])
  }
}

pub fn up(lines: Int) -> Command {
  assert_(lines >= 0)
  command.MoveCursorUp(lines)
}

pub fn down(lines: Int) -> Command {
  assert_(lines >= 0)
  command.MoveCursorDown(lines)
}

pub fn left(columns: Int) -> Command {
  assert_(columns >= 0)
  command.MoveCursorLeft(columns)
}

pub fn right(columns: Int) -> Command {
  assert_(columns >= 0)
  command.MoveCursorRight(columns)
}
