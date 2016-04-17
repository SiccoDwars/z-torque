//
//  ViewController.swift
//  zt
//
//  Created by Martijn Dwars on 02/04/16.
//  Copyright © 2016 Martijn Dwars. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ViewController: UIViewController {
    var pico = Pico()
    var dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Swift 2.2 selector syntax
        _ = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let next = segue.destinationViewController as! NextController
        next.model = dataSource
    }
    
    @IBAction func quitButtonTochDown(sender: AnyObject) {
      exit(0)
    }
    
    
    // must be internal or public.
    func update() {
        ShowIfConnected()
        Cyclic_Poll_ZT_board ()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var Text2: UITextView!
    
    @IBOutlet weak var bJ: UITextField!

    @IBOutlet weak var C2: UITextField!
    @IBOutlet weak var FIR_C2: UITextField!
    
    
    @IBOutlet weak var C3: UITextField!

    @IBOutlet weak var FIR_C3: UITextField!
    
    @IBOutlet weak var M: UITextField!
    
    @IBOutlet weak var FIR_M: UITextField!
    
    
    @IBOutlet weak var SLLP: UITextField!
    
    @IBOutlet weak var RPM: UILabel!

    @IBOutlet weak var Torque: UILabel!
    
    @IBOutlet weak var Zramped: UILabel!
 
    @IBOutlet weak var SlideRPMset: UISlider!
    @IBOutlet weak var RPMsetTextBox: UILabel!
    @IBOutlet weak var OnOffRPMset: UISwitch!
    @IBOutlet weak var SlideTRQlim: UISlider!
    @IBOutlet weak var TRQlimTextBox: UILabel!
    @IBOutlet weak var OnOffTRQlim: UISwitch!
    @IBOutlet weak var SliderZ: UISlider!
    @IBOutlet weak var OnOffZ: UISwitch!
    @IBOutlet weak var ZsetTextBox: UILabel!

    @IBOutlet weak var IPaddressTextBox: UITextField!
    
    @IBOutlet weak var CW_override: UISwitch!
    
    @IBOutlet weak var CW_b0: UISwitch!
    @IBOutlet weak var CW_b1: UISwitch!
    @IBOutlet weak var CW_b2: UISwitch!
    @IBOutlet weak var CW_b3: UISwitch!
    @IBOutlet weak var CW_b4: UISwitch!
    @IBOutlet weak var CW_b5: UISwitch!
    @IBOutlet weak var CW_b6: UISwitch!
    @IBOutlet weak var CW_b7: UISwitch!
    
    @IBOutlet weak var CW_b8: UISwitch!
    @IBOutlet weak var CW_b9: UISwitch!
    @IBOutlet weak var CW_b10: UISwitch!
    @IBOutlet weak var CW_b11: UISwitch!
    @IBOutlet weak var CW_b12: UISwitch!
    @IBOutlet weak var CW_b13: UISwitch!
    @IBOutlet weak var CW_b14: UISwitch!
    @IBOutlet weak var CW_b15: UISwitch!
    
    
    var cycles:UInt32 = 0
    
    func ShowIfConnected(){
        Text2.text = pico.get_status_as_string()
    }
    
    func setBinaryCW (CW : UInt16)
    {
        CW_b0.on = ((CW & 0b0000000000000001) != 0)
        CW_b1.on = ((CW & 0b0000000000000010) != 0)
        CW_b2.on = ((CW & 0b0000000000000100) != 0)
        CW_b3.on = ((CW & 0b0000000000001000) != 0)
        CW_b4.on = ((CW & 0b0000000000010000) != 0)
        CW_b5.on = ((CW & 0b0000000000100000) != 0)
        CW_b6.on = ((CW & 0b0000000001000000) != 0)
        CW_b7.on = ((CW & 0b0000000010000000) != 0)
        CW_b8.on = ((CW & 0b0000000100000000) != 0)
        CW_b9.on = ((CW & 0b0000001000000000) != 0)
        CW_b10.on = ((CW & 0b0000010000000000) != 0)
        CW_b11.on = ((CW & 0b0000100000000000) != 0)
        CW_b12.on = ((CW & 0b0001000000000000) != 0)
        CW_b13.on = ((CW & 0b0010000000000000) != 0)
        CW_b14.on = ((CW & 0b0100000000000000) != 0)
        CW_b15.on = ((CW & 0b1000000000000000) != 0)
    }
    
    func GetBinaryCW () -> UInt16
    {
        var r:UInt16 = 0
        
        if (CW_b0.on) {
            r += 0b0000000000000001 }
        if (CW_b1.on) {
            r += 0b0000000000000010 }
        if (CW_b2.on) {
            r += 0b0000000000000100 }
        if (CW_b3.on) {
            r += 0b0000000000001000 }
        if (CW_b4.on) {
            r += 0b0000000000010000 }
        if (CW_b5.on) {
            r += 0b0000000000100000 }
        if (CW_b6.on) {
            r += 0b0000000001000000 }
        if (CW_b7.on) {
            r += 0b0000000010000000 }
        if (CW_b8.on) {
            r += 0b0000000100000000 }
        if (CW_b9.on) {
            r += 0b0000001000000000 }
        if (CW_b10.on) {
            r += 0b0000010000000000 }
        if (CW_b11.on) {
            r += 0b0000100000000000 }
        if (CW_b12.on) {
            r += 0b0001000000000000 }
        if (CW_b13.on) {
            r += 0b0010000000000000 }
        if (CW_b14.on) {
            r += 0b0100000000000000 }
        if (CW_b15.on) {
            r += 0b1000000000000000 }
        
        return r
    }
    
    func Cyclic_Poll_ZT_board (){
            var RPM_set: Double
        var RPM_act: Double
        var Torque_act: Double
        var Torque_lim: Double
        var Z_ref: Double = 0.0
        var Z: Double
        var Z_recip: Double = 99999.0
        var OnOffs: UInt16 = 0
        var CW: UInt16 = 1;
        var RPMset: UInt16
        var TRQlim: UInt16
        var Z_requested: UInt16
        var Zreq: Double
        var Zreq_recip: Double = 99999.0
        
       
        
        if (CW_override.on){
            OnOffs += 0b00010000}

        if (OnOffRPMset.on){
            OnOffs += 0b00100000}
        
        if (OnOffTRQlim.on){
            OnOffs += 0b01000000}
        
        if (OnOffZ.on){
            OnOffs += 0b10000000}
        
        if (pico.isConnectedOK){
            self.view.backgroundColor = UIColor.greenColor() }
        else {
            self.view.backgroundColor = UIColor.redColor()}

        
        RPM_act = pico.Nref_act *  (Double(pico.RPMact)/16384) / pico.Ngear;
        Torque_act = pico.Tref * (Double(pico.TorqueActPipe)/16384) * pico.Ngear;
        
        if (pico.Tref>0){
            Z_ref = (pico.Nref_act * (3.1415927 / 30) * 8.0) / (pico.Tref * pico.Ngear * pico.Ngear)
        }

        CW = GetBinaryCW ()
    
        RPMset = UInt16 (SlideRPMset.value * 16384.0)
        TRQlim = UInt16 (SlideTRQlim.value * 16384.0)
        Z_requested = UInt16(SliderZ.value * 16384.0)
        
        RPM_set = Double(pico.Nref_set) *  (Double(RPMset)/16384) / pico.Ngear;
        Torque_lim = Double(pico.Tref) * (Double(TRQlim)/16384) * pico.Ngear;
        
        RPMsetTextBox.text = String(stringInterpolationSegment: UInt32(RPM_set))
        TRQlimTextBox.text = String(stringInterpolationSegment: UInt32(Torque_lim))

        Zreq = ((Double(Z_requested) * Z_ref) / 16384.0)
        if (Zreq>0.0){
            Zreq_recip = 1.0 / Zreq}
       
        ZsetTextBox.text = "1/"+String(stringInterpolationSegment: UInt32(Zreq_recip))
        
//        var NewValues:Bool = false
        
        if (dataSource.NewValues)
        {
//          pico.
            dataSource.NewValues = false
        }
        else
        {
            if (((cycles % 10) == 0) || (pico.Nref_set==0)){
                pico.Ww();
            }
            else{
                pico.Xx(OnOffs, CW: CW, RPMset: RPMset, TRQlim: TRQlim, Z_req: Z_requested);
            }
            cycles += 1
        }
        
        if (!CW_override.on){
            setBinaryCW (pico.CW)}
//            OnOffs += 0b00010000}
        
        if (!OnOffRPMset.on){
            SlideRPMset.value = Float(pico.RPMset)/16384.0}
//            OnOffs += 0b00100000}
        
        if (!OnOffTRQlim.on){
            SlideTRQlim.value = Float(pico.TRQlim)/16384.0}
//            OnOffs += 0b01000000}
        
        if (!OnOffZ.on){
            SliderZ.value = Float(pico.Z_ramped)/16384.0}
        
        Z = ((Double(pico.Z_ramped) * Z_ref) / 16384.0)
        if (Z>0.0){
            Z_recip = 1.0 / Z}

        RPM.text = NSString(format:"%1.1f", RPM_act) as String
        Torque.text = NSString(format:"%1.3f", Torque_act/1000.0) as String
        Zramped.text = NSString(format:"%1.1f", Z_recip) as String
    }
    
    
    @IBAction func connectTapped(sender: AnyObject) {
    //    print("Connect button tapped!")
        
        pico.connect(IPaddressTextBox.text!)
     }
    
    @IBAction func disconnectTapped(sender: AnyObject) {
        
     //   print("Disconnect button tapped!")
        
        pico.disconnect()
     }
    @IBAction func sendTapped(sender: AnyObject) {
    //    print("Send button tapped!")
        var C2_asUInt16: UInt16
        var C3_asUInt16: UInt16
        var M_asUInt16: UInt16
        var C2_FIR_asUInt16: UInt16
        var C3_FIR_asUInt16: UInt16
        var M_FIR_asUInt16: UInt16
 
        var J_asUInt16: UInt16
        var Z_asUInt16: UInt16
        var SLLP_asUInt16: UInt16
        
        C2_asUInt16 = UInt16(C2.text!)!
        C2_FIR_asUInt16 = UInt16(FIR_C2.text!)!
        C3_asUInt16 = UInt16(C3.text!)!
        C3_FIR_asUInt16 = UInt16(FIR_C3.text!)!
        M_asUInt16 = UInt16(M.text!)!
        M_FIR_asUInt16 = UInt16(FIR_M.text!)!
        J_asUInt16 = UInt16 (bJ.text!)!
        Z_asUInt16 = UInt16 (16384.0 * SliderZ.value)
        SLLP_asUInt16 = UInt16 (SLLP.text!)!
        
        pico.send(C2_FIR_asUInt16, b: C3_FIR_asUInt16, c: M_FIR_asUInt16, d: C2_asUInt16,  e: C3_asUInt16, f: M_asUInt16, g: J_asUInt16, h:Z_asUInt16, i:SLLP_asUInt16)
    }

}

