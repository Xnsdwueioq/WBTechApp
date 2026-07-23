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
  let id: String
  let product: Product?
  let onOpenCart: () -> Void
  let onError: (() -> Void)?

  @Environment(FavoritesStore.self) private var favoritesStore
  @Environment(CartStore.self) private var cartStore
  
  @State private var productDetailed: ProductDetailed?
  @State private var isReviews = false

  private var isPlaceholder: Bool {
    productDetailed == nil && product == nil
  }

  private var fallbackFavorite: Bool {
    productDetailed?.isFavorite ?? product?.isFavorite ?? false
  }

  private var config: DSProductConfig {
    let isFavorite = favoritesStore.isFavorite(id: id, fallback: fallbackFavorite)

    if let productDetailed {
      return productDetailed.uiConfig(isFavorite: isFavorite)
    }
    if let product {
      return product.uiConfig(isFavorite: isFavorite)
    }
    return Product.uiConfigDefault
  }

  var body: some View {
    ProductDetailedContentView(
      config: config,
      description: productDetailed?.description,
      reviews: productDetailed?.reviews ?? [],
      quantity: cartStore.quantity(for: id),
      onIncrement: { Task { await cartStore.increment(id: id) } },
      onDecrement: { Task { await cartStore.remove(id: id) } },
      onFavoriteTap: { Task { await favoritesStore.toggle(id: id, fallback: fallbackFavorite) } },
      onOpenCart: onOpenCart,
      onReviews: { isReviews.toggle() },
      onError: onError
    )
    .redacted(reason: isPlaceholder ? .placeholder : [])
    .task {
      await loadProductDetailed()
    }
    .sheet(isPresented: $isReviews) {
      ReviewsView(
        reviews: productDetailed?.reviews ?? [],
        rating: productDetailed?.rating ?? 0,
        productId: id,
        onReviewCreated: { Task { await loadProductDetailed() } } // TODO: Insert Action
      )
    }
  }

  private func loadProductDetailed() async {
    do {
      productDetailed = try await catalogService.fetchProduct(id: id)
    } catch {
      Logger.catalog.error("Error loading detailed product info for item with id=\(id): \(error.localizedDescription)")
    }
  }
}

#Preview {
  ProductDetailedView(
    catalogService: MockCatalogService(),
    id: "product1",
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
    onOpenCart: {},
    onError: {}
  )
  .environment(CartStore(cartService: MockCartService()))
  .environment(FavoritesStore(favoritesService: MockFavoritesService()))
}
