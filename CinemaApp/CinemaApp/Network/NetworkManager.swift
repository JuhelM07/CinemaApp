//
//  NetworkManager.swift
//  CinemaApp
//
//  Created by Juhel on 21/06/2019.
//  Copyright © 2019 Juhel Miah. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager: NSObject {
    
    static func cinemaSearch(withLongitude longitude:String, withLatitude latitude:String , completion: @escaping ([Cinema]) -> ()) {
        
        let basePath = "https://api.cinelist.co.uk/search/cinemas/coordinates/" //used to search by coordinates
        
        guard let url = URL(string: basePath + latitude + "/" + longitude) else { return }
        print (url)
        
        let task = URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            var cinema = [Cinema]()
            
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                let cinemas = json["cinemas"] as? [Dictionary<String, Any>]
                else { return }
            
            for dictionary in cinemas {
                try? cinema.append(Cinema(with: dictionary))
            }
            completion(cinema)
        }
        task.resume()
    }
    
}
