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
    
    var cinemaName = [String]()
    var latitude = [String]()
    var longitude = [String]()
    var distance = [Double]()
    
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

            SVProgressHUD.show(withStatus: "Retrieving cinemas aorund you...")
            NetworkManager.cinemaSearch(withLongitude: String(location.coordinate.longitude), withLatitude: String(location.coordinate.latitude)) { (cinemas) in
                self.cinemaController!.cinemas = cinemas
                self.cinemaName = cinemas.map { $0.cinemaName }
                self.distance = cinemas.map { $0.distance }
            }
            
            NetworkManager.cinemaInfoSearch(withLongitude: String(location.coordinate.longitude), withLatitude: String(location.coordinate.latitude)) { (cinemaInfo) in
                self.cinemaInfo = cinemaInfo
                self.latitude = cinemaInfo.map { $0.latitude }
                self.longitude = cinemaInfo.map { $0.longitude }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) { // Change `2.0` to the desired number of seconds.
                // Code you want to be delayed
                //print(self.distance)
                for index in 0...(self.cinemaInfo.count - 1) {
                    //print(self.cinemaName[index], self.longitude[index], self.latitude[index])
                    
                    if self.distance[index] <= 5.0 {
                    let cinemaPoint = MKPointAnnotation()
                    cinemaPoint.title = self.cinemaName[index]
                    cinemaPoint.coordinate = CLLocationCoordinate2D(latitude: Double(self.latitude[index]) as! CLLocationDegrees, longitude: Double(self.longitude[index]) as! CLLocationDegrees)
                    self.mapView.addAnnotation(cinemaPoint)
                    }
                }
                
            }
            
            SVProgressHUD.dismiss(withDelay: 8.0)
        }
    }
}
