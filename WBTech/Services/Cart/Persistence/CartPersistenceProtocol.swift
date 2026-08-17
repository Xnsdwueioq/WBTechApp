//
//  CartPersistenceProtocol.swift
//  WBTech
//
//  Created by sye7qjm3ac on 18.08.2026.
//

@MainActor
protocol CartPersistenceProtocol {

  func saveQuantities(_ quantities: [String: Int]) throws
  func loadQuantities() throws -> [String: Int]
  func clear() throws

}
