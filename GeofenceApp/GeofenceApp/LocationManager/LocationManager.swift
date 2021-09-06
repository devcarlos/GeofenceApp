//
//  LocationManager.swift
//  GeofenceApp
//
//  Created by Admin on 6/9/21.
//

import Foundation
import CoreLocation
import MapKit

protocol LocationManagerDelegate: AnyObject {
    func onEnterGeofence()
    func onExitGeofence()
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    let manager = CLLocationManager()

    var completion: ((CLLocation) -> Void)?

    var mapView: MKMapView?

    weak var delegate: LocationManagerDelegate?

    func setup(mapView: MKMapView) {
        self.mapView = mapView
    }

    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {

        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }

    public func resolveLocationName(with location: CLLocation, completion: @escaping ((String?) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            var name = ""
            if let locality = place.locality {
                name += locality
            }

            if let adminRegion = place.administrativeArea {
                name += ", \(adminRegion)"
            }

            completion(name)
        }
    }
    func setupGeofence() {
        guard let mapView = self.mapView else {
            return
        }

        let geofenceRegionCenter = CLLocationCoordinate2DMake(latitude, longitude)
        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 400, identifier: "OlivetChurch")
        geofenceRegion.notifyOnExit = true
        geofenceRegion.notifyOnEntry = true

        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let mapRegion = MKCoordinateRegion(center: geofenceRegionCenter, span: span)
        mapView.setRegion(mapRegion, animated: true)

        let regionCircle = MKCircle(center: geofenceRegionCenter, radius: 400)
        mapView.addOverlay(regionCircle)
        mapView.showsUserLocation = true;

        manager.startMonitoring(for: geofenceRegion)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter Geofence: \(region.identifier)")
        delegate?.onEnterGeofence()

    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit Geofence: \(region.identifier)")
        delegate?.onExitGeofence()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedAlways) {
            self.setupGeofence()
        }
    }

}
