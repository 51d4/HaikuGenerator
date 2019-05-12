//
//  HaikuGenerator.swift
//  HaikuGenerator
//
//  Created by Sida Nakrosyte on 12/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import Foundation

private enum WordPart: String {
    case noun = "n"
    case verb = "v"
    case adjective = "adj"
    case adverb = "adv"
    case other = "u"
}

class HaikuGenerator {
    private let startingKeywords = ["winter", "summer", "autumn", "springtime"]
    private let serviceManager = ServiceManager()
    
    func generateFirstLine(completion: @escaping (_ firstLine: String) -> Void) {
        guard let keyword = startingKeywords.randomElement() else {return}
        let nounParameters = "?topics=\(keyword)&md=sp"
        generateWord(parameters: nounParameters, wordPart: .noun) { (noun, syllables) in
            print(noun + ", number of syllables: \(syllables)")
            
            Haiku.shared.firstLineSyllablesCount = syllables
            Haiku.shared.firstLineNoun = noun
            
            let adjectiveParameters = "?rel_jjb=\(noun)&md=sp&max=50"
            self.generateWord(parameters: adjectiveParameters, wordPart: .adjective, completion: { (adjective, syllables) in
                print(adjective + ", number of syllables: \(syllables)")
                
                Haiku.shared.firstLineSyllablesCount = Haiku.shared.firstLineSyllablesCount + syllables
                Haiku.shared.firstLineAdjective = adjective
                
                if  Haiku.shared.firstLineSyllablesCount < 5 {
                    self.generateWord(parameters: "?rel_bgb=\(adjective)&md=sp", wordPart: .adverb, completion: { (preposition, syllables) in
                        Haiku.shared.firstLineSyllablesCount = Haiku.shared.firstLineSyllablesCount + syllables
                        Haiku.shared.firstLineFirstPreposition = preposition

                        Haiku.shared.firstLine = preposition + " " + adjective + " " + noun
                        completion(preposition + " " + adjective + " " + noun)
                    })
                } else {
                    Haiku.shared.firstLine = adjective + " " + noun
                    completion(adjective + " " + noun)
                }
            })
        }
    }
    
    private func generateWord(parameters: String, wordPart: WordPart, completion: @escaping (_ word: String, _ syllables: Int) -> Void) {
        if Haiku.shared.firstLineSyllablesCount == 5 {
            completion("", 0)
        }
        serviceManager.fetchWords(parameters: parameters) { (result) in
            let filteredResults = self.filter(array: result, wordPart: wordPart)
            if let wordDictionary = filteredResults.randomElement(), let word = wordDictionary["word"] as? String,
                let syllables = wordDictionary["numSyllables"] as? Int {
                completion(word, syllables)
            } else {
                completion("", 0)
            }
        }
    }
    
    private func filter(array: [[AnyHashable: Any]], wordPart: WordPart) -> [[AnyHashable: Any]] {
        let maxSyllables = 5 - Haiku.shared.firstLineSyllablesCount
        return array
            .compactMap({ (dictionary) -> [String: Any]? in
                if let noun = dictionary["word"] as? String,
                    let syllables = dictionary["numSyllables"] as? Int, syllables <= maxSyllables,
                    let tags = dictionary["tags"] as? [String], tags[0] == wordPart.rawValue {
                    return ["word": noun,
                            "numSyllables": syllables]
                }
                return nil
            })
    }
}
