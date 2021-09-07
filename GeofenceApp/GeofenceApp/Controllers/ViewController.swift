//
//  ViewController.swift
//  GeofenceApp
//
//  Created by Admin on 6/9/21.
//

import MapKit
import UIKit

class ViewController: BaseViewController {

    // MARK: - Properties
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    var userName: String = "User Test"

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HOME"
        mapView.delegate = self
        view.addSubview(mapView)

        LocationManager.shared.setup(mapView: mapView)
        LocationManager.shared.delegate = self

        LocationManager.shared.getUserLocation(completion: { location in
            DispatchQueue.main.async {
                LocationManager.shared.setupGeofence()
            }
        })
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }

    func addMapPin(with location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
        mapView.addAnnotation(pin)

        LocationManager.shared.resolveLocationName(with: location, completion: { [weak self] locationName in
            self?.title = locationName
        })
    }
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlayRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
        overlayRenderer.lineWidth = 4.0
        overlayRenderer.strokeColor = UIColor.red
        overlayRenderer.fillColor = UIColor.blue
        return overlayRenderer
    }
}

// MARK: - LocationManagerDelegate
extension ViewController: LocationManagerDelegate {
    func onEnterGeofence() {
        sendUserGeofence(hasEnter: true)
    }

    func onExitGeofence() {
        sendUserGeofence(hasEnter: false)
    }
}

private extension ViewController {
    func sendUserGeofence(hasEnter: Bool) {
        let userLocation = mapView.userLocation

        CoreDataManager.shared.userHasEnter(name: userName,
                                            latitude: userLocation.coordinate.latitude,
                                            longitude: userLocation.coordinate.longitude,
                                            hasEnter: hasEnter)

        let title = hasEnter ? "User Enter" : "User Exit"
        let message = "The user has \(hasEnter ? "enter" : "exit") the Geofence"

        showAlertWithAutoDismiss(title: title, message: message, time: 1)
    }
}
