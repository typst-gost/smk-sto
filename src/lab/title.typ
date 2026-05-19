// Титульный лист отчёта о лабораторной работе.
// Форма — Приложение А к СМК СТО 004–2020.

#import "../constants.typ": (
  default-city, default-ministry, default-organization, default-okpo,
)
#import "../utils.typ": sign-field
#import "designation.typ": lab-report-designation

#let lab-report-title-page(
  ministry: default-ministry,
  organization: default-organization,
  institute: none,
  department: none,
  work-number: none,
  discipline: none,
  title: none,
  author: none,
  supervisor: none,
  designation: none,
  city: default-city,
  year: auto,
) = {
  if year == auto {
    year = int(datetime.today().display("[year]"))
  }

  let org = if type(organization) == str {
    (preamble: none, full: organization, short: none)
  } else if type(organization) == dictionary {
    (
      preamble: organization.at("preamble", default: none),
      full: organization.at("full", default: none),
      short: organization.at("short", default: none),
    )
  } else {
    panic("Некорректный тип поля organization")
  }

  let author-rec = if type(author) == str {
    (name: author, direction: none)
  } else if type(author) == dictionary {
    author
  } else if author == none {
    (name: none, direction: none)
  } else {
    panic("Некорректный тип поля author")
  }

  let sup-rec = if type(supervisor) == str {
    (name: supervisor, position: none)
  } else if type(supervisor) == dictionary {
    supervisor
  } else if supervisor == none {
    (name: none, position: none)
  } else {
    panic("Некорректный тип поля supervisor")
  }

  let direction = author-rec.at("direction", default: none)

  let work-num-str = if work-number != none {
    if type(work-number) == int { str(work-number) } else { work-number }
  } else { none }

  let desig = lab-report-designation(
    designation,
    default-okpo: default-okpo,
    current-year: year,
  )

  set par(
    justify: true,
    first-line-indent: 0pt,
    leading: 0.65em,
    spacing: 0.65em,
  )
  // На титульном листе переносы не допускаются (СТО 006–2025 п. 7.1.3,
  // СТО 004–2020 п. 8.1.1).
  set text(size: 14pt, hyphenate: false)
  set align(center)

  // Шапка университета
  block(spacing: 0.65em)[#ministry]
  v(0.7em)
  if org.preamble != none {
    block(spacing: 0.65em)[#org.preamble]
  }
  if org.full != none {
    block(spacing: 0.65em)[#org.full]
  }
  if org.short != none {
    block(spacing: 0.65em)[(#org.short)]
  }

  v(1em)

  if institute != none {
    block(spacing: 0.65em)[#institute]
    v(0.7em)
  }
  if department != none {
    block(spacing: 0.65em)[#department]
  }

  v(1fr)

  // Документ
  if work-num-str != none {
    block(spacing: 0.65em)[#upper[Отчёт о лабораторной работе №#work-num-str]]
  } else {
    block(spacing: 0.65em)[#upper[Отчёт о лабораторной работе]]
  }

  v(0.7em)

  if discipline != none {
    set align(center)
    block(spacing: 0.65em)[по дисциплине: #discipline]
  }

  v(0.7em)

  if title != none {
    block(spacing: 0.65em)[#upper(title)]
  }

  v(1fr)

  // Подписи
  set align(left)
  sign-field(
    [Автор отчёта о лабораторной работе],
    author-rec.at("name", default: none),
  )

  if desig != none {
    v(0.5em)
    block(width: 100%)[Обозначение лабораторной работы #desig]
  }

  if direction != none {
    v(0.5em)
    block(width: 100%)[Направление подготовки #direction]
  }

  v(0.7em)
  block(width: 100%)[Руководитель работы]
  sign-field(
    sup-rec.at("position", default: none),
    sup-rec.at("name", default: none),
  )

  v(1fr)

  set align(center)
  block[#city #year]
}
