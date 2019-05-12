//
//  HaikuGenerator.swift
//  HaikuGenerator
//
//  Created by Sida Nakrosyte on 12/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import Foundation

class HaikuGenerator {
    private let startingKeywords = ["winter", "summer", "autumn", "springtime"]
    private let serviceManager = ServiceManager()
    
    func generateFirstLine(completion: @escaping (_ firstLine: String) -> Void) {
        guard let keyword = startingKeywords.randomElement() else {return}
        let nounParameters = "?ml=\(keyword)&md=s&max=50"
        generateWord(parameters: nounParameters) { (noun, syllables) in
            print(noun + ", number of syllables: \(syllables)")
            
            Haiku.shared.firstLineSyllablesCount = syllables
            Haiku.shared.firstLineNoun = noun
            
            let adjectiveParameters = "?rel_jjb=\(noun)&md=s&max=50"
            self.generateWord(parameters: adjectiveParameters, completion: { (adjective, syllables) in
                print(adjective + ", number of syllables: \(syllables)")
                
                Haiku.shared.firstLineSyllablesCount = Haiku.shared.firstLineSyllablesCount + syllables
                Haiku.shared.firstLineAdjective = adjective
                
                Haiku.shared.firstLine = adjective + " " + noun
                completion(adjective + " " + noun)
            })
        }
    }
    
    private func generateWord(parameters: String, completion: @escaping (_ word: String, _ syllables: Int) -> Void) {
        serviceManager.fetchWords(parameters: parameters) { (result) in
            let filteredResults = self.filter(array: result, maxSyllables: 5)
            if let wordDictionary = filteredResults.randomElement(), let word = wordDictionary["word"] as? String,
                let syllables = wordDictionary["numSyllables"] as? Int {
                completion(word, syllables)
            }
        }
    }
    
    private func filter(array: [[AnyHashable: Any]], maxSyllables: Int) -> [[AnyHashable: Any]] {
        return array
            .compactMap({ (dictionary) -> [String: Any]? in
                if let noun = dictionary["word"] as? String,
                    let syllables = dictionary["numSyllables"] as? Int, syllables <= maxSyllables {
                    return ["word": noun,
                            "numSyllables": syllables]
                }
                return nil
            })
    }
}
