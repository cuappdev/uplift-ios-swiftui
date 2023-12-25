//
//  LocationManager.swift
//  Uplift
//
//  Created by Vin Bui on 12/25/23.
//

import CoreLocation

/// Manage a user's location.
class LocationManager: NSObject, ObservableObject {

    // MARK: - Properties

    @Published var userLocation: CLLocation?

    private let manager = CLLocationManager()
    static let shared = LocationManager()

    // MARK: - Functions

    override private init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
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

}

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
#if DEBUG
        switch manager.authorizationStatus {
        case .notDetermined:
            print("DEBUG: Location not determined")
        case .restricted:
            print("DEBUG: Location restricted")
        case .denied:
            print("DEBUG: Location denied")
        case .authorizedAlways:
            print("DEBUG: Location authorized always")
        case .authorizedWhenInUse:
            print("DEBUG: Location authorized when in use")
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
#if DEBUG
        print("Error requesting location: \(error)")
#endif
    }

}
