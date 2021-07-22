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
        mapView.showsUserLocation = true

        view = mapView
        
        segmentedControlCreation()
        
        userLocationButtonCreation()
        
        switchLocationButtonCreation()
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
        // mapView.showsUserLocation = true
        
        self.mapView(mapView, didUpdate: mapView.userLocation)
    }
    
    let lat1 = 29.6553895, lon1 =  91.1704736
    let lat2 = 40.0149856, lon2 = -105.270545
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("MapViewController loaded its view.")
        
        addMapPin(lat1, lon1, "Lhasa", "dream place")
        addMapPin(lat2, lon2, "Boulder", "working place")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude

        showRegion(latitude, longitude)
        addMapPin(latitude, longitude, "San Francisco", "current location")
    }
    
    func showRegion(_ lat: Double, _ lon: Double) {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)

        mapView.setRegion(region, animated: true)
    }
    
    func addMapPin(_ lat: Double, _ lon: Double, _ title: String, _ subtitle: String) {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }

    func switchLocationButtonCreation() {
        let button: UIButton = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitle("Switch", for: .normal)

        button.backgroundColor = UIColor.white.withAlphaComponent(0.5)

        button.addTarget(self, action: #selector(switchLocation(sender:)), for: .touchUpInside)

        view.addSubview(button)
        
        let margins = view.layoutMarginsGuide

        let bottomConstraint = button.bottomAnchor.constraint(equalTo: margins.bottomAnchor)

        let trailingConstraint = button.trailingAnchor.constraint(equalTo: margins.trailingAnchor)

        bottomConstraint.isActive = true
        trailingConstraint.isActive = true
    }
    
    var currentLocationIndex = 0
    let totalLocationNum = 3
    @objc func switchLocation(sender: UIButton!) {
        print("Now switch the location...")
        
        currentLocationIndex += 1
        if currentLocationIndex > totalLocationNum {
            currentLocationIndex -= totalLocationNum
        }
        
        switch currentLocationIndex {
        case 1:
            showRegion(lat1, lon1)
        case 2:
            showRegion(lat2, lon2)
        case 3:
            self.mapView(mapView, didUpdate: mapView.userLocation)
        default:
            break
        }
    }
    
}
