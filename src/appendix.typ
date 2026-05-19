// Приложения по СТО 006–2025 п. 7.11:
//   • слово «ПРИЛОЖЕНИЕ» прописными, по центру (п. 7.11.3-7.11.4);
//   • статус («обязательное», «рекомендуемое», «справочное») в скобках —
//     при необходимости (п. 7.11.4);
//   • буквенное обозначение — кириллица без Ё, З, Й, О, Ч, Ъ, Ы, Ь;
//   • своя нумерация рисунков, таблиц и формул в каждом приложении
//     с буквой приложения перед номером (п. 7.11.6, СТО 006 п. 8.8.3).

#import "utils.typ": cyrillic-letters

// Буквы для приложений — те же, что и для буквенных перечислений.
#let appendix-letters = cyrillic-letters.map(upper)

#let appendix-letter(n) = {
  appendix-letters.at(n - 1)
}

#let appendix-heading-numbering(..nums) = {
  let n = nums.pos()
  appendix-letter(n.first())
}

#let appendix-figure-numbering = it => {
  let h = counter(heading).get().first()
  if h <= 0 { return }
  [#appendix-letter(h).#it]
}

#let appendix-equation-numbering = it => {
  let h = counter(heading).get().first()
  if h <= 0 { return }
  [(#appendix-letter(h).#it)]
}

// Применяется как `#show: appendix` — далее все `= Заголовок` становятся
// приложениями с автоматической буквой.
//
// `status` — статус, выводимый под словом «ПРИЛОЖЕНИЕ» в скобках:
// «обязательное» (по умолчанию), «рекомендуемое», «справочное» либо
// `none`, чтобы не печатать вовсе (СТО 006–2025 п. 7.11.4).
#let appendix(status: "обязательное", body) = {
  // Сбросить счётчик заголовков уровня 1 (приложения нумеруются отдельно).
  counter(heading).update(0)
  // Перенумеровать фигуры, таблицы, формулы относительно приложения.
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(math.equation).update(0)

  set heading(numbering: appendix-heading-numbering, supplement: [ПРИЛОЖЕНИЕ])
  show heading.where(level: 1): it => context {
    pagebreak(weak: true)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    set par(first-line-indent: 0pt, justify: false)
    align(center)[
      #block(above: 1.5em, below: 0.5em)[
        ПРИЛОЖЕНИЕ #counter(heading).display(it.numbering)
      ]
      #if status != none {
        block(below: 1.5em)[(#status)]
      }
      #block(below: 1.5em)[#it.body]
    ]
  }

  set figure(numbering: appendix-figure-numbering)
  set math.equation(numbering: appendix-equation-numbering)

  body
}
