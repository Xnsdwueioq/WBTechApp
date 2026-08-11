# WBTech

![Swift](https://img.shields.io/badge/Swift-6.0-F05138?logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS_26-0D96F6?logo=swift&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-26-147EFB?logo=xcode&logoColor=white)
![Tests](https://img.shields.io/badge/Tests-Swift_Testing-34C759)

Учебное приложение доставки продуктов на SwiftUI с каталогом, поиском, корзиной и отзывами.

## Возможности

- каталог товаров и выбор категорий;
- поиск с подсказками и избранное;
- корзина, расчёт заказа и оформление;
- подробная карточка товара, рейтинги и отзывы.

## Стек

SwiftUI · Observation · Swift Concurrency · Swift Testing · OpenAPI Generator · Keychain

## Запуск

1. Откройте `WBTech.xcodeproj` в Xcode.
2. В `Product → Scheme → Edit Scheme → Run → Arguments` добавьте `BEARER_TOKEN` в Environment Variables.
3. Запустите проект (`⌘R`). При первом запуске токен сохранится в Keychain.

API-клиент генерируется из [`WBTech/openapi.json`](WBTech/openapi.json) во время сборки.
