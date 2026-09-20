//
//  LocationManager.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//  Copyright © 2023 Cornell AppDev. All rights reserved.
//

import Combine
import CoreLocation
import OSLog

protocol LocationManaging {

    var userLocation: CLLocation? { get }

    var userLocationPublisher: AnyPublisher<CLLocation?, Never> { get }

    var authorizationStatus: CLAuthorizationStatus { get }

    var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> { get }

    var regionEnteredPublisher: AnyPublisher<String, Never> { get }

    var regionExitedPublisher: AnyPublisher<String, Never> { get }

    func requestLocation()

    func distanceToCoordinates(latitude: Double, longitude: Double) -> String

    func distanceToCoordinatesTwo(latitude: Double, longitude: Double) -> String

    func requestAlwaysAuthorization()

    func startMonitoring(regions: [CLCircularRegion])

    func stopMonitoringAllRegions()
}

/// Manage a user's location.
class LocationManager: NSObject, ObservableObject {

    // MARK: - Properties

    static let shared = LocationManager()

    @Published var userLocation: CLLocation?

    @Published private(set) var authorizationStatus: CLAuthorizationStatus

    private let regionEnteredSubject = PassthroughSubject<String, Never>()

    private let regionExitedSubject = PassthroughSubject<String, Never>()

    private let manager = CLLocationManager()

    // MARK: - Functions

    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }

    func requestAlwaysAuthorization() {
        manager.requestAlwaysAuthorization()
    }

    func stopMonitoringAllRegions() {
        for region in manager.monitoredRegions {
            manager.stopMonitoring(for: region)
        }
    }

    func startMonitoring(regions: [CLCircularRegion]) {
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            Logger.services.error("Region monitoring is not available on this device")
            return
        }

        stopMonitoringAllRegions()

        for region in regions {
            manager.startMonitoring(for: region)
        }
    }

    /**
     Determine the distance, in miles, from the user to the given location.

     - Parameters:
        - latitude: The latitude coordinate of the destination.
        - longitude: The longitude coordinate of the destination.

     - Returns: The distance to the location in miles rounded to one decimal place.
     */
    func distanceToCoordinates(latitude: Double, longitude: Double) -> String {
        guard let locationA = userLocation else { return "0.0" }
        let locationB = CLLocation(latitude: latitude, longitude: longitude)

        let meters = locationA.distance(from: locationB)
        let metersMeasurement = Measurement(value: meters, unit: UnitLength.meters)
        let convertedValue = metersMeasurement.converted(to: .miles).value
        return String(format: "%.1f", (convertedValue * 10).rounded() / 10)
    }

    func distanceToCoordinatesTwo(latitude: Double, longitude: Double) -> String {
        guard let locationA = userLocation else { return "0.0" }
        let locationB = CLLocation(latitude: latitude, longitude: longitude)

        let meters = locationA.distance(from: locationB)
        let metersMeasurement = Measurement(value: meters, unit: UnitLength.meters)
        let convertedValue = metersMeasurement.converted(to: .miles).value
        return String(format: "%.2f", (convertedValue * 100).rounded() / 100)
    }

}

extension LocationManager: LocationManaging {
    var userLocationPublisher: AnyPublisher<CLLocation?, Never> {
        $userLocation.eraseToAnyPublisher()
    }

    var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> {
        $authorizationStatus.eraseToAnyPublisher()
    }

    var regionEnteredPublisher: AnyPublisher<String, Never> {
        regionEnteredSubject.eraseToAnyPublisher()
    }

    var regionExitedPublisher: AnyPublisher<String, Never> {
        regionExitedSubject.eraseToAnyPublisher()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
#if DEBUG
        switch manager.authorizationStatus {
        case .notDetermined:
            Logger.services.info("Location not determined")
        case .restricted:
            Logger.services.info("Location restricted")
        case .denied:
            Logger.services.info("Location denied")
        case .authorizedAlways:
            Logger.services.info("Location authorized always")
        case .authorizedWhenInUse:
            Logger.services.info("Location authorized when in use")
        @unknown default:
            break
        }
#endif
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.services.error("Error requesting location: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        Logger.services.info("Entered region \(region.identifier)")
        regionEnteredSubject.send(region.identifier)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        Logger.services.info("Exited region \(region.identifier)")
        regionExitedSubject.send(region.identifier)
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        Logger.services.error("Region monitoring failed for \(region?.identifier ?? "unknown"): \(error)")
    }
}

class MockLocationManager: NSObject, ObservableObject {

    @Published var userLocation: CLLocation?

    @Published var authorizationStatus: CLAuthorizationStatus = .authorizedAlways

    private let regionEnteredSubject = PassthroughSubject<String, Never>()

    private let regionExitedSubject = PassthroughSubject<String, Never>()

    private(set) var monitoredRegions: [CLCircularRegion] = []

    func requestLocation() {
        // Do Nothing
    }

    func setLocation(latitude: Double, longtitude: Double) {
        self.userLocation = CLLocation(latitude: latitude, longitude: longtitude)
    }

    func distanceToCoordinates(latitude: Double, longitude: Double) -> String {
        guard let locationA = userLocation else { return "0.0" }
        let locationB = CLLocation(latitude: latitude, longitude: longitude)

        let meters = locationA.distance(from: locationB)
        let metersMeasurement = Measurement(value: meters, unit: UnitLength.meters)
        let convertedValue = metersMeasurement.converted(to: .miles).value
        return String(format: "%.1f", (convertedValue * 10).rounded() / 10)
    }

    func distanceToCoordinatesTwo(latitude: Double, longitude: Double) -> String {
        guard let locationA = userLocation else { return "0.0" }
        let locationB = CLLocation(latitude: latitude, longitude: longitude)

        let meters = locationA.distance(from: locationB)
        let metersMeasurement = Measurement(value: meters, unit: UnitLength.meters)
        let convertedValue = metersMeasurement.converted(to: .miles).value
        return String(format: "%.2f", (convertedValue * 100).rounded() / 100)
    }

}

extension MockLocationManager: LocationManaging {
    var userLocationPublisher: AnyPublisher<CLLocation?, Never> {
        $userLocation.eraseToAnyPublisher()
    }

    var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> {
        $authorizationStatus.eraseToAnyPublisher()
    }

    var regionEnteredPublisher: AnyPublisher<String, Never> {
        regionEnteredSubject.eraseToAnyPublisher()
    }

    var regionExitedPublisher: AnyPublisher<String, Never> {
        regionExitedSubject.eraseToAnyPublisher()
    }

    func requestAlwaysAuthorization() {
        // Do Nothing
    }

    func startMonitoring(regions: [CLCircularRegion]) {
        monitoredRegions = regions
    }

    func stopMonitoringAllRegions() {
        monitoredRegions = []
    }

    func simulateEnter(regionId: String) {
        regionEnteredSubject.send(regionId)
    }

    func simulateExit(regionId: String) {
        regionExitedSubject.send(regionId)
    }
}
