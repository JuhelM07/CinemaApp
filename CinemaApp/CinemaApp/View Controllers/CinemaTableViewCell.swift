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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(with cinema: Cinema, with cinemaInfo: CinemaInfo) {
        distanceLabel.text = "\(cinema.distance) miles"
        nameLabel.text = cinema.cinemaName
        idLabel.text = "Cinema ID: \(cinema.id)"
        latLabel.text = cinemaInfo.website
        //print("Latitude is: \(cinema.latitude)")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
