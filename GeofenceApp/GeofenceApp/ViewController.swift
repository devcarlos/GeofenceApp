//
//  ViewController.swift
//  GeofenceApp
//
//  Created by Admin on 6/9/21.
//

import MapKit
import UIKit

class ViewController: UIViewController {
    private let map: MKMapView = {
        let map = MKMapView()
        return map
    }()

    private let manager = CoreDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(map)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
}
