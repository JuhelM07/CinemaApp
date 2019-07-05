//
//  RetrieveCinema.swift
//  CinemaApp
//
//  Created by Juhel on 21/06/2019.
//  Copyright © 2019 Juhel Miah. All rights reserved.
//

import Foundation

struct Cinema {
    
    private (set) var distance: Double
    private (set) var cinemaName: String
    private (set) var id: String
    //private (set) var cinemaLat: String
    //private (set) var cinemaLon: String
    //private (set) var times: String
    //private (set) var movieTitle: String
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(with json: [String:Any]) throws {
        guard
            let distance = json["distance"] as? Double,
            let cinemaName = json["name"] as? String,
            let id = json["id"] as? String
            //let times = json["times"] as? String,
            //let movieTitle = json["title"] as? String
        else { throw SerializationError.missing("Failed to load data")}
        
        self.distance = distance
        self.cinemaName = cinemaName
        self.id = id
        //self.times = times
        //self.movieTitle = movieTitle
    }
    
}
