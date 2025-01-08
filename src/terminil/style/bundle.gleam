import terminil/style/attribute.{type Attribute}
import terminil/style/color

import gleam/option.{type Option}

pub type Bundle {
  Bundle(
    foreground: Option(color.Variant),
    background: Option(color.Variant),
    attributes: List(Attribute),
  )
}
