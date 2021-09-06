//
//  ViewController.swift
//  GeofenceApp
//
//  Created by Admin on 6/9/21.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HOME"
        view.addSubview(map)

        LocationManager.shared.getUserLocation(completion:  { [weak self ] location in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.addMapPin(with: location)
            }
        })
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }

    func addMapPin(with location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        map.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
        map.addAnnotation(pin)

        LocationManager.shared.resolveLocationName(with: location, completion: { [weak self] locationName in
            self?.title = locationName

        })
    }

}

