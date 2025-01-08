pub type Attribute {
  Reset
  Bold
  Dim
  Italic
  Underlined
  SlowBlink
  RapidBlink
  Invert
  Hidden
  Strike
  Fraktur
  NoBold
  NoItalic
  NoUnderline
  NoBlink
  NotInverted
  NotHidden
  NoStrike
  Framed
  Encircled
  Overlined
  NotFramedOrEncircled
  NotOverlined
}

pub fn ansi_value(attribute: Attribute) -> Int {
  case attribute {
    Reset -> 0
    Bold -> 1
    Dim -> 2
    Italic -> 3
    Underlined -> 4
    SlowBlink -> 5
    RapidBlink -> 6
    Invert -> 7
    Hidden -> 8
    Strike -> 9
    Fraktur -> 20
    NoBold -> 21
    NoItalic -> 23
    NoUnderline -> 24
    NoBlink -> 25
    NotInverted -> 27
    NotHidden -> 28
    NoStrike -> 29
    Framed -> 51
    Encircled -> 52
    Overlined -> 53
    NotFramedOrEncircled -> 54
    NotOverlined -> 55
  }
}
