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
        
        let task = URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            var cinema = [Cinema]()
            
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                let cinemas = json["cinemas"] as? [Dictionary<String, Any>]
            else { return }
            //print(cinemas)
            for dictionary in cinemas {
                try? cinema.append(Cinema(with: dictionary))
            }
            completion(cinema)
            //print(cinema)
        }
        task.resume()
    }
    
    static func cinemaSearch(withPostCode postcode:String, completion: @escaping ([Cinema]) -> ()) {
        let basePath = "https://api.cinelist.co.uk/search/cinemas/postcode/" //used to search by postcode
        
        guard let url = URL(string: basePath + postcode) else { return }
        
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
    
    static func cinemaInfoSearch(withLongitude longitude:String, withLatitude latitude:String , completion: @escaping ([CinemaInfo]) -> ()) {
        
        let basePath = "https://api.cinelist.co.uk/search/cinemas/coordinates/" //used to search by coordinates
        let cinemaUrl = "https://api.cinelist.co.uk/get/cinema/"
        
        
        
        guard let url = URL(string: basePath + latitude + "/" + longitude) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            var results = [[String:Any]]()
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                let cinemas = json["cinemas"] as? [Dictionary<String, Any>]
                else { return }
            
            for dictionary_id in cinemas {
                let id = dictionary_id["id"]!
                guard let cinemaInfoUrl = URL(string: cinemaUrl + "\(id)") else { return }
                
                URLSession.shared.dataTask(with: cinemaInfoUrl) { (data2, response2, error2) in
                    var cinemaInfo = [CinemaInfo]()
                    guard
                        let data2 = data2,
                        let json = try? JSONSerialization.jsonObject(with: data2, options: []) as? [String: Any]
                        else { return }
                    
                    results.append(json)
                    
                    for dictionary2 in results {
                        try! cinemaInfo.append(CinemaInfo(with: dictionary2))
                    }
                    completion(cinemaInfo)
                    //print(cinemaInfo)
                }.resume()
            }
        }
        task.resume()
    }
    
    
    
}
