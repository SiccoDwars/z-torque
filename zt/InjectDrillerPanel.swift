//
//  InjectDrillerPanel.swift
//  zt
//
//  Created by Sicco Dwars on 10-04-16.
//  Copyright © 2016 Martijn Dwars. All rights reserved.
//

import Foundation
import UIKit

class InjectDrillerPanel: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Swift 2.2 selector syntax
        _ = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func quitButtonTochDown(sender: AnyObject) {
        exit(0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
