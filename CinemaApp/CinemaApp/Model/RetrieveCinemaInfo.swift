//
//  RetrieveCinemaInfo.swift
//  CinemaApp
//
//  Created by Juhel on 04/07/2019.
//  Copyright © 2019 Juhel Miah. All rights reserved.
//

import Foundation

struct CinemaInfo {
    
    private (set) var address1: String
    private (set) var townCity: String
    private (set) var showTownCity: Bool
    private (set) var postCode: String
    private (set) var website: String
    private (set) var phone: String
    private (set) var distance: String
    private (set) var latitude: String
    private (set) var longitude: String
    
    enum SerializationError: Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(with json: [String:Any]) throws {
        guard
            let address1 = json["address1"] as? String,
            let townCity = json["towncity"] as? String,
            let showTownCity = json["show_towncity"] as? Bool,
            let postCode = json["postcode"] as? String,
            let website = json["website"] as? String,
            let phone = json["phone"] as? String,
            let distance = json["distance"] as? String,
            let latitude = json["lat"] as? String,
            let longitude = json["lon"] as? String
            else { throw SerializationError.missing("Failed to load cinema information.") }
    
        self.address1 = address1
        self.townCity = townCity
        self.showTownCity = showTownCity
        self.postCode = postCode
        self.website = website
        self.phone = phone
        self.distance = distance
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    
}
