/// A Unicode ESC sequence.
pub const esc = "\u{001b}"

/// A Unicode ESC sequence followed a CSI ([) character.
pub const csi = esc <> "["
