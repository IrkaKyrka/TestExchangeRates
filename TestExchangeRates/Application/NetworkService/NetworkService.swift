//
//  NetworkService.swift
//  TestExchangeRates
//
//  Created by Ira Golubovich on 3/6/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import Foundation


class NetworkService {
    private init() {}
    static let shared = NetworkService()
    
    public func getData(url: URL, complition: @escaping (Any?, Error?) -> ()) {
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, error == nil else {
                print(error ?? "Error")
                complition(nil, error)
                return
            }
            
            complition(data, nil)
        }.resume()
    }
    
}

