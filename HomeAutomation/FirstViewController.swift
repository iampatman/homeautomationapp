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
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRApp.configure()
        var ref = FIRDatabase.database().reference()
        print (ref.URL)
        ref.observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) in
            let postDict = snapshot.value as! [String : AnyObject]
            print("Event")
            print(postDict)
            // ...
        })
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

