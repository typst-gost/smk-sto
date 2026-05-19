// Главный show-rule для отчёта о практике по СМК СТО 014–2025.

#import "../constants.typ": (
  default-font, default-text-size, default-small-size,
  default-indent, default-margin,
  default-city, default-ministry, default-organization,
)
#import "../style.typ": smk-style
#import "title.typ": practice-report-title-page

// Применяется так:
//
//   #show: practice-report.with(
//     institute: "Факультет математики и информационных технологий",
//     department: "Кафедра анализа данных и искусственного интеллекта",
//     kind: "учебная",
//     practice-type: "ознакомительная",
//     author: (name: "Е. А. Рыбина", course: 1, group: "103М"),
//     direction: (code: "09.04.04", name: "Программная инженерия"),
//     profile: "Управление разработкой программных проектов",
//     location: "г. Саранск, ФГБОУ ВО «МГУ им. Н. П. Огарёва», ...",
//     period: (start: "08.09.2025", end: "27.12.2025"),
//     designation: (kind: "У", direction: "09.04.04", variant: "11"),
//     supervisor-uni: (
//       name: "Е. В. Щенникова",
//       position: "д-р физ.-мат. наук, доц.",
//     ),
//   )
//
//   = Введение <s>
//   ...
//
//   = Анализ предметной области
//   ...
//
#let practice-report(
  // Контент титульного листа.
  ministry: default-ministry,
  organization: default-organization,
  institute: none,
  department: none,
  kind: none,
  practice-type: none,
  // Гендер обучающегося («male» / «female» / `none`) — влияет на
  // словоформы (см. `student-word` в practice/form-helpers.typ).
  gender: none,
  author: none,
  direction: none,
  profile: none,
  location: none,
  period: none,
  designation: none,
  supervisor-org: none,
  supervisor-uni: none,
  defense: none,
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
    practice-report-title-page(
      ministry: ministry,
      organization: organization,
      institute: institute,
      department: department,
      kind: kind,
      practice-type: practice-type,
      gender: gender,
      author: author,
      direction: direction,
      profile: profile,
      location: location,
      period: period,
      designation: designation,
      supervisor-org: supervisor-org,
      supervisor-uni: supervisor-uni,
      defense: defense,
      city: city,
      year: year,
    )
    pagebreak(weak: true)
  }

  body
}
