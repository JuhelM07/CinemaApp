//
//  CinemaTableViewCell.swift
//  CinemaApp
//
//  Created by Juhel on 21/06/2019.
//  Copyright © 2019 Juhel Miah. All rights reserved.
//

import UIKit

class CinemaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    
    func configureCell(with cinema: Cinema) {
        
        distanceLabel.text = "\(cinema.distance) miles"
        nameLabel.text = cinema.cinemaName
        //idLabel.text = "Cinema ID: \(cinema.id)"
        
        //print("Latitude is: \(cinema.latitude)")
    }
}
