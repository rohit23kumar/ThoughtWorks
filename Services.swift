//
//  Services.swift
//  ThoughtWorks
//
//  Created by Rohit Kumar on 30/06/18.
//  Copyright © 2018 Rohit Kumar. All rights reserved.
//

import Foundation

struct BeerDescription: Decodable {
    let name : String
    let abv : String
    let ibu : String
    let style : String
    let ounces : Float
    let id : Int
}


struct Service{
    
    static let sharedInstance = Service()
    
    func fetchingData(completion:@escaping ([BeerDescription]) -> ()) {
        print("Fetching data")
        
        let jsonURLString = "http://starlord.hackerearth.com/beercraft"
        guard let url = URL(string: jsonURLString) else { return  }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            let dataString = String(data: data, encoding: .utf8)
            do{
                let webDescription = try
                    JSONDecoder().decode([BeerDescription].self, from: data)
//                print(webDescription)
                completion(webDescription)
            }catch let jsonErr{
                print("Error occured during json serialisation: ", jsonErr)
            }
            }.resume()
    }
}
