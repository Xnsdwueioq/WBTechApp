# Работа с данными каталога и корзины

В этом модуле я подключил категории, поиск и избранное, а также добавил основную логику корзины.

## Что сделано

- **Корзина.** Количество товаров хранится в формате `[productId: quantity]`. Добавление, уменьшение количества и синхронизация с API находятся в [`CartStore`](WBTech/Services/Stores/CartStore.swift).
- **Категории.** Категории загружаются через `/categories` в [`CatalogService`](WBTech/Services/Catalog/CatalogService.swift) и отображаются на экране [`CategoriesView`](WBTech/Views/Catalog/CategoriesView.swift). После выбора открывается список товаров нужной категории.
- **Поиск.** В [`SearchTabView`](WBTech/Views/Tabs/SearchTabView.swift) добавлены поисковая строка и подсказки. Фильтрация товаров выполняется в [`SearchView`](WBTech/Views/Search/SearchView.swift).
- **Избранное.** Добавление и удаление товаров работает через [`FavoritesStore`](WBTech/Services/Stores/FavoritesStore.swift). Для избранных товаров сделан отдельный экран [`FavoritesView`](WBTech/Views/Favorites/FavoritesView.swift).
- **Оформление заказа.** В корзине отображаются стоимость товаров, доставка и итоговая сумма. Кнопка заказа доступна только при наличии доступных товаров и адреса. Основной экран — [`CartView`](WBTech/Views/Cart/CartView.swift), блок с итогами — [`CartOrderInfoView`](WBTech/Views/Cart/OrderInfo/CartOrderInfoView.swift).

## Скриншоты
![[Категории.png]]
![[Товары из категории.png]]![[Избранное.png]]![[Подсказки поиска.png]]![[Поиск.png]]![[Корзина неактивна.png]]![[Корзина активна.png]]