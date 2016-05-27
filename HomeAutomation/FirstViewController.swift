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
    override func viewDidLoad() {
        super.viewDidLoad()
        rootRef = FIRDatabase.database().reference()
        ledRef = rootRef!.child("led")
        ledRef!.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            print(snapshot.value!)
            self.ledStatus = (snapshot.value as! Int) == 1
            print("Led value: Updated")
        })
        
        adcRef = rootRef?.child("adc")
        adcRef!.observeEventType(.ChildAdded, withBlock: { (newChildAdded) in
            print (newChildAdded.value!)
            let dict = newChildAdded.value as! [String: AnyObject]
            self.currentTemp = dict["temp"] as! Int
            print("New child added")
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

