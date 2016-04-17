//
//  Data.swift
//  zt
//
//  Created by Sicco Dwars on 17-04-16.
//  Copyright © 2016 Martijn Dwars. All rights reserved.
//

import Foundation

class DataSource : NSObject {
    var Noise : Float = 0.0
    var Chirp : Float = 0.0
    var ChirpFrom : Float = 0.0
    var ChirpTo : Float = 0.0
    var ChirpIn : Float = 0.0
    var Trapez : Float = 0.0
    var TrapezPeriod : Float = 0.0
    var TrapezRamp : Float = 0.0
    var NewValues : Bool = true
}