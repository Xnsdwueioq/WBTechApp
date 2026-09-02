//
//  AddressEditorView.swift
//  WBTech
//
//  Created by Eyhciurmrn Zmpodackrl on 18.08.2026.
//

import SwiftUI
import MapKit
import CoreLocation
import UISystem
import OSLog

struct AddressEditorView: View {

  private enum Configuration {
    static let initialCoordinates = AddressCoordinates(
      longitude: 37.62381,
      latitude: 55.73662
    )
    static let initialAddressLine = "г. Москва, ул. Большая Ордынка, д. 40"
    static let initialRegion = region(for: initialCoordinates)
    static let lookupDelay = Duration.milliseconds(350)
    static let coordinateTolerance = 0.00001
    static let minimumMapDelta: CLLocationDegrees = 0.0005
    static let maximumMapDelta: CLLocationDegrees = 180

    static func region(
      for coordinates: AddressCoordinates
    ) -> MKCoordinateRegion {
      MKCoordinateRegion(
        center: .init(
          latitude: coordinates.latitude,
          longitude: coordinates.longitude
        ),
        span: .init(latitudeDelta: 0.005, longitudeDelta: 0.005)
      )
    }
  }

  private enum PresentedSheet: Hashable, Identifiable {
    case details
    case search

    var id: Self { self }
  }

  @Environment(\.dismiss) private var dismiss
  @Environment(\.locale) private var locale
  @Namespace private var mapScope

  private let addressSearchService: AddressSearchServiceProtocol
  private let onSave: (AddressDraft) async throws -> Void

  @State private var locationManager = CLLocationManager()
  @State private var draft = AddressDraft(
    coordinates: Configuration.initialCoordinates,
    addressLine: Configuration.initialAddressLine
  )
  @State private var position = MapCameraPosition.userLocation(
    fallback: .region(Configuration.initialRegion)
  )
  @State private var visibleRegion = Configuration.initialRegion
  @State private var coordinatesPendingLookup: AddressCoordinates?
  @State private var preservedAddressCoordinates: AddressCoordinates?
  @State private var presentedSheet: PresentedSheet?
  @State private var isSaving = false
  @State private var saveError: String?

  init(
    addressSearchService: AddressSearchServiceProtocol,
    onSave: @escaping (AddressDraft) async throws -> Void
  ) {
    self.addressSearchService = addressSearchService
    self.onSave = onSave
  }
  
  var body: some View {
    ZStack {
      Map(position: $position, scope: mapScope) {
        UserAnnotation()
      }
      .onMapCameraChange(frequency: .continuous) { context in
        visibleRegion = context.region

        let coordinates = Self.coordinates(from: context.region.center)
        if let preservedCoordinates = preservedAddressCoordinates,
           Self.areApproximatelyEqual(coordinates, preservedCoordinates) {
          preservedAddressCoordinates = nil
          coordinatesPendingLookup = nil
        } else {
          coordinatesPendingLookup = coordinates
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
    .task {
      requestLocationAuthorizationIfNeeded()
    }
    .task(id: coordinatesPendingLookup) {
      guard let coordinatesPendingLookup else { return }
      try? await Task.sleep(for: Configuration.lookupDelay)
      guard !Task.isCancelled else { return }
      await updateDraft(at: coordinatesPendingLookup)
    }
    .safeAreaInset(edge: .bottom, spacing: 0) {
      addressInfo
    }
    .sheet(item: $presentedSheet) { sheet in
      switch sheet {
      case .details:
        AddressDetailsForm(
          draft: $draft,
          isSaveEnabled: draft.isValid,
          isSaving: isSaving,
          onSave: saveDraft
        )
        .alert("Не удалось сохранить адрес", isPresented: saveErrorBinding) {
          Button("OK", role: .cancel) { }
        } message: {
          Text(saveError ?? "Неизвестная ошибка")
        }
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
        .font(
          .system(size: 20)
          .weight(.medium)
        )
      
      HStack {
        Button(action: { presentedSheet = .search }) {
          Text("Ввести другой")
        }
        .buttonStyle(DSButtonStyle(size: .large, style: .outline))
        
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
  
  private func updateDraft(at coordinates: AddressCoordinates) async {
    do {
      let addressLine = try await addressSearchService.addressLine(
        at: coordinates,
        locale: locale
      )
      guard !Task.isCancelled,
            coordinatesPendingLookup == coordinates else { return }

      Logger.map.debug(
        "Address updated from \(draft.coordinates.latitude), \(draft.coordinates.longitude) to \(coordinates.latitude), \(coordinates.longitude)"
      )
      draft.coordinates = coordinates
      draft.addressLine = addressLine
    } catch {
      Logger.map.error("Reverse geocoding failed: \(error.localizedDescription)")
    }
  }

  private func requestLocationAuthorizationIfNeeded() {
    guard locationManager.authorizationStatus == .notDetermined else { return }

    locationManager.requestWhenInUseAuthorization()
  }

  private func saveDraft() {
    guard !isSaving else { return }
    isSaving = true

    Task {
      defer { isSaving = false }
      do {
        try await onSave(draft)
        presentedSheet = nil
        dismiss()
      } catch {
        saveError = error.localizedDescription
      }
    }
  }

  private var saveErrorBinding: Binding<Bool> {
    Binding(
      get: { saveError != nil },
      set: { if !$0 { saveError = nil } }
    )
  }

  private func selectAddress(_ selection: AddressSearchSelection) {
    coordinatesPendingLookup = nil
    preservedAddressCoordinates = selection.coordinates
    draft.coordinates = selection.coordinates
    draft.addressLine = selection.addressLine
    visibleRegion = Configuration.region(for: selection.coordinates)
    position = .region(visibleRegion)
    presentedSheet = nil
  }

  private func zoomMap(by factor: CLLocationDegrees) {
    visibleRegion.span = MKCoordinateSpan(
      latitudeDelta: clampedMapDelta(visibleRegion.span.latitudeDelta * factor),
      longitudeDelta: clampedMapDelta(visibleRegion.span.longitudeDelta * factor)
    )
    position = .region(visibleRegion)
  }

  private func clampedMapDelta(
    _ delta: CLLocationDegrees
  ) -> CLLocationDegrees {
    min(
      max(delta, Configuration.minimumMapDelta),
      Configuration.maximumMapDelta
    )
  }

  private static func coordinates(
    from coordinate: CLLocationCoordinate2D
  ) -> AddressCoordinates {
    AddressCoordinates(
      longitude: coordinate.longitude,
      latitude: coordinate.latitude
    )
  }

  private static func areApproximatelyEqual(
    _ lhs: AddressCoordinates,
    _ rhs: AddressCoordinates
  ) -> Bool {
    abs(lhs.latitude - rhs.latitude) < Configuration.coordinateTolerance
      && abs(lhs.longitude - rhs.longitude) < Configuration.coordinateTolerance
  }

}

#Preview {
  AddressEditorView(
    addressSearchService: MockAddressSearchService(),
    onSave: { _ in }
  )
    .environment(\.locale, Locale(identifier: "ru_RU"))
}
