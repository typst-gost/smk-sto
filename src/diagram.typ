// Блок-схемы и графы зависимостей через пакет fletcher.
// Удобный способ заменить рисунки из drawio/Visio: узлы и стрелки
// описываются прямо в Typst — без внешних SVG/PNG.
//
// Чтобы получить полноценный «Рисунок N – Подпись» по СТО 8.5,
// заверните вызов в `#figure(...)`:
//
//   #figure(
//     diagram(
//       node((0, 0), [contur2 (app)]),
//       node((1, 1), [contur2_lib]),
//       edge((0, 0), (1, 1), "->", [link]),
//     ),
//     caption: [Граф зависимостей модулей],
//   )

#import "@preview/fletcher:0.5.8" as fletcher

// Диаграмма по умолчанию: тонкие чёрные линии, скруглённые
// прямоугольники, шрифт документа. Все параметры fletcher.diagram
// можно переопределить.
#let diagram(
  spacing: 1.2cm,
  node-stroke: 0.5pt,
  node-shape: fletcher.shapes.rect,
  node-corner-radius: 4pt,
  node-inset: 8pt,
  edge-stroke: 0.5pt,
  ..args,
) = align(center, fletcher.diagram(
  spacing: spacing,
  node-stroke: node-stroke,
  node-shape: node-shape,
  node-corner-radius: node-corner-radius,
  node-inset: node-inset,
  edge-stroke: edge-stroke,
  ..args,
))

#let node = fletcher.node
#let edge = fletcher.edge
