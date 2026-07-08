import SwiftUI
import UISystem

struct LoginView: View {
  @Injected var authService: AuthServiceProtocol
  @Injected var router: RouterProtocol
  
  @State private var username = ""
  @State private var password = ""
  @State private var isLoading = false
  @State private var errorMessage: String?
  
  var body: some View {
    ZStack {
      // Фон для всего экрана
      Color(uiColor: .secondarySystemBackground)
        .ignoresSafeArea()
      
      VStack {
        Spacer()
        
        DSCard {
          VStack(spacing: 8) {
            Text("Вход")
              .font(.largeTitle.bold())
              .padding(.bottom, 16)
            
            DSTextField(
              placeholder: "Логин",
              text: $username
            )
            
            DSTextField(
              placeholder: "Пароль",
              text: $password,
              isSecure: true,
              errorMessage: errorMessage
            )
            
            DSButton(title: isLoading ? "Загрузка..." : "Войти") {
              login()
            }
            .padding(.top, 16)
            .disabled(isLoading || username.isEmpty || password.isEmpty)
          }
        }
        .padding(.horizontal, 20)
        
        Spacer()
      }
    }
    .navigationBarHidden(true)
  }
  
  private func login() {
    isLoading = true
    errorMessage = nil
    
    // Используем наш моковый сервис
    authService.login { result in
      isLoading = false
      switch result {
      case .success:
        // При успехе - идем дальше (например в профиль или каталог)
        router.push(.profile)
      case .failure(let error):
        errorMessage = error.localizedDescription
      }
    }
  }
}

#Preview {
  LoginView()
}
