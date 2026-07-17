//
//  ProductDetailedView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 7/17/26.
//

import SwiftUI
import UISystem
import OSLog

struct ProductDetailedView: View {
  let catalogService: CatalogServiceProtocol
  let product: Product
  let onError: (() -> Void)?

  @Environment(FavoritesStore.self) private var favoritesStore
  @Environment(CartStore.self) private var cartStore
  
  @State private var isLoading = true
  @State private var productDetailed: ProductDetailed?

  var body: some View {
    let id = product.id
    let isFavorite = favoritesStore.isFavorite(id: id, fallback: product.isFavorite)

    ProductDetailedContentView(
      config: product.uiConfig(isFavorite: isFavorite),
      description: productDetailed?.description,
      reviews: productDetailed?.reviews ?? [],
      quantity: cartStore.quantity(for: id),
      onIncrement: { Task { await cartStore.increment(id: id) } },
      onDecrement: { Task { await cartStore.remove(id: id) } },
      onFavoriteTap: { Task { await favoritesStore.toggle(id: id, fallback: product.isFavorite) } },
      onError: onError
    )
    .task {
      await loadProductDetailed()
    }
  }
  
  private func loadProductDetailed() async {
    isLoading = true
    do {
      productDetailed = try await catalogService.fetchProduct(id: product.id)
    } catch {
      Logger.catalog.error("Error loading detailed product info for item with id=\(product.id): \(error.localizedDescription)")
    }
    isLoading = false
  }
}

#Preview {
  ProductDetailedView(
    catalogService: MockCatalogService(),
    product: Product(
      id: "product1",
      image: URL(string: "https://damcdn.samokat.ru/dam-storage-ext-env-prod/2025/12/026c8f99-bbe3-40b4-9ef9-3c3759a857ff"),
      name: "Огурец в тесте c соусом",
      weight: 80,
      price: 750,
      rating: 3.8,
      reviewCount: 1356,
      isFavorite: false,
      discount: 0
    ),
    onError: {}
  )
  .environment(CartStore(cartService: MockCartService()))
  .environment(FavoritesStore(favoritesService: MockFavoritesService()))
}
