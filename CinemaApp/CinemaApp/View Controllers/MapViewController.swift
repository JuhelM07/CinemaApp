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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var cinemaInfo = [CinemaInfo]()
    var cinemaI:CinemaInfo?
    var cinemas = [Cinema]()
    @IBOutlet weak var mapView: MKMapView!
    var drawer: DrawerView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initialiseLocationManager()
        guard let drawerViewController = self.storyboard!.instantiateViewController(withIdentifier: "DrawerViewController") as? CinemaTableViewController else { return }
        
        configureMapViewUpdater(with: drawerViewController)
        configureCollapseDrawer(with: drawerViewController)
        drawer = self.addDrawerView(withViewController: drawerViewController)
    }
    
    func configureCollapseDrawer(with cinemaController: CinemaTableViewController) {
        
        cinemaController.collapseDrawer = { () in
            self.drawer?.position = .partiallyOpen
        }
    }
    
    func configureMapViewUpdater(with cinemaController: CinemaTableViewController) {
        
        cinemaController.updateCinemas = { (cinemas) in
            self.cinemas = cinemas
        }
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
        //manager.stopUpdatingLocation()
        let loca = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.002,longitudeDelta: 0.002)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(loca.coordinate.latitude, loca.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion(center:myLocation, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
//        NetworkManager.cinemaInfoSearch(withLongitude: String(loca.coordinate.longitude), withLatitude: String(loca.coordinate.latitude)) { (cinemaInfo) in
//            self.cinemaInfo = cinemaInfo
//        }
//
//        print(cinemaI?.latitude)
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


