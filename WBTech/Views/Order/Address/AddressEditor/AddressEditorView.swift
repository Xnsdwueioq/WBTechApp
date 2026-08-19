//
//  AddressEditorView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 18.08.2026.
//

import SwiftUI
import MapKit
import UISystem
import OSLog

enum AddressEditorMode: Identifiable {

  enum ID: Hashable {
    case create
    case edit(String)
  }

  case create
  case edit(Address)

  var id: ID {
    switch self {
    case .create:
      .create
    case .edit(let address):
      .edit(address.id)
    }
  }
}

struct AddressEditorView: View {

  private enum PresentedSheet: Hashable, Identifiable {
    case details
    case search

    var id: Self { self }
  }

  @Environment(\.dismiss) private var dismiss
  @Environment(\.locale) private var locale
  @Namespace private var mapScope

  private let addressSearchService: AddressSearchServiceProtocol
  private let onSave: (AddressDraft) -> Void

  @State private var draft: AddressDraft
  @State private var position: MapCameraPosition
  @State private var visibleRegion: MKCoordinateRegion
  @State private var latestAddressRequestID = UUID()
  @State private var presentedSheet: PresentedSheet?

  init(
    mode: AddressEditorMode = .create,
    addressSearchService: AddressSearchServiceProtocol,
    onSave: @escaping (AddressDraft) -> Void
  ) {
    let draft: AddressDraft
    let position: MapCameraPosition

    switch mode {
    case .create:
      let coordinates = AddressCoordinates(
        longitude: 37.62381,
        latitude: 55.73662
      )
      draft = AddressDraft(
        coordinates: coordinates,
        addressLine: "г. Москва, ул. Большая Ордынка, д. 40"
      )
      position = .userLocation(
        fallback: .region(Self.region(for: coordinates))
      )

    case .edit(let address):
      draft = AddressDraft(address: address)
      position = .region(Self.region(for: address.coordinates))
    }

    self.addressSearchService = addressSearchService
    self.onSave = onSave
    self.draft = draft
    self.position = position
    self.visibleRegion = Self.region(for: draft.coordinates)
  }
  
  var body: some View {
    ZStack {
      Map(position: $position, scope: mapScope) {
        UserAnnotation()
      }
      .onMapCameraChange(frequency: .onEnd) { context in
        let coordinate = context.region.center
        let requestID = UUID()

        visibleRegion = context.region
        
        latestAddressRequestID = requestID
        
        Task {
          await updateDraft(with: coordinate, requestID: requestID)
        }
      }
      marker
    }
    .overlay(alignment: .topTrailing) {
      VStack(spacing: 8) {
        DSMapDismissButton(action: { dismiss() })
        mapZoomButton(systemName: "plus", accessibilityLabel: "Приблизить карту") {
          zoomMap(by: 0.5)
        }
        mapZoomButton(systemName: "minus", accessibilityLabel: "Отдалить карту") {
          zoomMap(by: 2)
        }
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
    .sheet(item: $presentedSheet) { sheet in
      switch sheet {
      case .details:
        AddressDetailsForm(
          draft: $draft,
          isSaveEnabled: draft.isValid,
          onSave: saveDraft
        )
      case .search:
        AddressSearchForm(
          initialCoordinates: draft.coordinates,
          addressSearchService: addressSearchService,
          onSelect: selectAddress
        )
      }
    }
  }

  private var addressInfo: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text(draft.addressLine)
        .lineLimit(1)
        .truncationMode(.middle)
        .accessibilityIdentifier("addressEditor.addressLine")
        .font(
          .system(size: 20)
          .weight(.medium)
        )
      
      HStack {
        Button(action: { presentedSheet = .search }) {
          Text("Ввести другой")
        }
        .buttonStyle(DSButtonStyle(size: .large, style: .outline))
        .accessibilityIdentifier("addressEditor.manualEntry")
        
        Button(action: { presentedSheet = .details }) {
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
      .fill(Color(.systemBackground))
      .ignoresSafeArea(edges: .bottom)
    }
  }
  
  private var marker: some View {
    Capsule()
      .frame(width: 25, height: 25)
      .foregroundStyle(LinearGradient.dsViolet)
      .allowsHitTesting(false)
  }

  private func mapZoomButton(
    systemName: String,
    accessibilityLabel: String,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: systemName)
        .font(.system(size: 17, weight: .medium))
        .foregroundStyle(Color.dsMapControlForeground)
        .frame(width: 40, height: 40)
    }
    .buttonStyle(DSMapControlButtonStyle())
    .accessibilityLabel(accessibilityLabel)
  }
  
  private func updateDraft(
    with coordinate: CLLocationCoordinate2D,
    requestID: UUID
  ) async {
    guard let newAddressLine = await getAddressLine(for: coordinate),
          requestID == latestAddressRequestID else { return }
    
    let newCoordinates = AddressCoordinates(
      longitude: coordinate.longitude,
      latitude: coordinate.latitude
    )
    Logger.map.debug("updated from \(draft.coordinates.latitude), \(draft.coordinates.longitude) to \(coordinate.latitude), \(coordinate.longitude)")
    draft.coordinates = newCoordinates
    draft.addressLine = newAddressLine
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

  private func saveDraft() {
    presentedSheet = nil
    onSave(draft)
  }

  private func selectAddress(_ selection: AddressSearchSelection) {
    latestAddressRequestID = UUID()
    draft.coordinates = selection.coordinates
    draft.addressLine = selection.addressLine
    visibleRegion = Self.region(for: selection.coordinates)
    position = .region(visibleRegion)
    presentedSheet = nil
  }

  private func zoomMap(by factor: CLLocationDegrees) {
    let minimumDelta: CLLocationDegrees = 0.0005
    let maximumDelta: CLLocationDegrees = 180

    visibleRegion.span = MKCoordinateSpan(
      latitudeDelta: min(
        max(visibleRegion.span.latitudeDelta * factor, minimumDelta),
        maximumDelta
      ),
      longitudeDelta: min(
        max(visibleRegion.span.longitudeDelta * factor, minimumDelta),
        maximumDelta
      )
    )
    position = .region(visibleRegion)
  }

  private static func region(
    for coordinates: AddressCoordinates
  ) -> MKCoordinateRegion {
    MKCoordinateRegion(
      center: .init(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude
      ),
      span: .init(
        latitudeDelta: 0.005,
        longitudeDelta: 0.005
      )
    )
  }

}

#Preview {
  AddressEditorView(
    mode: .create,
    addressSearchService: MockAddressSearchService(),
    onSave: { _ in }
  )
    .environment(\.locale, Locale(identifier: "ru_RU"))
}
