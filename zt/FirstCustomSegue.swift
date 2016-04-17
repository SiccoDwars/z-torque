//
//  FirstCustomSegue.swift
//  zt
//
//  Created by Sicco Dwars on 17-04-16.
//  Copyright © 2016 Martijn Dwars. All rights reserved.
//

import UIKit

class FirstCustomSegue: UIStoryboardSegue {
    override func perform() {
        var firstVCView = self.sourceViewController.view as UIView!
        var secondVCView = self.destinationViewController.view as UIView!
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondVCView, aboveSubview: firstVCView)
        

    }
}
