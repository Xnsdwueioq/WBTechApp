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
  
  @State private var viewState = ViewState<ProductDetailed>.idle
  @State private var isReviews = false

  private var loadedDetailed: ProductDetailed? {
    if case .loaded(let detailed) = viewState {
      return detailed
    }
    return nil
  }

  private var fallbackFavorite: Bool {
    loadedDetailed?.isFavorite ?? product?.isFavorite ?? false
  }

  private var config: DSProductConfig {
    let isFavorite = favoritesStore.isFavorite(id: id, fallback: fallbackFavorite)

    if let loadedDetailed {
      return loadedDetailed.uiConfig(isFavorite: isFavorite)
    }
    if let product {
      return product.uiConfig(isFavorite: isFavorite)
    }
    return Product.uiConfigDefault
  }

  var body: some View {
    Group {
      if case .error(let errorDescription) = viewState, product == nil {
        DSErrorView(
          description: errorDescription,
          onRetry: { Task { await loadProductDetailed() } }
        )
      } else if viewState.isLoading && product == nil {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        let detailed = loadedDetailed
        ProductDetailedContentView(
          config: config,
          description: detailed?.description ?? (viewState.errorMessage != nil ? "Не удалось загрузить описание" : nil),
          reviews: detailed?.reviews ?? [],
          quantity: cartStore.quantity(for: id),
          onIncrement: { Task { await cartStore.increment(id: id) } },
          onDecrement: { Task { await cartStore.decrement(id: id) } },
          onFavoriteTap: { Task { await favoritesStore.toggle(id: id, fallback: fallbackFavorite) } },
          onOpenCart: onOpenCart,
          onReviews: { isReviews.toggle() },
          onError: onError
        )
        .sheet(isPresented: $isReviews) {
          if let detailed {
            ReviewsView(
              reviews: detailed.reviews,
              rating: detailed.rating,
              productId: id,
              config: config,
              description: detailed.description,
              catalogService: catalogService,
              onReviewCreated: { Task { await loadProductDetailed() } }
            )
          }
        }
      }
    }
    .task {
      await loadProductDetailed()
    }
  }

  private func loadProductDetailed() async {
    viewState = .loading
    do {
      let productDetailed = try await catalogService.fetchProduct(id: id)
      viewState = .loaded(productDetailed)
    } catch {
      Logger.catalog.error("Error loading detailed product info for item with id=\(id): \(error.localizedDescription)")
      viewState = .error("Не удалось загрузить подробную информацию о товаре")
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
