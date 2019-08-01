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
    
    var updateCinemaInfo: (([CinemaInfo]) -> Void)?
    
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
            
            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02,longitudeDelta: 0.02)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegion(center:myLocation, span: span)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true

            SVProgressHUD.show(withStatus: "Retrieving cinemas aorund you...")
            NetworkManager.cinemaSearch(withLongitude: String(location.coordinate.longitude), withLatitude: String(location.coordinate.latitude)) { (cinemas) in
                self.cinemaController!.cinemas = cinemas
                self.cinemas = cinemas
                
                self.cinemaName = cinemas.map { $0.cinemaName }
                //self.distance = cinemas.map { $0.distance }
            }
            
            NetworkManager.cinemaInfoSearch(withLongitude: String(location.coordinate.longitude), withLatitude: String(location.coordinate.latitude)) { (cinemaInfo) in
                self.cinemaInfo = cinemaInfo
                self.updateCinemaInfo?(cinemaInfo)
                
                self.latitude = cinemaInfo.map { $0.latitude }
                self.longitude = cinemaInfo.map { $0.longitude }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                self.addMapAnnotations()
            }
            
            SVProgressHUD.dismiss(withDelay: 8.0)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func addMapAnnotations() {
        print("Cinema Info Count: \(cinemaInfo.count)")
        print("Cinemas Count: \(cinemas.count)")
        
        for index in 0...(cinemaInfo.count - 1) {
            print(self.cinemaName[index], self.longitude[index], self.latitude[index])
            var cinemaPoint = MKPointAnnotation()
            cinemaPoint.title = self.cinemaName[index]
            cinemaPoint.coordinate = CLLocationCoordinate2D(latitude: Double(self.latitude[index]) as! CLLocationDegrees, longitude: Double(self.longitude[index]) as! CLLocationDegrees)
            print(cinemaPoint)
            mapView.addAnnotation(cinemaPoint)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func removeMapAnnotations() {
        print("Annotations cleared")
        self.mapView.removeAnnotations(mapView.annotations)
    }
    
}
