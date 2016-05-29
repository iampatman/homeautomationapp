//
//  Utils.swift
//  HomeAutomation
//
//  Created by Nguyen Bui An Trung on 29/5/16.
//  Copyright © 2016 Nguyen Bui An Trung. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    class func showMessageBox(content: String, viewController: UIViewController){
        let alertPopUp:UIAlertController = UIAlertController(title: "Alert", message: content, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel){
            action -> Void in
        }
        alertPopUp.addAction(cancelAction)
        viewController.presentViewController(alertPopUp, animated: true, completion: nil)
    }
}