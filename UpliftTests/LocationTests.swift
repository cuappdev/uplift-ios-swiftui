//
//  LocationTests.swift
//  Uplift
//
//  Created by jiwon jeong on 2/18/26.
//  Copyright © 2026 Cornell AppDev. All rights reserved.
//

import Testing
import CoreLocation
@testable import Uplift

@MainActor
struct LocationTests {
    
    /**
     [Noyes] lat: 42.44660528140398, lon: -76.48803891048553
     [Teagle] lat: 42.4459926380709, lon: -76.47915389837931
     [Helen Newman] lat: 42.453188923853595, lon: -76.47730907608567
     [Toni Morrison] lat: 42.45582093240726, lon: -76.47883902202813
     */

    // MARK: - Helpers

    func makeViewModel(userLatitude: Double, userLongitude: Double) -> WorkoutCheckInView.ViewModel {
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: userLatitude, longtitude: userLongitude)
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = DummyData.allGyms
        return vm
    }

    // MARK: - Proximity Tests

    @Test("User at Noyes coords triggers check-in for Noyes")
    func userAtNoyes() {
        let vm = makeViewModel(
            userLatitude: 42.44660528140398,
            userLongitude: -76.48803891048553
        )
        vm.findNearestGym()
        #expect(vm.currentNearestGym == "Noyes")
        #expect(vm.nearestGymText.contains("Noyes"))
    }

    @Test("User far from all gyms does not trigger check-in")
    func userFarFromAllGyms() {
        // NYC coords — nowhere near Cornell
        let vm = makeViewModel(userLatitude: 40.7128, userLongitude: -74.0060)
        vm.findNearestGym()
        #expect(vm.currentNearestGym == nil)
        #expect(vm.nearestGymText == "Finding gyms nearby...")
    }

    @Test("Closed gym within threshold does not trigger check-in")
    func closedGymNearby() {
        let closedNoyes = Gym(
            id: "noyes-closed",
            name: "Noyes",
            latitude: 42.44660528140398,
            longitude: -76.48803891048553,
            status: .closed(openTime: .distantFuture)
        )
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: 42.44660528140398, longtitude: -76.48803891048553)
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = [closedNoyes]
        vm.findNearestGym()
        #expect(vm.currentNearestGym == nil)
        #expect(vm.nearestGymText == "Finding gyms nearby...")
    }

    @Test("Nearest gym is chosen when multiple are within threshold")
    func nearestGymChosen() {
        // Place two gyms very close, user is on top of one
        let gymA = Gym(id: "a", name: "GymA", latitude: 42.44660528140398, longitude: -76.48803891048553, status: .open(closeTime: .distantFuture))
        let gymB = Gym(id: "b", name: "GymB", latitude: 42.44661, longitude: -76.48804, status: .open(closeTime: .distantFuture))
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: 42.44660528140398, longtitude: -76.48803891048553)
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = [gymB, gymA] // intentionally out of order
        vm.findNearestGym()
        #expect(vm.currentNearestGym == "GymA")
    }

    // MARK: - Cooldown Tests

    @Test("Daily cooldown hides check-in banner")
    func dailyCooldownHidesView() {
        var visibilityResult: Bool?
        let vm = makeViewModel(
            userLatitude: 42.44660528140398,
            userLongitude: -76.48803891048553
        )
        vm.visibility = { visibilityResult = $0 }
        vm.isDailyCooldownActive = true
        vm.findNearestGym()
        #expect(visibilityResult == false)
    }

    @Test("2-hour cooldown hides check-in banner")
    func cooldownHidesView() {
        var visibilityResult: Bool?
        let vm = makeViewModel(
            userLatitude: 42.44660528140398,
            userLongitude: -76.48803891048553
        )
        vm.visibility = { visibilityResult = $0 }
        vm.isCooldownActive = true
        vm.findNearestGym()
        #expect(visibilityResult == false)
    }

    // MARK: - No Location Tests

    @Test("No user location shows finding gyms text")
    func noUserLocation() {
        let mockLocation = MockLocationManager() // no location set
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = DummyData.allGyms
        vm.findNearestGym()
        #expect(vm.nearestGymText == "Finding gyms nearby...")
    }

    @Test("Empty gyms list shows finding gyms text")
    func emptyGymsList() {
        let vm = makeViewModel(
            userLatitude: 42.44660528140398,
            userLongitude: -76.48803891048553
        )
        vm.gyms = []
        vm.findNearestGym()
        #expect(vm.nearestGymText == "Finding gyms nearby...")
    }
}
