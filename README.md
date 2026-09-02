# WBTech

![Swift](https://img.shields.io/badge/Swift-6.0-F05138?logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-iOS_26-0D96F6?logo=swift&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-26-147EFB?logo=xcode&logoColor=white)
![Tests](https://img.shields.io/badge/Tests-Swift_Testing-34C759)

Учебное приложение доставки продуктов на SwiftUI

## Возможности

- каталог по категориям, поиск с подсказками и избранное;
- подробная карточка товара, рейтинги, отзывы и отправка отзыва;
- синхронизация корзины с API, расчёт стоимости и локальный SwiftData-кэш;
- список адресов с добавлением, редактированием и удалением;
- поиск адреса и выбор точки доставки на карте через MapKit;
- оформление заказа с выбранным адресом;
- пользовательские алерты при ошибках API.

## Стек

SwiftUI · Observation · Swift Concurrency · MapKit · SwiftData · Swift Testing · Keychain · OpenAPI Generator

## Запуск

1. Откройте `WBTech.xcodeproj` в Xcode.
2. В `Product → Scheme → Edit Scheme → Run → Arguments` добавьте `BEARER_TOKEN` в Environment Variables.
3. Запустите проект (`⌘R`). При первом запуске токен сохранится в Keychain.

API-клиент генерируется из [`WBTech/openapi.json`](WBTech/openapi.json) во время сборки.
