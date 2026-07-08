import SwiftUI
import UISystem

struct DSShowcaseView: View {
  @State private var textFieldValue = ""
  @State private var secureFieldValue = ""

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 32) {
        colorsSection
        typographySection
        componentsSection
      }
      .padding(20)
    }
    .background(DSColors.background.ignoresSafeArea())
    .navigationTitle("Дизайн-система")
    .navigationBarTitleDisplayMode(.inline)
  }

  private var colorsSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      sectionTitle("Цвета")
      colorRow("primary", DSColors.primary)
      colorRow("background", DSColors.background)
      colorRow("surface", DSColors.surface)
      colorRow("textPrimary", DSColors.textPrimary)
      colorRow("textSecondary", DSColors.textSecondary)
      colorRow("error", DSColors.error)
    }
  }

  private var typographySection: some View {
    VStack(alignment: .leading, spacing: 12) {
      sectionTitle("Типографика")
      typographyRow("title", "Заголовок 24 / bold", DSTypography.title)
      typographyRow("body", "Основной текст 16", DSTypography.body)
      typographyRow("caption", "Подпись 12", DSTypography.caption)
    }
  }

  private var componentsSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      sectionTitle("Компоненты")

      componentLabel("DSButton")
      DSButton(title: "Войти") {}

      componentLabel("DSTextField")
      DSTextField(placeholder: "Логин", text: $textFieldValue)
      DSTextField(placeholder: "Пароль", text: $secureFieldValue, isSecure: true)
      DSTextField(
        placeholder: "С ошибкой",
        text: .constant("invalid"),
        errorMessage: "Неверный формат"
      )

      componentLabel("DSCard")
      DSCard {
        Text("Заголовок карточки")
          .font(DSTypography.title)
        Text("Контейнер для контента с тенью и скруглением.")
          .font(DSTypography.body)
          .foregroundColor(DSColors.textSecondary)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }

  private func sectionTitle(_ text: String) -> some View {
    Text(text)
      .font(.title2.bold())
      .foregroundColor(DSColors.textPrimary)
  }

  private func componentLabel(_ text: String) -> some View {
    Text(text)
      .font(DSTypography.caption)
      .foregroundColor(DSColors.textSecondary)
  }

  private func colorRow(_ name: String, _ color: Color) -> some View {
    HStack(spacing: 12) {
      RoundedRectangle(cornerRadius: 8)
        .fill(color)
        .frame(width: 48, height: 48)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
      Text(name)
        .font(DSTypography.body)
        .foregroundColor(DSColors.textPrimary)
      Spacer()
    }
  }

  private func typographyRow(_ name: String, _ sample: String, _ font: Font) -> some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(name)
        .font(DSTypography.caption)
        .foregroundColor(DSColors.textSecondary)
      Text(sample)
        .font(font)
        .foregroundColor(DSColors.textPrimary)
    }
  }
}

#Preview {
  NavigationStack {
    DSShowcaseView()
  }
}
