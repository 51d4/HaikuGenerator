//
//  ViewController.swift
//  HaikuGenerator
//
//  Created by Sida Nakrosyte on 05/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import UIKit

class ServiceManager {
    func fetchWords(parameters: String, completion: @escaping (_ array: [[AnyHashable: Any]]) -> Void) {
        let urlString = "https://api.datamuse.com/words" + parameters
        guard let url = URL(string: urlString) else {return}

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let err = error {
                print("Communication error: \(err)")
            }
            
            if let result = data {
                do {
                    if let resultObject = try JSONSerialization.jsonObject(with: result, options: []) as? [[AnyHashable: Any]] {
                        print("Results: \(resultObject)")
                        
                        completion(resultObject)
                    }
                } catch {
                    print("Unable to parse JSON response")
                }
            } else {
                print("Received empty response.")
            }
        }.resume()
    }
}

