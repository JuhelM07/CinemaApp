//
//  CinemaTableViewController.swift
//  CinemaApp
//
//  Created by Juhel on 21/06/2019.
//  Copyright © 2019 Juhel Miah. All rights reserved.
//

import UIKit
import CoreLocation

class CinemaTableViewController: UITableViewController, CLLocationManagerDelegate{
    var cinema = [Cinema]()
    var cinemaInfo = [CinemaInfo]()
    let locationManager = CLLocationManager()
    @IBOutlet weak var postcodeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialiseLocationManager()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 90
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
        if let location = locations.first {
            let userLatitude = location.coordinate.latitude
            let userLongitude = location.coordinate.longitude
            
            NetworkManager.cinemaSearch(withLongitude: String(userLongitude), withLatitude: String(userLatitude)) { (cinema) in
                self.cinema = cinema
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            NetworkManager.cinemaInfoSearch(withLongitude: String(userLongitude), withLatitude: String(userLatitude)) { (cinemaInfo) in
                self.cinemaInfo = cinemaInfo
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        if let postcode = postcodeTF.text, !postcode.isEmpty {
            NetworkManager.cinemaSearch(withPostCode: postcode) { (cinema) in
                self.cinema = cinema
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //print(cinemaInfo.count)
        return cinemaInfo.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cinemaCell", for: indexPath) as? CinemaTableViewCell else { return UITableViewCell() }
        let cinemaList = cinema[indexPath.section]
        let cinemaInfoList = cinemaInfo[indexPath.section]
        cell.configureCell(with: cinemaList, with: cinemaInfoList)
        
        return cell
    }

}
