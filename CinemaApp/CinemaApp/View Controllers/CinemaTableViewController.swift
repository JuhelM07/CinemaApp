//
//  CinemaTableViewController.swift
//  CinemaApp
//
//  Created by Juhel on 21/06/2019.
//  Copyright © 2019 Juhel Miah. All rights reserved.
//

import UIKit
import CoreLocation

class CinemaTableViewController: UITableViewController, CLLocationManagerDelegate {
    
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 80
    }
    
    @IBAction func searchButton(_ sender: Any) {
        if let postcode = postcodeTF.text, !postcode.isEmpty {
            NetworkManager.cinemaSearch(withPostCode: postcode) { (cinemas) in
                self.cinemas = cinemas
                self.updateCinemas?(cinemas) // if updateCinemas has been given implementation, the updated cinema array is passed as a paramameter. if the updateCinemas is nil, nothing happens
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
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
