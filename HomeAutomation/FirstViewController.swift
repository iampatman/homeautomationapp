//
//  FirstViewController.swift
//  HomeAutomation
//
//  Created by Nguyen Bui An Trung on 27/5/16.
//  Copyright © 2016 Nguyen Bui An Trung. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {
    
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var labelLightStatus: UILabel!
    let maxTemp = 150.0
    let minTemp = 20.0
    var allowNotifying: Bool = false
    var lastTimestamp: Double = 0
    var allowDisplaying: Bool = false
    var list: TempRecords = TempRecords()
    
    @IBOutlet weak var lightSwitch: UISwitch!
    
    var rootRef: FIRDatabaseReference?
    var adcRef: FIRDatabaseReference?
    var ledRef: FIRDatabaseReference?
    var currentTemp: Double = 0 {
        didSet {
            labelTemp.text = NSString(format: "%.2f °C", currentTemp) as String
        }
    }

    var ledStatus: Bool = false {
        didSet {
            labelLightStatus.text = (ledStatus == true ? "On" : "Off")
        }
    }
    
    func showMsg(localNotifi: UILocalNotification){

        //Utils.showMessageBox((localNotifi.alertBody)!, viewController: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootRef = FIRDatabase.database().reference()
        ledRef = rootRef!.child("led")
        ledRef!.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            print(snapshot.value!)
            self.ledStatus = (snapshot.value as! Int) == 1
            self.lightSwitch.setOn(self.ledStatus, animated: true)
            print("Led value: Updated")
            var str = (self.ledStatus == true ? "on" : "off")
            str = "LED status changed to \(str)"
            if (self.allowNotifying == true){
                self.pushLocalNotification(str)
            }
        })
        
        adcRef = rootRef?.child("adc")
        
        let query = adcRef?.queryLimitedToLast(1)
        query?.observeSingleEventOfType(.ChildAdded, withBlock: { (lastValue) in
            print (lastValue.value!)
            let dict = lastValue.value as! [String: AnyObject]
            self.currentTemp = dict["temp"] as! Double
            self.lastTimestamp = dict["timestamp"] as! Double
            print("last value")
            self.adcRef!.observeEventType(.ChildAdded, withBlock: { (newChildAdded) in
                print (newChildAdded.value!)
                let dict = newChildAdded.value as! [String: AnyObject]
                
                print("New child added")
                let data = PiData(dict: dict)
                self.list.append(data)
                
                let timestamp = dict["timestamp"] as! Double
                if (self.allowDisplaying){
                    self.currentTemp = dict["temp"] as! Double
                }
                if (!self.allowDisplaying && self.lastTimestamp == timestamp){
                    self.allowDisplaying = true
                }

                if (self.allowNotifying == true){
                    var strBody = ""
                    if (self.currentTemp > self.maxTemp){
                        strBody = "Current temp is higher than limit: \(self.currentTemp)"
                    } else if (self.currentTemp < self.minTemp) {
                        strBody = "Current temp is lower than limit: \(self.currentTemp)"
                    }
                    self.pushLocalNotification(strBody)
                }
            })

        })
        
                // Do any additional setup after loading the view, typically from a nib.
    }
    
    func pushLocalNotification(alertBody: String){
        let localNotification = UILocalNotification()
        localNotification.alertAction = "Action"
        localNotification.alertBody = alertBody
        localNotification.alertTitle = "HomeAutomation Alert"
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        localNotification.fireDate = NSDate()
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    @IBAction func switchChange(sender: AnyObject) {
        ledRef?.setValue(self.lightSwitch.on)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

