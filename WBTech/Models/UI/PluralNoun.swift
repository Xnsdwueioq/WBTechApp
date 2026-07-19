// PluralNoun.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 20.07.2026.

import Foundation

struct PluralNoun {
  let one: String
  let few: String
  let many: String

  func form(for count: Int) -> String {
    let lastDigit = count % 10
    let lastTwoDigits = count % 100

    if lastDigit == 1 && lastTwoDigits != 11 { return one }
    if (2...4).contains(lastDigit) && !(12...14).contains(lastTwoDigits) { return few }
    return many
  }

  func counted(_ count: Int) -> String {
    "\(count) \(form(for: count))"
  }
}

extension PluralNoun {
  static let item = PluralNoun(one: "товар", few: "товара", many: "товаров")
  static let review = PluralNoun(one: "отзыв", few: "отзыва", many: "отзывов")
  static let minute = PluralNoun(one: "минута", few: "минуты", many: "минут")
}
