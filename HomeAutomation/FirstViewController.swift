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
    let maxTemp = 150
    let minTemp = 20
    var allowNotifying: Bool = false
    
    var list: TempRecords = TempRecords()
    
    @IBOutlet weak var lightSwitch: UISwitch!
    
    var rootRef: FIRDatabaseReference?
    var adcRef: FIRDatabaseReference?
    var ledRef: FIRDatabaseReference?
    var currentTemp: Int = 0 {
        didSet {
            labelTemp.text = String(currentTemp)
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
        adcRef!.observeEventType(.ChildAdded, withBlock: { (newChildAdded) in
            print (newChildAdded.value!)
            let dict = newChildAdded.value as! [String: AnyObject]
            self.currentTemp = dict["temp"] as! Int
            print("New child added")
            let data = PiData(dict: dict)
            self.list.append(data)
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

