// Общий стиль документа по СМК СТО — единый для отчётов о лабораторных
// работах (СМК СТО 004–2020) и о практике (СМК СТО 014–2025).

#import "constants.typ": (
  default-font, default-text-size, default-small-size,
  default-indent, default-margin, default-leading, default-spacing,
)
#import "utils.typ": table-label

// Структурный заголовок (Введение, Заключение, …) определяется отсутствием
// нумерации. Пользователь помечает заголовок меткой `<s>` — её ниже
// перехватывает `show <s>: set heading(numbering: none)`. Также сюда попадают
// автогенерируемые заголовки `#outline` и `#bibliography(title: ...)`.
#let is-structural-heading(it) = {
  it.level == 1 and it.numbering == none
}

#let smk-style(
  text-size: default-text-size,
  small-size: default-small-size,
  indent: default-indent,
  margin: default-margin,
  font: default-font,
  hide-title-page-number: true,
  add-pagebreaks: true,
  body,
) = {
  set page(
    paper: "a4",
    margin: margin,
    footer: context {
      let p = counter(page).get().first()
      if p == 1 and hide-title-page-number {
        []
      } else {
        align(center)[#counter(page).display("1")]
      }
    },
  )

  // Переносы в основном тексте разрешены (СТО 014–2025 п. 5.7,
  // СТО 006–2025 п. 8.1.2) — отключаем только в заголовках ниже.
  set text(
    font: font,
    size: text-size,
    lang: "ru",
    hyphenate: true,
  )

  set par(
    justify: true,
    first-line-indent: (amount: indent, all: true),
    leading: default-leading,
    spacing: default-leading,
  )

  // Списки по СТО 8.1.5: маркер «–», нумерация «1)», абзацный отступ.
  set list(
    marker: [–],
    indent: indent,
    body-indent: 0.5em,
    spacing: default-leading,
  )
  // Маркированные списки («-») — как и нумерованные (см. ниже): отступ красной
  // строки, а не выступ. Первая строка пункта (с маркером) отступается на
  // абзацный отступ, перенесённые строки начинаются от левого края.
  show list: it => {
    let m = it.marker
    let marker = if type(m) == function { m(0) } else if type(m) == array { m.at(0, default: [–]) } else { m }
    for item in it.children {
      block(
        spacing: it.spacing,
        par(
          first-line-indent: (amount: it.indent, all: true),
          [#marker#h(it.body-indent)#item.body],
        ),
      )
    }
  }
  set enum(
    indent: indent,
    body-indent: 0.5em,
    spacing: default-leading,
    numbering: "1)",
    full: true,
  )
  // Нумерованные списки («+») оформляются с отступом красной строки, а не с
  // выступом: первая строка пункта (вместе с номером) отступается на абзацный
  // отступ, а перенесённые строки начинаются от левого края — как в обычном
  // абзаце. Стандартный enum Typst выравнивает перенос под текстом (выступ),
  // поэтому перестраиваем каждый пункт как абзац с first-line-indent.
  show enum: it => {
    let n = if it.start == auto { 1 } else { it.start }
    for item in it.children {
      let explicit = item.at("number", default: auto)
      let num = if explicit == auto { n } else { explicit }
      n = num + 1
      block(
        spacing: it.spacing,
        par(
          first-line-indent: (amount: it.indent, all: true),
          [#numbering(it.numbering, num)#h(it.body-indent)#item.body],
        ),
      )
    }
  }

  // Заголовки.
  set heading(numbering: "1.1 ", hanging-indent: 0pt)
  // Метка `<s>` помечает заголовок как структурный (Введение, Заключение,
  // и т. п.): такой `= Заголовок <s>` рендерится без номера, по центру,
  // заглавными буквами, и не увеличивает счётчик глав.
  show <s>: set heading(numbering: none)
  // В заголовках переносы не допускаются (СТО 004 8.1.5, СТО 006 8.3.3).
  show heading: set text(size: text-size, weight: "bold", hyphenate: false)
  show heading: it => {
    set par(first-line-indent: 0pt, justify: false)
    let body = it.body
    if it.numbering != none {
      let n = counter(heading).display(it.numbering)
      block(below: default-spacing, above: default-spacing)[
        #h(indent)#n#body
      ]
    } else {
      block(below: default-spacing, above: default-spacing)[#body]
    }
  }

  // Структурные заголовки (Содержание, Введение, ...) — по центру, заглавные,
  // без номера; новый лист.
  show heading.where(level: 1): it => {
    set par(first-line-indent: 0pt, justify: false)
    if is-structural-heading(it) {
      if add-pagebreaks { pagebreak(weak: true) }
      align(center, block(above: default-spacing, below: default-spacing)[
        #upper(it.body)
      ])
    } else {
      if add-pagebreaks { pagebreak(weak: true) }
      let n = counter(heading).display(it.numbering)
      block(above: default-spacing, below: default-spacing)[#h(indent)#n#it.body]
    }
  }

  // Содержание: номер раздела + название с заполнителем-точками + страница.
  // Приложения выводятся как «ПРИЛОЖЕНИЕ А Название».
  // По СТО 006–2025 п. 7.4.3 подразделы сдвигаются на 0,5 см относительно
  // обозначения разделов, пункты — на 1 см.
  show outline: set par(first-line-indent: 0pt)
  set outline(indent: 0.5cm, depth: 3)
  show outline.entry: it => context {
    let el = it.element
    let is-heading-l1 = el != none and el.func() == heading and el.level == 1
    let is-app = is-heading-l1 and el.supplement == [ПРИЛОЖЕНИЕ]
    let is-structural = is-heading-l1 and el.numbering == none
    let fill = box(width: 1fr, repeat[.#h(2pt)])
    if is-app {
      let letter = numbering(el.numbering, ..counter(heading).at(el.location()))
      link(el.location(), it.indented(
        [ПРИЛОЖЕНИЕ #letter],
        el.body + h(0.5em) + fill + sym.space + it.page(),
      ))
    } else if is-structural {
      link(el.location(), it.indented(
        none,
        upper(el.body) + h(0.5em) + fill + sym.space + it.page(),
      ))
    } else {
      it
    }
  }

  // Формулы. Ссылки вида «… в формуле (1)…» по СТО 8.4.4.
  set math.equation(numbering: "(1)", supplement: none)
  show ref: it => {
    let el = it.element
    if el != none and el.func() == math.equation {
      let n = numbering(el.numbering, ..counter(math.equation).at(el.location()))
      link(el.location(), n)
    } else {
      it
    }
  }
  show math.equation.where(block: true): it => {
    block(width: 100%, breakable: false)[
      #set align(center)
      #it
    ]
  }

  // Рисунки. По СТО разделитель — тире «–» с пробелами.
  set figure.caption(separator: [ – ])
  show figure.caption: set par(first-line-indent: 0pt, justify: false)
  show figure.where(kind: image): set figure(supplement: [Рисунок])
  show figure.where(kind: image): set figure.caption(position: bottom)
  show figure.where(kind: image): set align(center)
  // Между рисунком и подписью, а также между подписью и следующим текстом
  // — всегда одна пустая строка (отступ задаётся на самой подписи).
  show figure.where(kind: image): set figure(gap: default-spacing)
  show figure.caption.where(kind: image): it => [#it #v(default-spacing)]

  // Таблицы: подпись «Таблица N — ...» слева, сверху, с разрядкой буквы.
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set align(left)
  show figure.where(kind: table): set block(breakable: true)
  show figure.caption.where(kind: table): it => context {
    set par(first-line-indent: 0pt, justify: false)
    let num = numbering(
      it.numbering,
      ..counter(figure.where(kind: table)).at(it.location()),
    )
    table-label(num: num, caption: it.body)
  }

  // Кавычки по СТО 006–2025 п. 8.1.8: внешние — «ёлочки», внутренние —
  // „лапки" (немецкого начертания: нижняя „ + верхняя “).
  set smartquote(quotes: (single: "„“", double: "«»"))

  // Сноски — Times New Roman 12 пт (СТО 006–2025 п. 8.10.7).
  show footnote.entry: set text(size: small-size)

  // Ссылки внутри документа.
  set ref(supplement: none)

  // Титульный лист всегда считается страницей 1 — даже если он не
  // вшит в документ. Поэтому первая страница контента начинается с 2.
  // Функция *-title-page откатывает счётчик обратно на 1, обеспечивая
  // отображение «1» (скрытого) именно на титуле.
  counter(page).update(2)
  body
}
