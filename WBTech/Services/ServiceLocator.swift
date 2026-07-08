//
//  ServiceLocator.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/7/26.
//

import Foundation

protocol ServiceLocating {
  
  func register<T>(service: T)
  func resolve<T>() -> T
  
}

final class ServiceLocator: ServiceLocating {
  
  static let shared = ServiceLocator()
  private var services = [ObjectIdentifier: Any]()
  
  private init() {
    register(service: Router() as RouterProtocol)
    register(service: MockAuthService() as AuthServiceProtocol)
    register(service: MockUserService() as UserServiceProtocol)
  }
  
  func register<T>(service: T) {
    services[ObjectIdentifier(T.self)] = service
  }
  
  func resolve<T>() -> T {
    guard let service = services[ObjectIdentifier(T.self)] as? T else {
      fatalError("Зависимость \(T.self) не зарегестрирована")
    }
    return service
  }
  
}

@propertyWrapper struct Injected<T> {
  var wrappedValue: T {
    ServiceLocator.shared.resolve()
  }
}
