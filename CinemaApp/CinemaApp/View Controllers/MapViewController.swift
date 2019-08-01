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
    
    @IBOutlet weak var mapView: MKMapView!

    let networkManager = NetworkManager()
    let locationManager = CLLocationManager()
    
    var cinemaInfos = [CinemaInfo]()
    var cinemas = [Cinema]()
    var cinemaController: CinemaTableViewController?
    var updateCinemaInfo: (([CinemaInfo]) -> Void)?
    var drawer: DrawerView?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initialiseLocationManager()
        guard let cinemaController = self.storyboard!.instantiateViewController(withIdentifier: "DrawerViewController") as? CinemaTableViewController else { return }
        
        cinemaController.mapController = self
       
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
        
        if let location = locations.first {
            
            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegion(center:myLocation, span: span)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true

            SVProgressHUD.show(withStatus: "Retrieving cinemas aorund you...")
            
            let longitude = String(location.coordinate.longitude)
            let latitude =  String(location.coordinate.latitude)
            
            networkManager.cinemaAndInfoSearch(longitude, latitude) { (cinemas, cinemaInfos) in
                
                self.cinemaController!.cinemas = cinemas
                self.cinemas = cinemas
                self.cinemaInfos = cinemaInfos
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.addMapAnnotations()
                }
                
                SVProgressHUD.dismiss()
            }
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

        for cinemaInfo in cinemaInfos {
            
            let cinemaPoint = MKPointAnnotation()
            cinemaPoint.title = cinemaInfo.name
            
            guard
                let latitude = CLLocationDegrees(cinemaInfo.latitude),
                let longitude = CLLocationDegrees(cinemaInfo.longitude)
            else { return }
            
            cinemaPoint.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.addAnnotation(cinemaPoint)
        }
        //mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func removeMapAnnotations() {
        print("Annotations cleared")
        self.mapView.removeAnnotations(mapView.annotations)
    }
    
}
