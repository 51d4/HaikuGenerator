//
//  ViewController.swift
//  HaikuGenerator
//
//  Created by Sida Nakrosyte on 05/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import UIKit

class WordGenerator {
    func generateWord(parameters: String, completion: @escaping (_ string: String) -> Void) {
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
                        
                        if let firstWord = resultObject[0]["word"] as? String {
                            completion(firstWord)
                        }
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

