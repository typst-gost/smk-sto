// Общие утилиты: алфавитная нумерация, подпись, «где»-блок, оформление
// продолжений таблиц. Шаблон-специфичные обозначения (ЛР, ОП) живут в
// соответствующих подпакетах (lab/, practice/).

// Буквы для буквенных перечислений (п. 8.4.2 СТО 006–2025) и обозначений
// приложений (п. 7.11.4 СТО 006–2025). Исключаются: ё, з, й, о, ч, ъ, ы, ь.
#let cyrillic-letters = (
  "а",
  "б",
  "в",
  "г",
  "д",
  "е",
  "ж",
  "и",
  "к",
  "л",
  "м",
  "н",
  "п",
  "р",
  "с",
  "т",
  "у",
  "ф",
  "х",
  "ц",
  "ш",
  "щ",
  "э",
  "ю",
  "я",
)

// Перечисление вида «а)», «б)», ... согласно СТО 006–2025 п. 8.4.2.
#let enum-letter(n) = {
  let i = n - 1
  let base = cyrillic-letters.len()
  let s = ""
  if i < 0 { return "" }
  let q = i
  while true {
    s = cyrillic-letters.at(calc.rem(q, base)) + s
    q = calc.floor(q / base)
    if q == 0 { break }
    q -= 1
  }
  s + ")"
}

// Не разбивать ФИО переносом строки.
#let nbsp-name(name) = {
  if name == none { return [] }
  return name.replace(" ", "\u{00A0}")
}

// Поле подписи по Приложению А:
//
//   должность                  ___________________     И.О. Фамилия
//                                  подпись, дата
//
#let sign-field(position, name, line-width: 5cm, hint: "подпись, дата") = {
  set par(justify: false, first-line-indent: 0pt)
  let pos-cell = if position == none { [] } else { position }
  let name-cell = if name == none { [] } else { nbsp-name(name) }
  // Сама подпись: линия сверху и подпись «подпись, дата» под ней.
  let sign-box = box(width: line-width, baseline: 1.0em)[
    #set align(center)
    #v(0.4em, weak: true)
    #line(length: 100%, stroke: 0.5pt)
    #text(size: 0.85em, hint)
  ]
  block(width: 100%, breakable: false, spacing: 0.7em)[
    #pos-cell
    #h(1fr)
    #sign-box
    #h(1fr)
    #name-cell
  ]
}

// «где»-блок после формулы по СТО 8.4.2: первая строка с абзаца со слова
// «где» без двоеточия после него; каждая переменная — на новой строке;
// все переменные выровнены под первой.
//
//   #where-block(
//     ($U$, [напряжение, В]),
//     ($I$, [сила тока, А]),
//   )
//
// рендерится как:
//
//       где U — напряжение, В;
//           I — сила тока, А.
//
// Параметр `lead` — слово-вводное (по умолчанию «где»); `separator` —
// символ между переменной и её описанием (по умолчанию «–» с пробелами).
#let where-block(..items, lead: [где], separator: [ – ]) = {
  let items = items.pos()
  if items.len() == 0 { return [] }
  set par(first-line-indent: 0pt, justify: false)
  // Ширина «где » для висячего отступа.
  context {
    let lead-width = measure([#lead#h(0.5em)]).width
    let last = items.len() - 1
    let rows = items
      .enumerate()
      .map(((i, pair)) => {
        let (sym, desc) = pair
        let punctuation = if i == last { [.] } else { [;] }
        let head = if i == 0 {
          [#lead#h(0.5em)#sym]
        } else {
          [#h(lead-width)#sym]
        }
        ([#head#separator#desc#punctuation],)
      })
      .flatten()
    pad(left: 1.25cm, stack(spacing: 0.35em, ..rows))
  }
}

// Разрядка букв «Т а б л и ц а» по СТО 8.6.5 — интервал 1,6 пт.
#let table-label(num: none, caption: none) = {
  set par(first-line-indent: 0pt, justify: false)
  let head = text(tracking: 1.6pt)[Таблица]
  if num != none and caption != none {
    [#head #num – #caption]
  } else if num != none {
    [#head #num]
  } else {
    head
  }
}

// «Продолжение таблицы N» / «Окончание таблицы N» — без разрядки (СТО 8.6.6).
#let table-continuation(num, kind: "Продолжение") = {
  set par(first-line-indent: 0pt, justify: false)
  [#kind таблицы #num]
}
