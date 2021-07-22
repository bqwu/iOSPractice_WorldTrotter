//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Baoqiang Wu on 7/15/21.
//

/*
You have to set what the location of the simulator actually is:
   (1) search for “Edit Scheme” in the help menu
   (2) Options -> Core Location -> Default Location
*/

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
        
    var mapView: MKMapView!
    
    override func loadView() {
        // create a map view
        mapView = MKMapView()
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // comment the line below if automatical locating is desired
//        mapView.showsUserLocation = true

        view = mapView
        
        segmentedControlCreation()
        
        userLocationButtonCreation()
    }
    
    func segmentedControlCreation() {
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
//        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        
        
//        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
//        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        let margins = view.layoutMarginsGuide
        
//        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: margins.topAnchor)
        
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func userLocationButtonCreation() {
        let button: UIButton = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.frame = CGRect(x: 30, y: 40, width: 30, height: 30)

        button.setTitle("FindMe", for: .normal)

        button.backgroundColor = UIColor.white.withAlphaComponent(0.5)

        button.addTarget(self, action: #selector(showUserLocation(sender:)), for: .touchUpInside)

        view.addSubview(button)
        
        let margins = view.layoutMarginsGuide

        let bottomConstraint = button.bottomAnchor.constraint(equalTo: margins.bottomAnchor)

        let leadingConstraint = button.leadingAnchor.constraint(equalTo: margins.leadingAnchor)

        bottomConstraint.isActive = true
        leadingConstraint.isActive = true
        
    }
    
    @objc func showUserLocation(sender: UIButton!) {
        print("Start locating the user...")
        
        // This should be set here to avoid automatically locating
        mapView.showsUserLocation = true
        
        self.mapView(mapView, didUpdate: mapView.userLocation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("MapViewController loaded its view.")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)

        mapView.setRegion(region, animated: true)
    }

}
