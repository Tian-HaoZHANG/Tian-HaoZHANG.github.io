#let template-refs(content) = {
  show ref: set text(fill: rgb(0, 0, 255))

  show ref: it => {
    // Aliases
    let eq = math.equation
    let el = it.element

    // Equation reference
    if el != none and el.func() == eq {
      // Override equation references.
      return link(el.location(), numbering(
        el.numbering,
        ..counter(eq).at(el.location()),
      ))
    }

    if el != none and el.func() == heading {
      return link(el.location(), smartquote() + it.element.body + smartquote())
    }

    it
  }

  content
}
