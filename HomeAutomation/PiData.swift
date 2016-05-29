//
//  PiData.swift
//  HomeAutomation
//
//  Created by Nguyen Bui An Trung on 27/5/16.
//  Copyright © 2016 Nguyen Bui An Trung. All rights reserved.
//

import Foundation

class PiData {
    var temp: Int = 0
    var timestamp: CLong = 0
    
    init(){
        
    }
    
    init(dict: [String:AnyObject]){
        temp = dict["temp"] as! Int
        //timestamp = (dict["timestamp"] as? CLong)!
    }
    
    init(temp: Int, time: CLong){
        self.temp = temp
        self.timestamp = time
    }
}