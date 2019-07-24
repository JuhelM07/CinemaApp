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
import SVProgressHUD

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var cinemaInfo = [CinemaInfo]()
    var cinemaI:CinemaInfo?
    var cinemas = [Cinema]()
    var cinemaController: CinemaTableViewController?
    
    @IBOutlet weak var mapView: MKMapView!
    
    var drawer: DrawerView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initialiseLocationManager()
        guard let cinemaController = self.storyboard!.instantiateViewController(withIdentifier: "DrawerViewController") as? CinemaTableViewController else { return }
       
        configureCinemaController(with: cinemaController)
        self.cinemaController = cinemaController
        drawer = self.addDrawerView(withViewController: cinemaController)
    }
    
    func configureCinemaController(with cinemaController: CinemaTableViewController) {
        
        cinemaController.collapseDrawer = { () in
            self.drawer?.position = .partiallyOpen }
        
        cinemaController.updateCinemas = { (cinemas) in
            self.cinemas = cinemas }
    }
    
    func initialiseLocationManager() {
        SVProgressHUD.show()
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        SVProgressHUD.dismiss()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //manager.stopUpdatingLocation()
        if let location = locations.first {
            
            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.002,longitudeDelta: 0.002)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegion(center:myLocation, span: span)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true

            SVProgressHUD.show()
            NetworkManager.cinemaSearch(withLongitude: String(location.coordinate.longitude), withLatitude: String(location.coordinate.latitude)) { (cinemas) in
                self.cinemaController!.cinemas = cinemas
            }
            
            NetworkManager.cinemaInfoSearch(withLongitude: String(location.coordinate.longitude), withLatitude: String(location.coordinate.latitude)) { (cinemaInfo) in
                self.cinemaInfo = cinemaInfo
            }
            SVProgressHUD.dismiss(withDelay: 5.0)
        }
    }
}
