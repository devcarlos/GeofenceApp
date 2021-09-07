//
//  GeofenceAppTests.swift
//  GeofenceAppTests
//
//  Created by Admin on 6/9/21.
//

import XCTest
import MapKit
@testable import GeofenceApp

class LocationManagerTests: XCTestCase {

    var sut: LocationManager?

    override func tearDown() {
        sut = nil
    }

    func testLocationManager() {
        sut = LocationManager()
        XCTAssertNotNil(sut)
    }

    func testLocationManagerMap() {
        sut = LocationManager()

        sut?.setup(mapView: MKMapView())
        XCTAssertNotNil(sut?.mapView)
    }

    func testLocationManagerGeofence() {
        sut = LocationManager()

        sut?.setup(mapView: MKMapView())
        sut?.setupGeofence()
        XCTAssertNotNil(sut?.geofenceRegion)

        sut?.stopGeofenceMonitoring()
        XCTAssertNil(sut?.geofenceRegion)
    }
}
