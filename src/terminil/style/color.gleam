pub type Color {
  Reset
  Foreground(Variant)
  Background(Variant)
}

pub type Variant {
  Default
  Black
  Red
  Green
  Yellow
  Blue
  Magenta
  Cyan
  White
  BrightBlack
  BrightRed
  BrightGreen
  BrightYellow
  BrightBlue
  BrightMagenta
  BrightCyan
  BrightWhite
}

pub fn ansi_value(color: Color) -> Int {
  case color {
    Reset -> 0
    Foreground(color) -> foreground_ansi_value(color)
    Background(color) -> background_ansi_value(color)
  }
}

pub fn foreground_ansi_value(color: Variant) -> Int {
  case color {
    Default -> 39
    Black -> 30
    Red -> 31
    Green -> 32
    Yellow -> 33
    Blue -> 34
    Magenta -> 35
    Cyan -> 36
    White -> 37
    BrightBlack -> 90
    BrightRed -> 91
    BrightGreen -> 92
    BrightYellow -> 93
    BrightBlue -> 94
    BrightMagenta -> 95
    BrightCyan -> 96
    BrightWhite -> 97
  }
}

pub fn background_ansi_value(color: Variant) -> Int {
  foreground_ansi_value(color) + 10
}
