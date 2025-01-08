import terminil/clear.{type ClearType}
import terminil/command
import terminil/util.{assert_}

import gleam/io

pub type Command =
  command.Command

pub const enter_alternate_screen = command.EnterAlternateScreen

pub const leave_alternate_screen = command.LeaveAlternateScreen

pub const enable_linewrap = command.EnableLineWrap

pub const disable_linewrap = command.DisableLineWrap

pub type Result {
  Ok
  Error
}

@external(erlang, "terminil_ffi", "enable_raw_mode")
pub fn enable_raw_mode() -> Result

@external(erlang, "terminil_ffi", "read")
pub fn read_char() -> BitArray

/// Executes the given commands in a batch.
/// Equivalent to `batch([..]) |> execute`.
pub fn do(commands: command.Batch) -> Nil {
  execute(batch(commands))
}

/// Executes the given command using `io.print`.
pub fn execute(command cmd: Command) -> Nil {
  case cmd {
    command.Noop -> Nil
    _ -> command.repr(cmd) |> io.print
  }
}

/// Constructs a batch.
///
/// Batches allow for executing multiple commands at once,
/// this can be helpful for applications that clear the screen
/// and print content to it immediately after. As it can be used
/// to avoid flickering of content.
pub fn batch(commands cmds: command.Batch) -> Command {
  command.Batch(cmds)
}

/// Clears the terminal with the given mode.
pub fn clear(clear_type: ClearType) -> Command {
  command.Clear(clear_type)
}

/// Resizes the terminal screen to the given amount columns and rows.
pub fn resize(columns: Int, rows: Int) -> Command {
  assert_(columns >= 0 && rows >= 0)
  command.SetSize(columns, rows)
}

/// Constructs a `Print` command.
pub fn print(content: String) -> Command {
  command.Print(content)
}

/// Sets the title of this terminal instance.
pub fn title(content: String) -> Command {
  command.SetTitle(content)
}

/// Scrolls the terminal up by `lines` amount.
pub fn up(lines: Int) -> Command {
  assert_(lines >= 0)
  command.ScrollTerminalUp(lines)
}

/// Scrolls the terminal down by `lines` amount.
pub fn down(lines: Int) -> Command {
  assert_(lines >= 0)
  command.ScrollTerminalDown(lines)
}
