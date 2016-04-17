//
//  Connection.swift
//  zt
//
//  Created by Martijn Dwars on 02/04/16.
//  Copyright © 2016 Martijn Dwars. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import SystemConfiguration.CaptiveNetwork

extension String {
    var byteArray : [UInt8] {
        return Array(utf8)
    }
}

class Pico : NSObject, AsyncSocketDelegate {
    var socket: GCDAsyncSocket! = nil
    
    var isConnectedOK: Bool = false;
    var ProfibusVendorID: UInt16 = 0
    var RecordingFrequency:UInt16 = 0
    var PLL_prescale_setting:UInt16 = 0
    var Nref_set:Double = 0
    var Nref_act:Double = 0
    var Tref:Double = 0
    var Ngear:Double = 1.0
    var ModelScaling:UInt16 = 0
   
    var unrampedRPMset: Int16 = 0
    var RPMset: Int16 = 0
    var RPMact: Int16 = 0
    var TRQlim: Int16 = 0
    var TorqueActAirgap: Int16 = 0
    var TorqueIniertia: Int16 = 0
    var TorqueActPipe: Int16 = 0
    var Z_ramped: Int16 = 0
    var Z_timesPipeTorque: Int16 = 0
    var RPMslowLoop: Int16 = 0
    var RPMcommanded: Int16 = 0
    var RPMtrapChirpNoise: Int16 = 0
    var ZT_controlBits: UInt16 = 0
    var CW:UInt16 = 0;
    
    func connect(IPaddress:String) {
        socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        
        do {
            try socket.connectToHost(IPaddress, onPort: 10001)
            
            socket.readDataWithTimeout(-1, tag: 0)
        } catch {
            print(error)
        }
    }
    
    func doSend (st : String)
    {
    //    print ("Sending "+st)
        let data = st.dataUsingEncoding(NSASCIIStringEncoding)
        
        if (socket != nil)
        {
            if (socket.isConnected)
            {
                socket.writeData(data, withTimeout: -1, tag: 0)
            }
            else
            {
                print ("Not connected - so cannot transmit")
            }
        }
        else
        {
            print ("No socket yet - so cannot transmit")
        }
    }
    
    func socket(socket: GCDAsyncSocket, didConnectToHost host:String, port p:UInt16) {
        print("Connected!")
        
    }
    
    var parseState: UInt16 = 0
    
    func AsSignedInt16 (u:UInt16) -> Int16
    {
        var r:UInt16 = u
        if ((r & 0x8000) != 0)
        {
            r ^= 0xffff
            r += 1;
            return (-Int16(r))
        }
        
        return Int16(r)
    }

    func toHexNibble (bb: UInt8) -> UInt8
    {
        var b: UInt8 = bb
        if (b > 96) {       // lower to upper case ASCII
            b -= 32}
        if (b > (48+9)) {   // 0123456789 or ABCDEF
            b -= 7}
        if (b < 48) {
            return 255 }
        b -= 48
        if (b>15){
            return 255}
        return b
    }
    
    var wordIn:UInt16 = 0
    var nibbleCount:UInt16 = 0
    var responseNwords:UInt16 = 0
    var responseWordsIndex:UInt16 = 0
    var responseWords = [UInt16]()
    
    func process_byte (b : UInt8)
    {
//      print (NSString(format:"%02X ", b))
            switch (parseState)
            {
            case 0:
                if (b == 120) // ascii x
                {    parseState = 1
                    wordIn = 0
                    nibbleCount = 0
                }
                break
            case 1:
                if (toHexNibble(b) < 16)
                {
                    wordIn = wordIn << 4;
                    wordIn = wordIn + UInt16(toHexNibble(b))
                    nibbleCount = nibbleCount + 1
                    if (nibbleCount == 4)
                    {
                        responseNwords = wordIn
                        responseWordsIndex = 0
                        nibbleCount = 0
                        CRC16=0xffff
                        addCRC16(UInt8(wordIn & 0xff))
                        addCRC16(UInt8(wordIn >> 8))
                        wordIn = 0
                        
                        responseWords.removeAll()
                        parseState = 2
                    }
                }
                else{ parseState = 0;}
                
                break
            case 2:
                if (toHexNibble(b) < 16)
                {
                    wordIn = wordIn << 4;
                    wordIn = wordIn + UInt16(toHexNibble(b))
                    nibbleCount = nibbleCount + 1
                    if (nibbleCount == 4)
                    {
                        responseWordsIndex += 1
                        if (responseWordsIndex >= 16){
                            parseState = 0}
                        if (responseWordsIndex == (responseNwords+1)){
                            if (CRC16 == wordIn){
                                parseState = 3}
                            else{
                                parseState = 0
                            }
                        }
                        else
                        {
                            responseWords.append(wordIn)
                            addCRC16(UInt8(wordIn & 0xff))
                            addCRC16(UInt8(wordIn >> 8))
                        }
                        wordIn = 0
                        nibbleCount = 0
                    }
                    break
                   
                }
                else{
                    parseState = 0;}
            case 3:
                if (b == (120-32))  //ASCII X
                {
 //                   print ("response received")
 //                   var i:UInt16
 //                   i=0
 //                   while (i < (responseWordsIndex-1)){
 //                       print ("word "+(NSString(format:"%d", i) as String)+" is "+(NSString(format:"%04X",responseWords[Int(i)]) as String))
 //                       i += 1
 //                   }
                    
                    switch (responseWords[0])
                    {
                    case 10:
                        unrampedRPMset = AsSignedInt16 (responseWords[1])
                        RPMset = AsSignedInt16 (responseWords[2])
                        RPMact = AsSignedInt16 (responseWords[3])
                        TRQlim = AsSignedInt16 (responseWords[4])
                        TorqueActAirgap = AsSignedInt16 (responseWords[5])
                        TorqueIniertia = AsSignedInt16 (responseWords[6])
                        TorqueActPipe = AsSignedInt16 (responseWords[7])
                        Z_ramped = AsSignedInt16 (responseWords[8])
                        Z_timesPipeTorque = AsSignedInt16 (responseWords[9])
                        RPMslowLoop = AsSignedInt16 (responseWords[10])
                        RPMcommanded = AsSignedInt16 (responseWords[11])
                        RPMtrapChirpNoise = AsSignedInt16 (responseWords[12])
                        ZT_controlBits = responseWords[13]
                        CW = responseWords[14]
                        break
                    case 11:
                        ProfibusVendorID = responseWords[1]
                        RecordingFrequency = responseWords[2]
                        PLL_prescale_setting = responseWords[3]
                        Nref_set = Double(responseWords[4])
                        Nref_act = Double(responseWords[5])
                        Tref = Double(responseWords[6])
                        Ngear = Double(responseWords[7]) / 100.0
                        ModelScaling = responseWords[8]
                        break
                    default:
                        break
                    }
                }
                parseState = 0
                break
            default:
                break
        }
        
    }

