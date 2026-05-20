// Главный show-rule для отчёта о практике по СМК СТО 014–2025.

#import "../constants.typ": (
  default-font, default-text-size, default-small-size,
  default-indent, default-margin,
)
#import "../style.typ": smk-style

// Применяется так:
//
//   #show: practice-report
//
//   #practice-report-title-page(
//     institute: "Факультет математики и информационных технологий",
//     department: "Кафедра анализа данных и искусственного интеллекта",
//     kind: "учебную",
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
#let practice-report(
  // Параметры оформления.
  text-size: default-text-size,
  small-size: default-small-size,
  indent: default-indent,
  margin: default-margin,
  font: default-font,
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

  body
}
