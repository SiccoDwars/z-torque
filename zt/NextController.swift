//
//  NextController.swift
//  zt
//
//  Created by Sicco Dwars on 16-04-16.
//  Copyright © 2016 Martijn Dwars. All rights reserved.
//

import UIKit

class NextController: UIViewController {

    var model: DataSource?
    
    @IBOutlet weak var SlideNoise: UISlider!
    @IBOutlet weak var SlideChirp: UISlider!
    @IBOutlet weak var SlideChirpFrom: UISlider!
    @IBOutlet weak var SlideChirpTo: UISlider!
    @IBOutlet weak var SlideChirpIn: UISlider!
    @IBOutlet weak var SlideTrapez: UISlider!
    @IBOutlet weak var SlideTrapezPeriod: UISlider!
    @IBOutlet weak var SlideTrapezRamp: UISlider!
    
    @IBOutlet weak var TextBoxNoise: UITextField!
    @IBOutlet weak var TextBoxChirp: UITextField!
    @IBOutlet weak var TextBoxChirpFrom: UITextField!
    @IBOutlet weak var TextBoxChirpTo: UITextField!
    @IBOutlet weak var TextBoxChirpIn: UITextField!
    @IBOutlet weak var TextBoxTrapez: UITextField!
    
    @IBOutlet weak var TextBoxtrapezPeriod: UITextField!
    
    @IBOutlet weak var TextBoxTrapezRamp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SlideNoise.value = self.model!.Noise
        SlideChirp.value = self.model!.Chirp
        SlideChirpFrom.value = self.model!.ChirpFrom
        SlideChirpTo.value = self.model!.ChirpTo
        SlideChirpIn.value = self.model!.ChirpIn
        SlideTrapez.value = self.model!.Trapez
        SlideTrapezPeriod.value = self.model!.TrapezPeriod
        SlideTrapezRamp.value = self.model!.TrapezRamp
        
        doSlideChanged()
    }
    
    @IBAction func SlideChanged(sender: AnyObject) {
        doSlideChanged()
    }
    
    func doSlideChanged() {
        self.model!.Noise = SlideNoise.value
        self.model!.Chirp = SlideChirp.value
        self.model!.ChirpFrom = SlideChirpFrom.value
        self.model!.ChirpTo = SlideChirpTo.value
        self.model!.ChirpIn = SlideChirpIn.value
        self.model!.Trapez = SlideTrapez.value
        self.model!.TrapezPeriod = SlideTrapezPeriod.value
        self.model!.TrapezRamp = SlideTrapezRamp.value

        TextBoxNoise.text = String(stringInterpolationSegment: UInt32(10000 * self.model!.Noise))
        TextBoxChirp.text = String(stringInterpolationSegment: UInt32(10000 * self.model!.Chirp))
        TextBoxTrapez.text = String(stringInterpolationSegment: UInt32(10000 * self.model!.Trapez))
        
        self.model!.NewValues = true
    }
    
    
}