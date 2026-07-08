import Foundation

protocol AuthServiceProtocol {
  var isAuthenticated: Bool { get }
  func login(completion: @escaping (Result<Void, Error>) -> Void)
  func logout()
}

class MockAuthService: AuthServiceProtocol {
  var isAuthenticated: Bool = false
  
  func login(completion: @escaping (Result<Void, Error>) -> Void) {
    // Имитируем сетевую задержку в 1 секунду
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.isAuthenticated = true
      completion(.success(()))
    }
  }
  
  func logout() {
    isAuthenticated = false
  }
}
