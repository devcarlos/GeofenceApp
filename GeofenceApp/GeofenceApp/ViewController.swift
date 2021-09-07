//
//  ViewController.swift
//  GeofenceApp
//
//  Created by Admin on 6/9/21.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    private let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HOME"
        mapView.delegate = self
        view.addSubview(mapView)

        LocationManager.shared.setup(mapView: mapView)
        LocationManager.shared.delegate = self

        LocationManager.shared.getUserLocation(completion:  { [weak self ] location in
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

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        print("Arrive to mapView delegate")
        let overlayRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
        overlayRenderer.lineWidth = 4.0
        overlayRenderer.strokeColor = UIColor.red
        overlayRenderer.fillColor = UIColor.blue
        return overlayRenderer
    }
}

extension ViewController: LocationManagerDelegate {
    func onEnterGeofence() {
//        mapView.userLocation
    }

    func onExitGeofence() {
//        mapView.userLocation
    }
}
