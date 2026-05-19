// Дневник практики — Приложение Г к СМК СТО 014–2025.

#import "../constants.typ": default-margin
#import "form-helpers.typ": field-line, label-for, sign-line, student-word, underlined-box

#let practice-report-diary(
  kind: none,
  practice-type: none,
  // Гендер обучающегося — влияет на словоформу обращения.
  gender: none,
  // Обращение к обучающемуся; по умолчанию — словоформа по гендеру.
  student-prefix: auto,
  author: none,
  direction: none,
  profile: none,
  // Записи о работах: список троек (date, content, supervisor-note).
  // `supervisor-note` обычно остаётся пустым на печати — заполняется
  // рукописно руководителем практики (СТО 014–2025 п. 6.5).
  entries: (),
  supervisor-org: none,
  supervisor-uni: none,
  margin: default-margin,
) = {
  pagebreak(weak: true)
  set page(margin: margin, footer: [])

  set par(
    justify: false,
    first-line-indent: 0pt,
    leading: 0.55em,
    spacing: 0.5em,
  )
  // Бланк формы — переносов в полях нет.
  set text(size: 14pt, hyphenate: false)

  let author-rec = if type(author) == str {
    (name: author, course: none, group: none)
  } else if type(author) == dictionary {
    author
  } else if author == none {
    (name: none, course: none, group: none)
  } else {
    panic("Некорректный тип поля author")
  }

  let dir-str = if type(direction) == str {
    direction
  } else if type(direction) == dictionary {
    let code = direction.at("code", default: none)
    let name = direction.at("name", default: none)
    if code != none and name != none { [#code #name] } else if code != none { [#code] } else if name != none {
      [#name]
    } else { none }
  } else { none }

  // Словоформа обращения к обучающемуся — по гендеру, если явно не задано.
  let prefix = if student-prefix == auto {
    student-word(case: "genitive", gender: gender)
  } else {
    student-prefix
  }

  // --- Шапка формы ----------------------------------------------------

  align(center)[
    #block(spacing: 0.65em)[#upper[Дневник]]
  ]

  // «по [учебной] практике» — единый паттерн с титульным листом и
  // заданием; `kind` передаётся в нужном падеже (учебной / производственной).
  if kind != none {
    align(center, block(width: 60%, breakable: false, spacing: 0.4em)[
      по #kind практике
    ])
  } else {
    align(center, block(width: 60%, breakable: false, spacing: 0.4em)[
      #grid(
        columns: (auto, 1fr, auto),
        column-gutter: 0.5em,
        row-gutter: 3pt,
        align: (right + bottom, center + bottom, left + bottom),
        [по], underlined-box(none), [практике],
        [], label-for(kind, [вид практики]), [],
      )
    ])
  }

  align(center, block(width: 50%, spacing: 0.4em)[
    #grid(
      columns: 1fr,
      row-gutter: 3pt,
      underlined-box(if practice-type != none { [#practice-type] } else { none }),
      label-for(practice-type, [Тип практики в соответствии с ОПОП ВО]),
    )
  ])

  v(0.5em)

  // --- Сведения об обучающемся ----------------------------------------

  field-line(
    [#prefix],
    author-rec.at("name", default: none),
    label: [Фамилия Имя Отчество],
  )

  block(width: 100%, spacing: 0.4em)[
    #grid(
      columns: (auto, auto, auto, auto, auto, 1fr),
      column-gutter: 0.5em,
      align: (left + bottom, center + bottom, left + bottom, center + bottom, left + bottom, left),
      underlined-box(
        if author-rec.at("course", default: none) != none {
          let c = author-rec.course
          [#if type(c) == int { str(c) } else { c }]
        } else { none },
        width: 2cm,
      ),
      [курса],
      underlined-box(
        if author-rec.at("group", default: none) != none {
          [#author-rec.group]
        } else { none },
        width: 3cm,
      ),
      [группы],
      [],
      [],
    )
  ]

  field-line(
    [Направление подготовки / Специальность],
    dir-str,
    label: [код, наименование направления подготовки/специальности],
  )

  field-line([Направленность (профиль)], profile)

  v(0.6em)

  // --- Таблица записей ------------------------------------------------

  align(center)[
    #block(spacing: 0.3em)[#upper[Записи]]
    #block(spacing: 0.6em)[о работах, выполненных в период практики]
  ]

  // Заголовок таблицы — жирным, по центру, перенос на следующую строку.
  let header = (cell, content) => table.cell(
    align: center + horizon,
    text(weight: "bold")[#content],
  )

  // Минимальная высота строк данных задаётся через `rows`, чтобы было
  // место заполнить от руки замечания руководителя.
  let data-row-height = 3.5em
  let rows-spec = (auto,) + (data-row-height,) * entries.len()

  table(
    columns: (3cm, 1fr, 1fr),
    rows: rows-spec,
    stroke: 0.5pt,
    inset: 6pt,
    header(none)[Дата],
    header(none)[Содержание / Результаты работы],
    header(none)[Замечания руководителя(ей) практики],
    ..entries
      .map(entry => {
        let date = entry.at(0, default: "")
        let content = entry.at(1, default: "")
        let note = entry.at(2, default: "")
        (
          table.cell(align: center + horizon)[#date],
          table.cell(align: left + horizon)[#content],
          table.cell(align: left + horizon)[#note],
        )
      })
      .flatten(),
  )

  v(0.6em)

  // --- Подписи --------------------------------------------------------

  if supervisor-org != none {
    let pos = supervisor-org.at("position", default: none)
    let org-name = supervisor-org.at("org", default: none)
    let org-part = if org-name != none { [ #org-name] } else { [ профильной организации] }
    block(width: 100%, spacing: 0.3em)[Руководитель практики]
    block(width: 100%, spacing: 0.3em)[от#org-part,]
    sign-line(pos, supervisor-org.at("name", default: none))
  }

  if supervisor-uni != none {
    let pos = supervisor-uni.at("position", default: none)
    let org-name = supervisor-uni.at("org", default: none)
    let uni-org = if org-name != none { org-name } else { [ФГБОУ ВО «МГУ им. Н.П. Огарёва»] }
    v(0.3em)
    block(width: 100%, spacing: 0.3em)[Руководитель практики]
    block(width: 100%, spacing: 0.3em)[от #uni-org,]
    sign-line(pos, supervisor-uni.at("name", default: none))
  }
}
