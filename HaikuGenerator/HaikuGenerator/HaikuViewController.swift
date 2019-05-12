//
//  HaikuViewController.swift
//  HaikuGenerator
//
//  Created by Sida Nakrosyte on 11/05/2019.
//  Copyright © 2019 Sida Nakrosyte. All rights reserved.
//

import UIKit

class HaikuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HaikuGenerator().generateFirstLine { (firstLine) in
            print(firstLine)
        }
    }
}
