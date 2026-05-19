// Анкета обучающегося по результатам прохождения практики —
// Приложение Д к СМК СТО 014–2025.

#import "../constants.typ": default-margin
#import "form-helpers.typ": kind-line, small-label, underlined-box

// Полный список вопросов и допустимых ответов фиксирован стандартом —
// здесь определяются их значения по умолчанию. Пользователь передаёт
// словарь `answers` с ключами `q1` … `q11`; пустые ключи остаются
// неотмеченными чекбоксами.

#let _q1-options = ("да", "нет")
#let _q2-options = (
  "в РПП недостаточно информации для составления отчета",
  "РПП не подходит к профильной организации",
  "не ознакомлен(а) с РПП",
  "РПП мне понятна",
)
#let _q3-options = ("да", "скорее да, чем нет", "скорее нет, чем да", "нет")
#let _q4-options = _q3-options
#let _q5-options = (
  "да",
  "нет",
  "со мной заключили срочный договор о трудоустройстве на время прохождения практики",
  "со мной заключили договор о трудоустройстве, который позволяет совмещать работу с учёбой по индивидуальному графику посещения занятий",
)
#let _q6-options = (
  "на практике я ещё больше убедился(ась) в правильности выбора профессии",
  "практика разочаровала меня в выбранной профессии",
  "практика обнаружила пробелы в моей специальной подготовке",
  "практика носила формальный характер",
)
#let _q10-options = (
  "полностью удовлетворён(а)",
  "удовлетворён(а) частично",
  "полностью не удовлетворён(а)",
)

// Вариант ответа c чекбоксом. `checked: true` ставит «☑».
#let _choice(label, checked: false) = block(width: 100%, spacing: 0.25em)[
  #if checked { sym.ballot.check } else { sym.ballot } #h(0.4em) #label
]

// Блок «один ответ»: список вариантов с отмеченным выбранным.
#let _single-choice(options, selected) = {
  for opt in options {
    _choice([#opt], checked: opt == selected)
  }
}

// Числовая оценка 1–5. Если значение указано — просто цифра без рамки
// (поле «впечатано»); если значение `none` — рамка с линией снизу как
// плейсхолдер для рукописного заполнения распечатанной формы.
#let _rating(value) = if value != none {
  [ #value]
} else {
  box(
    stroke: (bottom: 0.5pt),
    width: 1cm,
    inset: (bottom: 2pt),
    align(center, sym.zws),
  )
}

#let practice-report-survey(
  kind: none,
  practice-type: none,
  answers: (:), // dict с ключами q1 … q11
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

  // --- Шапка формы ----------------------------------------------------

  align(center)[
    #block(spacing: 0.65em)[#upper[Анкета]]
  ]

  kind-line(kind: kind, noun: [практика], label: [Вид практики])

  align(center, block(width: 50%, spacing: 0.4em)[
    #grid(
      columns: 1fr,
      row-gutter: 3pt,
      underlined-box(if practice-type != none { [#practice-type] } else { none }),
      small-label[Тип практики в соответствии с ОПОП ВО],
    )
  ])

  v(0.6em)

  // --- Вопросы --------------------------------------------------------

  let q-block(num, text-body, body) = block(
    width: 100%,
    breakable: false,
    spacing: 0.6em,
  )[
    #num #text-body
    #body
  ]

  q-block([1], [Удовлетворены ли Вы местом прохождения практики? (один ответ)], _single-choice(_q1-options, answers.at(
    "q1",
    default: none,
  )))

  q-block(
    [2],
    [Удовлетворены ли Вы качеством разработки рабочей программы практики (РПП)? (один ответ)],
    _single-choice(_q2-options, answers.at("q2", default: none)),
  )

  q-block(
    [3],
    [Считаете ли Вы достаточными для выполнения работ, предусмотренных РПП, теоретические знания, которые Вы получили в Университете? (один ответ)],
    _single-choice(_q3-options, answers.at("q3", default: none)),
  )

  q-block(
    [4],
    [Дала ли производственная практика возможность применить и развить навыки, необходимые для дальнейшей профессиональной деятельности (в соответствии с Вашим направлением подготовки/Вашей специальностью)? (один ответ)],
    _single-choice(_q4-options, answers.at("q4", default: none)),
  )

  q-block(
    [5],
    [Хотели бы Вы в дальнейшем продолжить свою трудовую деятельность в организации, в которой проходили практику? (один ответ)],
    _single-choice(_q5-options, answers.at("q5", default: none)),
  )

  q-block([6], [Как Вы оцениваете итоги практики с точки зрения её результативности? (один ответ)], _single-choice(
    _q6-options,
    answers.at("q6", default: none),
  ))

  q-block(
    [7],
    [Оцените степень удовлетворённости местом прохождения практики (материально-техническая оснащённость, кадровый состав) по пятибалльной шкале (1 — очень плохо, 5 — отлично)],
    _rating(answers.at("q7", default: none)),
  )

  q-block(
    [8],
    [Оцените степень удовлетворённости взаимоотношениями с руководителем практики от профильной организации по пятибалльной шкале (1 — очень плохо, 5 — отлично)],
    _rating(answers.at("q8", default: none)),
  )

  q-block(
    [9],
    [Оцените степень удовлетворённости взаимоотношениями с руководителем практики от Университета по пятибалльной шкале (1 — очень плохо, 5 — отлично)],
    _rating(answers.at("q9", default: none)),
  )

  q-block([10], [Оцените удовлетворённость в целом условиями прохождения практики (один ответ)], _single-choice(
    _q10-options,
    answers.at("q10", default: none),
  ))

  // Вопрос 11 — свободный текст. Если ответ указан, выводим обычным
  // абзацем; если нет — 3 линии-плейсхолдера для рукописного заполнения.
  let q11 = answers.at("q11", default: none)
  block(width: 100%, breakable: false, spacing: 0.6em)[
    11 Ваши предложения по организации практики:

    #v(0.2em)
    #if q11 != none {
      block(width: 100%)[#q11]
    } else {
      context {
        let line-h = measure([Xg]).height + 0.55em
        block(width: 100%, inset: (top: 0pt, bottom: 0pt))[
          #place(top + left, dy: line-h - 1pt, line(length: 100%, stroke: 0.5pt))
          #place(top + left, dy: 2 * line-h - 1pt, line(length: 100%, stroke: 0.5pt))
          #place(top + left, dy: 3 * line-h - 1pt, line(length: 100%, stroke: 0.5pt))
          #sym.zws
          #v(3 * line-h, weak: false)
        ]
      }
    }
  ]
}
