//
//  InfectedMapViewController.swift
//  Covid19Peru
//
//  Created by Smith Huamani Hilario on 4/21/20.
//  Copyright © 2020 Smith Huamaní Hilario. All rights reserved.
//

import UIKit
import MapKit

class InfectedMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var lineView: UIView!

    var bottomSheet: BottomSheet?
    weak var presentationView: UIView?
    
    lazy var features: FeatureCountryData? = FeatureCountryData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        setupUI()
    }
    
    func setupUI() {
        testView.roundCorners([.topLeft, .topRight], radius: 20.0)
        lineView.layer.cornerRadius = 2.0
        //view.layer.cornerRadius = 20.0
        //view.addShadowViewCustom(cornerRadius: 15.0)
        //view.addShadowViewCustom(cornerRadius: 20.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomSheet = BottomSheet(view, presentationView: presentationView ?? UIView())
        setupMap()
    }
    
    func setupMap() {
        
        guard let feature = features, let properties = feature.properties else {
            view.isHidden = true
            return
        }
        
        mapView.mapType = .standard
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(properties.latitude)!, longitude: CLLocationDegrees(properties.longitude)!)//lati: -9.19, long: -75.0152
        let span = MKCoordinateSpan(latitudeDelta: 12.0, longitudeDelta: 12.0)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = properties.name//"iOSDevCenter-Kirit Modi"
        annotation.subtitle = properties.continent//"Ahmedabad"
        mapView.addAnnotation(annotation)
        
        guard let geometry = feature.geometry, let array4D = geometry.coordinates else {
            return
        }
        
        array4D.forEach { (array3D) in
            array3D.forEach { (array2D) in
                array2D.forEach { (coordinate) in
                    
                    let longitude = coordinate[0]
                    let latitude = coordinate[1]
                    
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    mapView.addAnnotation(annotation)
                }
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //mapView.annotations.forEach{mapView.removeAnnotation($0)}
        mapView.delegate = nil
        mapView = nil
        //bottomSheet = nil
    }
    
    /*deinit {
        mapView.annotations.forEach{mapView.removeAnnotation($0)}
        mapView.delegate = nil
        mapView = nil
    }*/

}
