// ModalRouterProtocol.swift
// WBTech
// Created by Eyhciurmrn Zmpodackrl on 17.07.2026.

protocol ModalRouterProtocol {
  
  var sheet: SheetRoute? { get }
  var pendingSheet: SheetRoute? { get }
  func present(route: SheetRoute)
  func replace(with route: SheetRoute)
  func presentPendingIfNeeded()
  func dismiss()
  
}
