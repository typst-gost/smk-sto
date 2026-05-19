// smk-sto — Typst-шаблон для оформления учебной отчётности
// в ФГБОУ ВО «МГУ им. Н.П. Огарёва»:
//
//   • отчёт о лабораторной работе — СМК СТО 004–2020 (`lab-report`);
//   • отчёт о практике           — СМК СТО 014–2025 (`practice-report`).
//
// Подключение:
//
//   #import "@preview/smk-sto:0.3.0": *
//
//   #show: lab-report.with(...)       // для лабораторной работы
//   // или
//   #show: practice-report.with(...)  // для отчёта о практике

#import "constants.typ": (
  default-city, default-font, default-indent, default-margin, default-ministry, default-okpo, default-organization,
  default-small-size, default-text-size,
)
#import "style.typ": smk-style
#import "utils.typ": enum-letter, nbsp-name, sign-field, table-continuation, table-label, where-block
#import "appendix.typ": appendix
#import "diagram.typ": diagram, edge, node

// Лабораторные работы (СМК СТО 004–2020).
#import "lab/report.typ": lab-report
#import "lab/title.typ": lab-report-title-page
#import "lab/designation.typ": lab-report-designation

// Отчёт о практике (СМК СТО 014–2025).
#import "practice/report.typ": practice-report
#import "practice/title.typ": practice-report-title-page
#import "practice/designation.typ": practice-report-designation
// Сопровождающие формы (Приложения Б, Г, Д, Ж к СТО 014–2025).
#import "practice/task.typ": practice-report-task
#import "practice/diary.typ": practice-report-diary
#import "practice/survey.typ": practice-report-survey
#import "practice/feedback.typ": practice-report-feedback

