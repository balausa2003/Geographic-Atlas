//
//  DataManager.swift
//  Geographic-Atlas
//
//  Created by Балауса Косжанова on 17.05.2023.
//


import Foundation

class APICaller {
    static let shared = APICaller()
    
    func handleRequest(completion: @escaping (Result<[CountryAPI], Error>) -> Void) {
        
        let urlString = "https://restcountries.com/v3.1/all"
        
        let url = URL(string: urlString)
        
        let request = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let articles = try decoder.decode([CountryAPI].self, from: data)
                    completion(.success(articles))
                    
                } catch let error {
                    print("Error was \(error)")
                    completion(.failure(error))
                }
            }
            
            if let error = error {
                print("ERRRRROOR \(error)")
            }
            
        }
        task.resume()
        
    }
}
        
    
