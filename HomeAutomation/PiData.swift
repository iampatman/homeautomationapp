//
//  PiData.swift
//  HomeAutomation
//
//  Created by Nguyen Bui An Trung on 27/5/16.
//  Copyright © 2016 Nguyen Bui An Trung. All rights reserved.
//

import Foundation

class PiData {
    var temp: Int
    var timestamp: Int
    
    init(temp: Int, time: Int){
        self.temp = temp
        self.timestamp = time
    }
}