//
//  MapViewController.swift
//  CinemaApp
//
//  Created by Juhel on 04/07/2019.
//  Copyright © 2019 Juhel Miah. All rights reserved.
//

import UIKit
import DrawerView
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseLocationManager()
        let drawerViewController = self.storyboard!.instantiateViewController(withIdentifier: "DrawerViewController")
        self.addDrawerView(withViewController: drawerViewController)
        // Do any additional setup after loading the view.
    }
    
    func initialiseLocationManager() {
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.002,longitudeDelta: 0.002)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion(center:myLocation, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
