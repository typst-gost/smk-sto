// smk-sto-004 — Typst-шаблон для оформления отчётов о лабораторных работах
// по СМК СТО 004–2020 (МГУ им. Н.П. Огарёва).

#import "constants.typ": (
  default-font, default-text-size, default-small-size,
  default-indent, default-margin,
  default-okpo, default-city, default-ministry, default-organization,
  structural-headings,
)
#import "style.typ": smk-style
#import "title.typ": title-page
#import "utils.typ": (
  enum-letter, sign-field, format-designation,
  table-label, table-continuation, nbsp-name,
)
#import "appendix.typ": appendix
#import "diagram.typ": diagram, node, edge

// Главный show-rule. Применяется так:
//
//   #show: lab-report.with(
//     work-number: 1,
//     title: "Измерение в цепях постоянного тока",
//     discipline: "Поверка средств измерений электрических величин",
//     institute: "Институт электроники и светотехники",
//     department: "Кафедра метрологии, стандартизации и сертификации",
//     author: (name: "И.И. Иванов",
//              direction: "27.03.01 Стандартизация и метрология"),
//     supervisor: (name: "П.П. Петров",
//                  position: "канд. техн. наук, доц."),
//     designation: (direction: "27.03.01", variant: "08"),
//   )
//
//   = Цель работы
//   ...
//
#let lab-report(
  // Контент титульного листа.
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
  // Параметры оформления.
  text-size: default-text-size,
  small-size: default-small-size,
  indent: default-indent,
  margin: default-margin,
  font: default-font,
  hide-title: false,
  add-pagebreaks: true,
  body,
) = {
  show: smk-style.with(
    text-size: text-size,
    small-size: small-size,
    indent: indent,
    margin: margin,
    font: font,
    add-pagebreaks: add-pagebreaks,
  )

  if not hide-title {
    title-page(
      ministry: ministry,
      organization: organization,
      institute: institute,
      department: department,
      work-number: work-number,
      discipline: discipline,
      title: title,
      author: author,
      supervisor: supervisor,
      designation: designation,
      city: city,
      year: year,
    )
    pagebreak(weak: true)
  }

  body
}
