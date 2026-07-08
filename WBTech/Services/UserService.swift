import Foundation

struct User: Identifiable {
  let id: UUID
  let username: String
  let email: String
}

protocol UserServiceProtocol {
  func fetchCurrentUser(completion: @escaping (User?) -> Void)
}

class MockUserService: UserServiceProtocol {
  func fetchCurrentUser(completion: @escaping (User?) -> Void) {
    // Имитируем сетевую задержку в 1 секунду
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      let mockUser = User(id: UUID(), username: "WB_User", email: "user@wildberries.ru")
      completion(mockUser)
    }
  }
}
