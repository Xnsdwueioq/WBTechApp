// ModalRouterProtocol.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 17.07.2026.

protocol ModalRouterProtocol {
  
  var sheet: SheetRoute? { get }
  func present(route: SheetRoute)
  func dismiss()
  
}
