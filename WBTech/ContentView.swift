//

import SwiftUI

struct ContentView: View {
  @Injected var router: RouterProtocol
  @Injected var authService: AuthServiceProtocol
  
  private var routerBindable: Binding<NavigationPath> {
    Binding(
      get: { (router as! Router).path },
      set: { (router as! Router).path = $0 }
    )
  }
  
  var body: some View {
    NavigationStack(path: routerBindable) {
      VStack {
        Text("Статус: \(authService.isAuthenticated ? "Авторизован" : "Не авторизован")")
          .foregroundColor(.secondary)
        
        VStack {
          Button("Перейти к Логину (Route.auth)") {
            router.push(.auth)
          }
          Button("Перейти к Каталогу (Route.catalog)") {
            router.push(.catalog)
          }
          Button("Перейти к Профилю (Route.profile)") {
            router.push(.profile)
          }
        }
        .buttonStyle(.borderedProminent)
        .tint(.red)
      }
      .navigationTitle("Главная")
      .navigationDestination(for: Route.self) { route in
        switch route {
        case .auth:
          LoginView()
        case .catalog:
          Text("Каталог")
        case .profile:
          Text("Профиль")
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
