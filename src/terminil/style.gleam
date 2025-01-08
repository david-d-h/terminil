import terminil/command.{type Command}
import terminil/style/attribute.{type Attribute}
import terminil/style/bundle.{Bundle}
import terminil/style/color.{type Color}

import gleam/option

pub type Attributes =
  List(Attribute)

pub type Bundle =
  bundle.Bundle

pub fn new() -> Bundle {
  Bundle(option.None, option.None, [])
}

pub fn colors(
  style: Bundle,
  foreground: color.Variant,
  background: color.Variant,
) -> Bundle {
  Bundle(option.Some(foreground), option.Some(background), style.attributes)
}

pub fn color(style: Bundle, color: Color) -> Bundle {
  case color {
    color.Reset -> Bundle(option.None, option.None, style.attributes)
    color.Foreground(color) ->
      Bundle(option.Some(color), style.background, style.attributes)
    color.Background(color) ->
      Bundle(style.foreground, option.Some(color), style.attributes)
  }
}

pub fn foreground(style: Bundle, color: color.Variant) -> Bundle {
  Bundle(option.Some(color), style.background, style.attributes)
}

pub fn background(style: Bundle, color: color.Variant) -> Bundle {
  Bundle(style.foreground, option.Some(color), style.attributes)
}

pub fn attribute(style: Bundle, attribute: Attribute) -> Bundle {
  Bundle(style.foreground, style.background, attributes: [
    attribute,
    ..style.attributes
  ])
}

pub fn apply(style: fn() -> Bundle) -> Command {
  command.ApplyBundle(style)
}
