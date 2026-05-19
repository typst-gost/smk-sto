// Отзыв руководителя практики от профильной организации —
// Приложение Ж к СМК СТО 014–2025.

#import "../constants.typ": default-margin
#import "form-helpers.typ": field-line, label-for, sign-line, student-word, underlined-box

#let practice-report-feedback(
  // Сведения о виде/типе практики — кратко, без отдельной строки шапки;
  // отображаются после слова «Руководителя ... практики от ...».
  practice-name: none, // строка: «вид, тип практики в соответствии с ОПОП ВО»
  host-org: none, // полное наименование профильной организации
  // Гендер обучающегося — влияет на словоформу «Обучающийся».
  gender: none,
  author: none, // dict (name) или строка
  direction: none, // dict (code, name) или строка
  profile: none,
  period: none, // dict (start, end) или строка
  // Шесть содержательных пунктов отзыва (значения опциональны).
  self-reliance: none, // 1
  analysis: none, // 2
  results: none, // 3
  attitude: none, // 4
  professional: none, // 5
  personal: none, // 6
  supervisor-org: none, // подпись руководителя от профильной
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
    (name: author)
  } else if type(author) == dictionary {
    author
  } else if author == none {
    (name: none)
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

  // Словоформа обращения к обучающемуся — по гендеру.
  let prefix = student-word(case: "nominative", gender: gender)

  // --- Шапка формы ----------------------------------------------------

  align(center)[
    #block(spacing: 0.65em)[#upper[Отзыв]]
  ]

  v(0.3em)

  // «Руководителя [вид, тип] практики от» — длинная строка с двумя
  // подписями-комментариями. Структура повторяет бланк стандарта.
  block(width: 100%, breakable: false, spacing: 0.4em)[
    #grid(
      columns: (auto, 1fr, auto),
      column-gutter: 0.5em,
      row-gutter: 3pt,
      align: (left + bottom, center + bottom, left + bottom),
      [Руководителя], underlined-box(if practice-name != none { [#practice-name] } else { none }), [практики от],
      [], label-for(practice-name, [вид, тип практики в соответствии с ОПОП ВО]), [],
    )
  ]

  // Полное наименование профильной организации — отдельная подчёркнутая строка.
  block(width: 100%, breakable: false, spacing: 0.4em)[
    #grid(
      columns: 1fr,
      row-gutter: 3pt,
      underlined-box(if host-org != none { [#host-org] } else { none }),
      label-for(host-org, [Полное наименование профильной организации]),
    )
  ]

  // --- Сведения об обучающемся ----------------------------------------

  field-line(
    [#prefix],
    author-rec.at("name", default: none),
    label: [Фамилия Имя Отчество],
  )

  field-line(
    [Направление подготовки / Специальность],
    dir-str,
    label: [код, наименование направления подготовки/специальности],
  )

  field-line([Направленность (профиль)], profile)

  field-line(
    [Сроки прохождения практики:],
    period-str,
    label: [начало (дата) – окончание (дата)],
  )

  v(0.4em)

  // --- Шесть содержательных пунктов -----------------------------------

  field-line([1 Степень самостоятельности решения поставленных задач:], self-reliance)
  field-line([2 Умение анализировать и делать обоснованные выводы и предложения:], analysis)
  field-line([3 Достигнутые результаты:], results)
  field-line([4 Отношение обучающегося к прохождению практики в целом, а также к конкретным заданиям:], attitude)
  field-line([5 Профессиональные качества обучающегося:], professional)
  field-line([6 Личностные качества обучающегося:], personal)

  v(1fr)

  // --- Подпись руководителя -------------------------------------------

  if supervisor-org != none {
    let pos = supervisor-org.at("position", default: none)
    let org-name = supervisor-org.at("org", default: none)
    let org-part = if org-name != none { [ #org-name] } else { [ профильной организации] }
    block(width: 100%, spacing: 0.3em)[Руководитель практики]
    block(width: 100%, spacing: 0.3em)[от#org-part,]
    sign-line(pos, supervisor-org.at("name", default: none))
  } else {
    block(width: 100%, spacing: 0.3em)[Руководитель практики]
    block(width: 100%, spacing: 0.3em)[от профильной организации,]
    sign-line([должность], none)
  }
}
