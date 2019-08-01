//
//  CinemaTableViewController.swift
//  CinemaApp
//
//  Created by Juhel on 21/06/2019.
//  Copyright © 2019 Juhel Miah. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD

class CinemaTableViewController: UITableViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    var mapController: MapViewController?
    
    var cinemaInfo = [CinemaInfo]()
    var cinemas = [Cinema]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    let locationManager = CLLocationManager()
    var updateCinemas: (([Cinema]) -> Void)? // just a function signature which is given implemenation inside the MapViewController
    
    var collapseDrawer: (() -> Void)?
    @IBOutlet weak var postcodeTF: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        SVProgressHUD.setMinimumDismissTimeInterval(2.0)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 80
        
        guard let mapController = self.storyboard!.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        configureMapController(with: mapController)
        self.mapController = mapController
        postcodeTF.delegate = self
    }
    
    func configureMapController(with mapController: MapViewController) {
        mapController.updateCinemaInfo = { (cinemaInfo) in
            self.cinemaInfo = cinemaInfo }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchBtn.isEnabled = false
        postcodeTF.isEnabled = false
        if let postcode = postcodeTF.text, !postcode.isEmpty {
            SVProgressHUD.show(withStatus: "Retrieving cinemas around you...")
            //mapController?.removeMapAnnotations()
            NetworkManager.cinemaSearch(withPostCode: postcode) { (cinemas) in
                self.cinemas = cinemas
                self.updateCinemas?(cinemas) // if updateCinemas has been given implementation, the updated cinema array is passed as a paramameter. if the updateCinemas is nil, nothing happens
                self.mapController?.cinemas = cinemas
                
                self.mapController?.cinemaName = cinemas.map { $0.cinemaName }

            }
            
            NetworkManager.cinemaInfoSearch(withPostcode: postcode) { (cinemaInfo) in
                self.cinemaInfo = cinemaInfo
                self.mapController?.cinemaInfo = cinemaInfo
                
                self.mapController?.latitude = cinemaInfo.map { $0.latitude }
                self.mapController?.longitude = cinemaInfo.map { $0.longitude }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) {
                print(self.cinemaInfo.count)
                print(self.cinemas.count)
                //self.mapController?.removeMapAnnotations()
                self.mapController?.addMapAnnotations()
                print("Annotations entered through postcode")
            }
            SVProgressHUD.dismiss(withDelay: 8.0)
            self.searchBtn.isEnabled = true
            self.postcodeTF.isEnabled = true
            
        } else {
            SVProgressHUD.showInfo(withStatus: "Please enter a valid postcode.")
            searchBtn.isEnabled = true
            postcodeTF.isEnabled = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " { //Blocks the space key
            return false
        }
        
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cinemas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cinemaCell", for: indexPath) as? CinemaTableViewCell else { return UITableViewCell() }

        cell.configureCell(with: cinemas[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        collapseDrawer?()
    }

}
