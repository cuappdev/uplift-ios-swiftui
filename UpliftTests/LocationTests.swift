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

     Threshold: 0.05 miles ≈ 264 feet / 80 meters
     */
    @Test("User at exact Noyes coords triggers check-in for Noyes")
    func userAtExactNoyes() {
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: 42.44660528140398, longtitude: -76.48803891048553)
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = DummyData.allGyms
        vm.findNearestGym()
        #expect(vm.currentNearestGym == "Noyes")
        #expect(vm.nearestGymText.contains("Noyes"))
    }

    @Test("User at exact Teagle coords triggers check-in for Teagle")
    func userAtExactTeagle() {
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: 42.4459926380709, longtitude: -76.47915389837931)
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = DummyData.allGyms
        vm.findNearestGym()
        #expect(vm.currentNearestGym == "Teagle")
        #expect(vm.nearestGymText.contains("Teagle"))
    }

    @Test("User at exact Helen Newman coords triggers check-in for Helen Newman")
    func userAtExactHelenNewman() {
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: 42.453188923853595, longtitude: -76.47730907608567)
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = DummyData.allGyms
        vm.findNearestGym()
        #expect(vm.currentNearestGym == "Helen Newman")
        #expect(vm.nearestGymText.contains("Helen Newman"))
    }

    @Test("User at exact Toni Morrison coords triggers check-in for Toni Morrison")
    func userAtExactToniMorrison() {
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: 42.45582093240726, longtitude: -76.47883902202813)
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = DummyData.allGyms
        vm.findNearestGym()
        #expect(vm.currentNearestGym == "Toni Morrison")
        #expect(vm.nearestGymText.contains("Toni Morrison"))
    }

    @Test("User just inside threshold (~0.04 mi) of Noyes triggers check-in")
    func userJustInsideNoyesThreshold() {
        // ~0.04 miles north of Noyes — within 0.05 mile threshold
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: 42.44700, longtitude: -76.48803891048553)
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = DummyData.allGyms
        vm.findNearestGym()
        #expect(vm.currentNearestGym == "Noyes")
    }

    @Test("User just outside threshold (~0.06 mi) of Noyes does not trigger check-in")
    func userJustOutsideNoyesThreshold() {
        // ~0.06 miles north of Noyes — outside 0.05 mile threshold
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: 42.44750, longtitude: -76.48803891048553)
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = DummyData.allGyms
        vm.findNearestGym()
        #expect(vm.currentNearestGym == nil)
        #expect(vm.nearestGymText == "Finding gyms nearby...")
    }

    @Test("User equidistant between two gyms checks in to nearest open one")
    func userBetweenTwoGyms() {
        // Midpoint between Teagle and Helen Newman longitude-wise, same latitude as Teagle
        let midLon = (-76.47915389837931 + -76.47730907608567) / 2
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: 42.4459926380709, longtitude: midLon)
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = DummyData.allGyms
        vm.findNearestGym()
        // Teagle is at the same latitude so should be fractionally closer
        #expect(vm.currentNearestGym == "Teagle")
    }

    @Test("User far from all gyms does not trigger check-in")
    func userFarFromAllGyms() {
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: 40.7128, longtitude: -74.0060) // New York City
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = DummyData.allGyms
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

    @Test("Nearest gym is closed but second nearest is open — checks into open gym")
    func nearestClosedSecondOpen() {
        let closedNoyes = Gym(
            id: "noyes-closed",
            name: "Noyes",
            latitude: 42.44660528140398,
            longitude: -76.48803891048553,
            status: .closed(openTime: .distantFuture)
        )
        let openNearNoyes = Gym(
            id: "fake-open",
            name: "Fake Open Gym",
            latitude: 42.44665,
            longitude: -76.48803891048553,
            status: .open(closeTime: .distantFuture)
        )
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: 42.44660528140398, longtitude: -76.48803891048553)
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = [closedNoyes, openNearNoyes]
        vm.findNearestGym()
        #expect(vm.currentNearestGym == "Fake Open Gym")
    }

    @Test("No location set returns finding gyms text")
    func noLocationSet() {
        let mockLocation = MockLocationManager()
        // Deliberately do not call setLocation
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = DummyData.allGyms
        vm.findNearestGym()
        #expect(vm.currentNearestGym == nil)
        #expect(vm.nearestGymText == "Finding gyms nearby...")
    }

    @Test("Empty gyms list returns finding gyms text")
    func emptyGymsList() {
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: 42.44660528140398, longtitude: -76.48803891048553)
        let vm = WorkoutCheckInView.ViewModel(locationManager: mockLocation)
        vm.gyms = []
        vm.findNearestGym()
        #expect(vm.currentNearestGym == nil)
        #expect(vm.nearestGymText == "Finding gyms nearby...")
    }

    @Test("Debug distance from near-Noyes point to Noyes")
    func debugDistances() {
        let mockLocation = MockLocationManager()
        mockLocation.setLocation(latitude: 42.4455, longtitude: -76.488)
        let dist = mockLocation.distanceToCoordinatesTwo(
            latitude: 42.44660528140398,
            longitude: -76.48803891048553
        )
        print("Distance to Noyes: \(dist) miles")
    }
}
