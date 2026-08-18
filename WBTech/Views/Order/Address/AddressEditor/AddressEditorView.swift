//
//  AddressEditorView.swift
//  WBTech
//
//  Created by sye7qjm3ac on 18.08.2026.
//

import SwiftUI
import MapKit
import UISystem
import OSLog

enum AddressEditorMode {
  case edit
  case create
}

struct AddressEditorView: View {
  var mode: AddressEditorMode = .create
  
  @Environment(\.dismiss) private var dismiss
  @Environment(\.locale) private var locale
  @Namespace private var mapScope
  
  @State private var address: Address
  @State private var position: MapCameraPosition
  @State private var latestAddressRequestID = UUID()
  
  
  init(mode: AddressEditorMode = .create) {
    let longitude = 37.62381
    let latitude = 55.73662
    // MARK: Address
    address = Address(
      id: "defaultAddress",
      coordinates: .init(
        longitude: longitude,
        latitude: latitude
      ),
      addressLine: "г. Москва, ул. Большая Ордынка, д. 40",
      floor: "4",
      entrance: "2",
      intercomCode: "241",
      comment: "Вход со стороны главной площадки"
    )
    
    // MARK: Position
    position = .userLocation(
      fallback: .region(
        MKCoordinateRegion(
          center: .init(
            latitude: latitude,
            longitude: longitude
          ),
          span: .init(
            latitudeDelta: 0.005,
            longitudeDelta: 0.005
          )
        )
      )
    )
  }
  
  var body: some View {
    ZStack {
      Map(position: $position, scope: mapScope) {
        UserAnnotation()
      }
      .onMapCameraChange(frequency: .onEnd) { context in
        let coordinate = context.region.center
        let requestID = UUID()
        
        latestAddressRequestID = requestID
        
        Task {
          await updateAddress(with: coordinate, requestID: requestID)
        }
      }
      marker
    }
    .overlay(alignment: .topTrailing) {
      VStack(spacing: 8) {
        DSMapDismissButton(action: { dismiss() })
        MapUserLocationButton(scope: mapScope)
          .frame(width: 40, height: 40)
          .modifier(DSMapControlBackgroundViewModifier())
      }
      .padding(12)
    }
    .mapScope(mapScope)
    .safeAreaInset(edge: .bottom, spacing: 0) {
      addressInfo
    }
  }
  
  private var addressInfo: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text(address.addressLine)
        .lineLimit(1)
        .truncationMode(.middle)
        .font(
          .system(size: 20)
          .weight(.medium)
        )
      
      HStack {
        Button(action: {}) {
          Text("Ввести другой")
        }
        .buttonStyle(DSButtonStyle(size: .large, style: .outline))
        
        Button(action: {}) {
          Text("Выбрать адрес")
        }
        .buttonStyle(DSButtonStyle(size: .large, style: .accent))
      }
      .frame(maxWidth: .infinity, alignment: .center)
      
    }
    .padding(.top, 12)
    .padding(.horizontal, 12)
    .padding(.bottom, 12)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background {
      UnevenRoundedRectangle(
        topLeadingRadius: 24,
        topTrailingRadius: 24,
        style: .continuous
      )
      .fill(Color.white)
      .ignoresSafeArea(edges: .bottom)
    }
  }
  
  private var marker: some View {
    Capsule()
      .frame(width: 25, height: 25)
      .foregroundStyle(LinearGradient.dsViolet)
      .allowsHitTesting(false)
  }
  
  private func updateAddress(
    with coordinate: CLLocationCoordinate2D,
    requestID: UUID
  ) async {
    guard let newAddressLine = await getAddressLine(for: coordinate),
          requestID == latestAddressRequestID else { return }
    
    let newAddress = Address(
      id: address.id,
      coordinates: .init(
        longitude: coordinate.longitude,
        latitude: coordinate.latitude
      ),
      addressLine: newAddressLine,
      floor: address.floor,
      entrance: address.entrance,
      intercomCode: address.intercomCode,
      comment: address.comment
    )
    Logger.map.debug("updated from \(address.coordinates.latitude), \(address.coordinates.longitude) to \(coordinate.latitude), \(coordinate.longitude)")
    address = newAddress
  }
  
  private func getAddressLine(for coordinate: CLLocationCoordinate2D) async -> String? {
    let location = CLLocation(
      latitude: coordinate.latitude,
      longitude: coordinate.longitude
    )
    
    guard let request = MKReverseGeocodingRequest(location: location) else {
      Logger.map.error("Unable to create reverse geocoding request")
      return nil
    }
    
    request.preferredLocale = locale
    
    do {
      let mapItems = try await request.mapItems
      return mapItems.first?.address?.shortAddress
    } catch {
      Logger.map.error("Reverse geocoding failed: \(error.localizedDescription)")
      return nil
    }
  }
}

#Preview {
  AddressEditorView(mode: .create)
    .environment(\.locale, Locale(identifier: "ru_RU"))
}
