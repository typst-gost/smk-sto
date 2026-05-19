// Внутренние хелперы для форм-приложений к отчёту о практике
// (титульный лист, задание, дневник, анкета, отзыв).
//
// Эти функции не реэкспортируются в публичный API пакета — они
// используются только внутри `src/practice/*.typ`.
//
// Логика подчёркивания и подписей:
//   - Если поле в шаблоне заполняется «впечатыванием» (типизованное
//     значение), а пользователь передал значение — рендерим как обычный
//     текст без линии. Подпись-пояснение под полем тоже скрывается —
//     она дублирует впечатанный текст и не нужна.
//   - Если значение не передано (`none`) — рисуется линия-плейсхолдер
//     для возможного рукописного заполнения распечатанной формы, плюс
//     подпись-пояснение остаётся как памятка.
//   - Если поле принципиально рукописное (подпись, дата защиты, оценка)
//     — линия и подпись сохраняются всегда (`force-underline: true` на
//     `underlined-box`, прямой вызов `small-label` без условия).

#import "../utils.typ": nbsp-name

// Подпись 9 pt по центру. Используется напрямую только для полей,
// у которых пояснение нужно всегда (подпись, дата, оценка).
// Для inline-полей с автоскрытием при заполнении — `label-for`.
#let small-label(body) = align(center, text(size: 9pt, body))

// Пояснение под полем формы (`underlined-box` в grid). Печатается только
// если `value == none` — поле остаётся пустым для рукописного заполнения
// и подпись поясняет, что туда вписывать. Если значение задано, поле
// «впечатано» и подпись не нужна (текст значения сам себя поясняет).
//
// Параметр `force-show: true` сохраняет подпись всегда — для полей,
// которые в стандарте всегда оформлены как рукописные (например, «дата»
// и «оценка» в блоке «Отчёт защищён»).
#let label-for(value, body, force-show: false) = {
  if force-show or value == none {
    align(center, text(size: 9pt, body))
  }
}

// Выбор словоформы по гендеру с дефолтом.
//
//   gender-text("male", male: "ознакомлен", female: "ознакомлена",
//                       default: "ознакомлен(а)")
//
// Возвращает male/female-форму или дефолт, если гендер не задан
// (`none`/любое другое значение).
#let gender-text(gender, male: "", female: "", default: "") = {
  if gender == "male" {
    male
  } else if gender == "female" {
    female
  } else {
    default
  }
}

// Словоформы «обучающийся» по падежам и гендеру.
//
//   student-word(case: "nominative", gender: "male")   → "Обучающийся"
//   student-word(case: "dative",     gender: "female") → "Обучающейся"
//   student-word(case: "genitive",   gender: none)     → "Обучающегося(ейся)"
//
// Падежи: `nominative` (титульник, отзыв), `dative` (задание),
// `genitive` (дневник).
#let student-word(case: "nominative", gender: none) = {
  let forms = (
    nominative: (
      male: "Обучающийся",
      female: "Обучающаяся",
      default: "Обучающийся(аяся)",
    ),
    genitive: (
      male: "Обучающегося",
      female: "Обучающейся",
      default: "Обучающегося(ейся)",
    ),
    dative: (
      male: "Обучающемуся",
      female: "Обучающейся",
      default: "Обучающемуся(ейся)",
    ),
  )
  let f = forms.at(case, default: forms.nominative)
  gender-text(gender, male: f.male, female: f.female, default: f.default)
}

// Бокс под значение формы.
//
// • Если значение указано и `force-underline: false` — выводим как обычный
//   текст без линии и без фиксированной ширины (поле «впечатано» в бланк).
// • Если значение не указано или `force-underline: true` — рисуется линия
//   снизу как плейсхолдер для рукописного заполнения.
#let underlined-box(value, width: 100%, force-underline: false) = {
  if value == none or force-underline {
    box(
      width: width,
      stroke: (bottom: 0.5pt),
      inset: (bottom: 3pt),
      outset: 0pt,
      if value == none {
        sym.zws
      } else {
        layout(size => {
          let m = measure(value)
          if m.width <= size.width {
            align(center, value)
          } else {
            value
          }
        })
      },
    )
  } else {
    box(
      outset: 0pt,
      layout(size => {
        let m = measure(value)
        if m.width <= size.width {
          align(center, value)
        } else {
          value
        }
      }),
    )
  }
}

