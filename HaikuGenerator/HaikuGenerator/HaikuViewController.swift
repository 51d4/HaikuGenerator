//
//  HaikuViewController.swift
//  HaikuGenerator
//
//  Created by Sida Nakrosyte on 11/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import UIKit

class HaikuViewController: UIViewController {
    
    @IBOutlet weak var labelGeneratedContent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func actionGenerateHaiku(_ sender: Any) {
        HaikuGenerator().generateFirstLine { (firstLine) in
            DispatchQueue.main.async {
                self.labelGeneratedContent.text = firstLine
            }
        }
    }
}
