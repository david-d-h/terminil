pub type ClearType {
  All
  Purge
  FromCursorDown
  FromCursorUp
  CurrentLine
  UntilNewLine
}

pub fn repr(type_: ClearType) -> String {
  case type_ {
    All -> "2J"
    Purge -> "3J"
    FromCursorDown -> "J"
    FromCursorUp -> "1J"
    CurrentLine -> "2K"
    UntilNewLine -> "K"
  }
}
