//
//  ViewController.swift
//  BlueT
//
//  Created by Malathesh Helvar on 12/4/15.
//  Copyright © 2015 Ganesh Hebbal Subash. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore


enum MessageOption: Int {
    case NoLineEnding = 0
    case Newline = 1
    case CarriageReturn = 2
    case CarriageReturnAndNewline = 3
}

/// The option to add a \n to the end of the received message (to make it more readable)
enum ReceivedMessageOption: Int {
    case Nothing = 0
    case Newline = 1
}
class ViewController: UIViewController,DZBluetoothSerialDelegate{

     var str = "1"
    
    @IBOutlet weak var switchBtn: UISwitch!
    @IBAction func ooff(sender: UISwitch) {
        if switchBtn.on{
            if serial.connectedPeripheral == nil {
                
                let alert = UIAlertController(title: "Not connected", message: "What am I supposed to send this to?", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: { action -> Void in self.dismissViewControllerAnimated(true, completion: nil) }))
                presentViewController(alert, animated: true, completion: nil)
                
            }
            
            // send the message to the bluetooth device
            // but fist, add optionally a line break or carriage return (or both) to the message
            let pref = NSUserDefaults.standardUserDefaults().integerForKey(MessageOptionKey)
            var msg = str
            switch pref {
            case MessageOption.Newline.rawValue:
                msg += "\n"
            case MessageOption.CarriageReturn.rawValue:
                msg += "\r"
            case MessageOption.CarriageReturnAndNewline.rawValue:
                msg += "\r\n"
            default:
                msg += ""
            }
            
            // send the message and clear the textfield
            serial.sendMessageToDevice("1")
        }else{
            if serial.connectedPeripheral == nil {
                
                let alert = UIAlertController(title: "Not connected", message: "What am I supposed to send this to?", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: { action -> Void in self.dismissViewControllerAnimated(true, completion: nil) }))
                presentViewController(alert, animated: true, completion: nil)
                
            }
            
            // send the message to the bluetooth device
            // but fist, add optionally a line break or carriage return (or both) to the message
            let pref = NSUserDefaults.standardUserDefaults().integerForKey(MessageOptionKey)
            var msg = str
            switch pref {
            case MessageOption.Newline.rawValue:
                msg += "\n"
            case MessageOption.CarriageReturn.rawValue:
                msg += "\r"
            case MessageOption.CarriageReturnAndNewline.rawValue:
                msg += "\r\n"
            default:
                msg += ""
            }

            // send the message and clear the textfield
            serial.sendMessageToDevice("0")
        }
    }
    @IBAction func off(sender: UIButton) {
        
        if str == "1"{
            
            
        }else{
            if serial.connectedPeripheral == nil {
                
                let alert = UIAlertController(title: "Not connected", message: "What am I supposed to send this to?", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: { action -> Void in self.dismissViewControllerAnimated(true, completion: nil) }))
                presentViewController(alert, animated: true, completion: nil)
                
            }
            
            // send the message to the bluetooth device
            // but fist, add optionally a line break or carriage return (or both) to the message
            let pref = NSUserDefaults.standardUserDefaults().integerForKey(MessageOptionKey)
            var msg = str
            switch pref {
            case MessageOption.Newline.rawValue:
                msg += "\n"
            case MessageOption.CarriageReturn.rawValue:
                msg += "\r"
            case MessageOption.CarriageReturnAndNewline.rawValue:
                msg += "\r\n"
            default:
                msg += ""
            }
            
            // send the message and clear the textfield
            serial.sendMessageToDevice("0")
            
        }
        
        

        
    }
    @IBOutlet weak var ConnectAndDisconnect: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init serial
        serial = DZBluetoothSerialHandler(delegate: self)
        serial.writeWithResponse = NSUserDefaults.standardUserDefaults().boolForKey(WriteWithResponseKey)
        
      
        
    }
    func serialHandlerDidReceiveMessage(message: String) {
        // add the received text to the textView, optionally with a line break at the end
        str += serial.read()
        let pref = NSUserDefaults.standardUserDefaults().integerForKey(ReceivedMessageOptionKey)
        if pref == ReceivedMessageOption.Newline.rawValue { str += "\n" }
      
    }
    
    func serialHandlerDidDisconnect(peripheral: CBPeripheral, error: NSError?) {
        reloadView()
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = MBProgressHUDMode.Text
        hud.labelText = "Disconnected"
        hud.hide(true, afterDelay: 1.0)
    }
    
    func serialHandlerDidChangeState(newState: CBCentralManagerState) {
        if newState != .PoweredOn {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = "Bluetooth turned off"
            hud.hide(true, afterDelay: 1.0)
        }
    }


    @IBAction func Connect(sender: AnyObject) {
        if serial.connectedPeripheral == nil {
            //performSegueWithIdentifier("ShowScanner", sender: self)
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
            self.presentViewController(vc, animated: true, completion: nil)
        } else {
            serial.disconnect()
            reloadView()
        }
    }
    func reloadView() {
        // in case we're the visible view again
        serial.delegate = self
        if serial.connectedPeripheral == nil {
            ConnectAndDisconnect.setTitle( "connect", forState: UIControlState.Normal)
      
        } else {
             ConnectAndDisconnect.setTitle( "disconnect", forState: UIControlState.Normal)
        }
    }
}

