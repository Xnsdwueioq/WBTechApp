//

import Foundation

actor CartService: CartServiceProtocol {
  
  private typealias CartDTO = Operations.getCart.Output.Ok.Body.jsonPayload
  private typealias CartItemDTO = CartDTO.itemsPayloadPayload
  
  private let client: Client
  
  init(token: String) {
    self.client = APIClientFactory.make(token: token)
  }
  
  func fetchCart() async throws -> CartSummary {
    let response = try await client.getCart(.init())
    let payload = try response.ok.body.json
    return Self.cartSummary(from: payload)
  }
  
  func addToCart(id: String) async throws -> Int {
    let response = try await client.addCartItem(.init(query: .init(id: id)))
    let payload = try response.ok.body.json
    
    return payload.total
  }
  
  func removeFromCart(id: String) async throws -> Int {
    let response = try await client.removeCartItem(.init(path: .init(id: id)))
    let payload = try response.ok.body.json
    
    return payload.total ?? 0
  }
  
}

private extension CartService {
  
  private static func cartSummary(from dto: CartDTO) -> CartSummary {
    .init(
      deliveryTime: dto.deliveryTime,
      orderPrice: dto.orderPrice,
      deliveryPrice: dto.deliveryPrice,
      totalPrice: dto.totalPrice,
      totalItems: dto.totalItems,
      items: dto.items.map(cartLine(from:))
    )
  }
  
  private static func cartLine(from dto: CartItemDTO) -> CartLine {
    .init(
      id: dto.value1.id,
      image: dto.value1.image,
      name: dto.value1.name,
      weight: dto.value1.weight,
      price: dto.value1.price,
      quantity: dto.value1.quantity,
      available: dto.value2.available
    )
  }
    
}
