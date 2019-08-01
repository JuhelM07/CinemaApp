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
    private (set) var name: String
    private (set) var id: String
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(with json: [String:Any]) throws {
        guard
            let distance = json["distance"] as? Double,
            let cinemaName = json["name"] as? String,
            let id = json["id"] as? String
        else { throw SerializationError.missing("Failed to load data")}
        
        self.distance = distance
        self.name = cinemaName
        self.id = id
    }
    
}
