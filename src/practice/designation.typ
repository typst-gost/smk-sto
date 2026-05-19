// Обозначение отчёта о практике по СМК СТО 014–2025 п. 5.6:
//
//   ОП–02069964–В–DD.NN.NN–NN–YYYY
//
// где В — вид практики (У — учебная, П — производственная);
// DD.NN.NN — код направления подготовки/специальности;
// NN — порядковый номер обучающегося по списку из приказа
//      о направлении на практику;
// YYYY — год прохождения практики (по примеру стандарта — 4 цифры).
//
// Пример из стандарта: «ОП–02069964–У–27.03.01–01–2025».
//
// Код 02069964 — для МГУ им. Н.П. Огарёва; 05121346 — для Рузаевского
// института машиностроения (филиал); 51151189 — для Ковылкинского филиала.
//
// Параметры словаря:
//   `kind`           — буква вида практики (У / П);
//   `direction`      — код направления подготовки/специальности;
//   `student-number` — порядковый номер обучающегося по списку из приказа.
//                      Принимается также синоним `variant` — для совместимости
//                      с лабораторными отчётами и более ранними версиями
//                      пакета.
//   `year`           — год прохождения практики;
//   `okpo`           — код университета по ОКПО (по умолчанию 02069964).

#let practice-report-designation(
  designation,
  default-okpo: "02069964",
  current-year: none,
) = {
  if designation == none { return none }
  if type(designation) == str { return designation }
  if type(designation) == dictionary {
    let kind = designation.at("kind", default: none)
    let direction = designation.at("direction", default: none)
    // Порядковый номер обучающегося — основное имя `student-number`,
    // допускается `variant` для обратной совместимости.
    let number = designation.at(
      "student-number",
      default: designation.at("variant", default: none),
    )
    let year = designation.at("year", default: current-year)
    let okpo = designation.at("okpo", default: default-okpo)
    if type(year) == int { year = str(year) }
    if type(number) == int { number = str(number) }
    if type(number) == str and number.len() == 1 { number = "0" + number }
    let parts = ("ОП", okpo, kind, direction, number, year)
      .filter(p => p != none)
    return parts.join("–")
  }
  panic("Некорректный тип поля designation: ожидалась строка или словарь")
}
