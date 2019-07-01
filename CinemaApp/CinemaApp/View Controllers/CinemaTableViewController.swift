//
//  CinemaTableViewController.swift
//  CinemaApp
//
//  Created by Juhel on 21/06/2019.
//  Copyright © 2019 Juhel Miah. All rights reserved.
//

import UIKit

class CinemaTableViewController: UITableViewController{
    @IBOutlet weak var latitudeTF: UITextField!
    @IBOutlet weak var longitudeTF: UITextField!
    
    var cinema = [Cinema]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
    }

    
    @IBAction func searchButton(_ sender: Any) {
        let latitudeText = latitudeTF.text
        let longitudeText = longitudeTF.text
        
        NetworkManager.cinemaSearch(withLongitude: longitudeText!, withLatitude: latitudeText!) { (cinema) in
            self.cinema = cinema
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//
//        if let locationText = searchBar.text, !locationText.isEmpty {
//            NetworkManager.cinemaSearch(withSearchTerm: locationText) { (cinema) in
//                self.cinema = cinema
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                    print(locationText)
//                }
//            }
//        }
//    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return cinema.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cinemaCell", for: indexPath) as? CinemaTableViewCell else { return UITableViewCell() }
        let cinemaList = cinema[indexPath.section]
        cell.configureCell(with: cinemaList)
        return cell
    }

}
