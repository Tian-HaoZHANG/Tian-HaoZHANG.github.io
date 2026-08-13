#let template-math(content) = {
  show math.equation.where(block: false): it => h(0.25em, weak: true) + it + h(0.25em, weak: true) // 如果公式前后没有空格，则加空格（Typst 会自动在中英文之间空格，不需要用手动加）
  set math.equation(numbering: "Eq. (1)")
  set math.equation(supplement: [Eq.]) // 设定公式被引用时的文本
  // 行内公式的分式设为横向
  show math.equation.where(block: false): set math.frac(style: "horizontal")

  set math.mat(delim: "[") // 矩阵用方括号，而不是默认的圆括号

  let html-math-content(it) = if sys.version >= version(0, 15, 0) {
    it
  } else {
    html.frame(it)
  }

  show math.equation.where(block: false): it => {
    if target() == "html" {
      html.span(class: "math-inline", role: "math", html-math-content(it))
    } else {
      it
    }
  }

  show math.equation.where(block: true): it => {
    if target() == "html" {
      // 手动获取编号并显示
      context [
        #html.span(class: "equation-number")[
          #counter(math.equation).display(it.numbering)
        ]
        #html.figure(class: "math-block", role: "math", html-math-content(it))
      ]
    } else {
      it
    }
  }

  content
}
