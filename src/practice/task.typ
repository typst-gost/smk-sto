// Задание на практику — Приложение Б к СМК СТО 014–2025.

#import "../constants.typ": default-margin
#import "form-helpers.typ": field-line, kind-line, label-for, sign-line, student-word, underlined-box

#let practice-report-task(
  kind: none, // строка: «учебной» / «производственной»
  practice-type: none, // строка: тип в соответствии с ОПОП ВО
  // Гендер обучающегося — влияет на словоформу обращения.
  gender: none,
  // Обращение к обучающемуся; по умолчанию — словоформа по гендеру.
  student-prefix: auto,
  author: none, // dict (name, course, group) или строка-имя
  direction: none, // dict (code, name) или строка
  profile: none, // строка («Направленность (профиль)»)
  location: none, // строка
  period: none, // dict (start, end) или строка
  // Срок представления отчёта на защиту и отзыва.
  submission-date: none,
  // Содержательная часть задания.
  goals: none, // 1 Цели и задачи практики
  competencies: none, // 2 Компетенции обучающегося
  tasks: none, // 3 Задание на практику (строка или список)
  supervisor-org: none, // руководитель от профильной организации
  supervisor-uni: none, // руководитель от Университета
  margin: default-margin,
) = {
  // Каждое приложение — отдельный документ со своей нумерацией страниц;
  // на форме номер не печатается (СТО 014–2025 п. 5.1.1).
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

  // Подготовка значений.
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

  let period-str = if type(period) == str {
    period
  } else if type(period) == dictionary {
    let s = period.at("start", default: none)
    let e = period.at("end", default: none)
    if s != none and e != none { [#s – #e] } else if s != none { [#s] } else if e != none { [#e] } else { none }
  } else { none }

  let tasks-content = if tasks == none {
    none
  } else if type(tasks) == array {
    // Список задач — рендерим как нумерованный enum.
    enum(..tasks.map(t => [#t]))
  } else { tasks }

  // Словоформа обращения к обучающемуся — по гендеру, если явно не задано.
  let prefix = if student-prefix == auto {
    student-word(case: "dative", gender: gender)
  } else {
    student-prefix
  }

  // --- Шапка формы ----------------------------------------------------

  align(center)[
    #block(spacing: 0.65em)[#upper[Задание]]
  ]

  v(0.4em)

  // «на [учебную] практику» с подписью «вид практики».
  kind-line(prefix: [на], kind: kind, noun: [практику], label: [вид практики])

  // «[ознакомительная]» с подписью «Тип практики в соответствии с ОПОП ВО».
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

  // Курс/группа — отдельная строка с фиксированными короткими боксами.
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

  field-line(
    [Место прохождения практики],
    location,
    label: [населённый пункт, профильная организация, структурное подразделение],
  )

  field-line(
    [Срок прохождения практики],
    period-str,
    label: [начало (дата) – окончание (дата)],
  )

  field-line(
    [Срок представления отчёта на защиту и отзыва руководителя практики от профильной организации],
    submission-date,
    label: [дата],
  )

  v(0.4em)

  // --- Содержательная часть: 1/2/3 ------------------------------------

  field-line([1 Цели и задачи практики], goals)

  field-line(
    [2 Компетенции обучающегося, формируемые в результате прохождения практики],
    competencies,
  )

  // Задание на практику — может быть длинным многострочным списком.
  block(spacing: 0.4em)[3 Задание на практику]
  if tasks-content != none {
    set par(first-line-indent: 0pt, justify: false)
    tasks-content
  }

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

  // Поле «к исполнению принял» — подпись обучающегося.
  v(0.3em)
  sign-line([Задание к исполнению принял], author-rec.at("name", default: none))
}
