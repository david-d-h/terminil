/// Represents all supported cursor styles.
pub type Style {
  /// The default cursor style, configured by the user
  Default
  /// A blinking cursor block (■) style
  BlinkingBlock
  /// A cursor block (■) style
  Block
  /// A blinking cursor underscore (_) style
  BlinkingUnderscore
  /// A cursor underscore (_) style
  Underscore
  /// A blinking cursor bar (|) style
  BlinkingBar
  /// A cursor bar (|) style
  Bar
}

pub fn repr(style: Style) -> String {
  case style {
    Default -> "0 q"
    BlinkingBlock -> "1 q"
    Block -> "2 q"
    BlinkingUnderscore -> "3 q"
    Underscore -> "4 q"
    BlinkingBar -> "5 q"
    Bar -> "6 q"
  }
}