    func socket(socket: GCDAsyncSocket, didReadData data:NSData, withTag tag:Int32) {
        if let response = NSString(data: data, encoding: NSASCIIStringEncoding) {
            let st = String(response)
            
            var i = 0
            var length = data.length
            
            while (length > 0)
            {
                process_byte(st.byteArray[i])
                i = i+1
                length = length-1
            }
        //    print(response)
        }
        
        socket.readDataWithTimeout(-1, tag: 0)
    }
    
    var CRC16: UInt16 = 0
    
    func addCRC16 (n: UInt8)
    {
        var x = (CRC16 >> 8) ^ UInt16(n)
        x ^= x >> 4
        CRC16 = (CRC16 << 8) ^ (UInt16(x<<12)) ^ (UInt16(x<<5) ^ (UInt16(x)))
    }

    func addHexWord (st: String, n: UInt16) -> String
    {
        let st2 = NSString(format:"%04X", n) as String
        addCRC16 (UInt8(n & 0xff))
        addCRC16 (UInt8(n>>8))
        return st+st2
    }
    
    
    func Ww(){
        
    //    print("Send !")
        
        var st = "w"
        CRC16 = 0xffff;
        
        st = addHexWord (st, n: 11)
        st = addHexWord (st, n: CRC16)
        st += "W"
        doSend (st)
        
    }

    func Xx(OnOffs:UInt16, CW:UInt16, RPMset:UInt16, TRQlim:UInt16, Z_req: UInt16){
        
    //    print("Send Xx!")
        
        var st = "w"
        CRC16 = 0xffff;
        
        st = addHexWord (st, n: 10)
        st = addHexWord (st, n: OnOffs)
        st = addHexWord (st, n: CW)
        st = addHexWord (st, n: RPMset)
        st = addHexWord (st, n: TRQlim)
        st = addHexWord (st, n: Z_req)
        
        st = addHexWord (st, n: CRC16)
        st += "W"
        doSend (st)
        
    }
    
    func send(a: UInt16, b: UInt16, c: UInt16, d:UInt16, e:UInt16, f:UInt16, g:UInt16, h:UInt16, i:UInt16) {
    //    print("Send!")
        var st = "w"
        CRC16 = 0xffff;
        
        st = addHexWord (st, n: 9)
        st = addHexWord (st, n: a)
        st = addHexWord (st, n: b)
        st = addHexWord (st, n: c)
        st = addHexWord (st, n: d)
        st = addHexWord (st, n: e)
        st = addHexWord (st, n: f)
        st = addHexWord (st, n: g)
        st = addHexWord (st, n: h)
        st = addHexWord (st, n: i)
        st = addHexWord (st, n: 0)
        st = addHexWord (st, n: 3)
        st = addHexWord (st, n: CRC16)
        st += "W"
        doSend (st)
    }

    
    func disconnect(){
        
        if (socket != nil)
        {
            if (socket.isConnected)
            {
                print ("disconnecting")
                socket.disconnect()
            }
        }
    }
    
    
    func fetchSSIDInfo() ->  String {
            var currentSSID = ""
            if let interfaces:CFArray! = CNCopySupportedInterfaces() {
                for i in 0..<CFArrayGetCount(interfaces){
                    let interfaceName: UnsafePointer<Void> = CFArrayGetValueAtIndex(interfaces, i)
                    let rec = unsafeBitCast(interfaceName, AnyObject.self)
                    let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)")
                    if unsafeInterfaceData != nil {
                        let interfaceData = unsafeInterfaceData! as Dictionary!
                        currentSSID = interfaceData["SSID"] as! String
                    }
                }
            }
            return currentSSID
    }
    
    
    func get_status_as_string() -> String {
        if (socket != nil)
        {
            if (socket.isConnected)
            {
                isConnectedOK = true;
                let st = NSString(format:"%d", socket.connectedPort) as String
                return "Connected (SSID="+fetchSSIDInfo()+" "+socket.connectedHost+" Port:"+st+")"
 //               return "Connected (SSID="+" "+socket.connectedHost+" Port:"+st+")"
                
            }
            else
            {
                isConnectedOK = false;
                return "Not Connected (SSID="+fetchSSIDInfo()+")"
            }
        }
        else
        {
            isConnectedOK=false;
            return "No socket"
        }

    }
}