// Гибкая «линия-заполнитель»: пустой инлайн-бокс шириной `1fr`, который
// раскрывается до правого края своей визуальной строки.
//
// `baseline: 2pt` сдвигает baseline бокса на 2 pt вниз от baseline текста;
// нижняя граница пустого (height: 0pt) бокса оказывается на Y = baseline + 2pt,
// что точно совпадает с положением `underline(offset: 2pt)`. Подчёркивание
// текста значения и заполнитель образуют одну непрерывную линию.
#let _fill-line = box(
  width: 1fr,
  height: 0pt,
  baseline: 2pt,
  stroke: (bottom: 0.5pt),
)

// Поле формы: «Название значение».
//
// • Если значение указано — выводится обычным текстом (поле «впечатано»);
//   подпись-пояснение под полем не печатается.
// • Если значение `none` — после имени тянется линия-плейсхолдер до правого
//   края, под которой по центру — пояснение 9 pt (памятка для рукописного
//   заполнения).
#let field-line(name, value, label: none) = block(
  width: 100%,
  breakable: false,
  spacing: 0.55em,
)[
  #if value != none {
    block(width: 100%)[#name #h(0.5em) #value]
  } else [
    #block(width: 100%)[#name #h(0.5em) #_fill-line]
    #if label != none {
      v(2pt, weak: false)
      small-label(label)
    }
  ]
]

// Подпись (signature row): «Должность ____подпись____ И.О. Фамилия».
// Линия под подписью сохраняется всегда — подпись и дата ставятся от руки.
#let sign-line(position, name) = {
  let pos-cell = if position == none { [] } else { position }
  let name-cell = if name == none { [] } else { nbsp-name(name) }
  block(width: 100%, breakable: false, spacing: 0.55em)[
    #grid(
      columns: (auto, 1fr, auto),
      column-gutter: 0.8em,
      row-gutter: 3pt,
      align: (left + bottom, center + bottom, left + bottom),
      pos-cell, underlined-box(none), name-cell,
      [], small-label[подпись, дата], [],
    )
  ]
}


// Многострочное поле для развёрнутого текстового ответа.
// `lines: N` рисует N горизонтальных линий-«линеек» под значением,
// чтобы у формы было место заполнить от руки.
#let multiline-field(name, value, lines: 2) = block(
  width: 100%,
  breakable: false,
  spacing: 0.4em,
)[
  #context layout(size => {
    let line-h = measure([Xg]).height + 0.55em
    let name-width = measure([#name #h(0.5em)]).width
    block(width: 100%, inset: (top: 0pt, bottom: 0pt))[
      // Первая линия — после имени поля.
      #place(
        top + left,
        dx: name-width,
        dy: line-h - 1pt,
        line(length: size.width - name-width, stroke: 0.5pt),
      )
      // Дополнительные пустые линии на всю ширину для рукописного заполнения.
      #for i in range(2, lines + 1) {
        place(
          top + left,
          dy: i * line-h - 1pt,
          line(length: size.width, stroke: 0.5pt),
        )
      }
      // Само значение — текст значения «затекает» на первую линию.
      // Если значение длинное, оно автоматически переносится на следующие
      // линии, а недостающие отрисовываются пустыми.
      #name #h(0.5em) #if value != none { value } else { sym.zws }
      // Резервируем высоту под `lines` визуальных строк.
      #v((lines - 1) * line-h, weak: false)
    ]
  })
]

// Чекбокс «☐» (пустой) / «☑» (отмеченный).
#let checkbox(checked: false) = {
  if checked { sym.ballot.check } else { sym.ballot }
}
