//
//  TempRecords.swift
//  HomeAutomation
//
//  Created by Nguyen Bui An Trung on 27/5/16.
//  Copyright © 2016 Nguyen Bui An Trung. All rights reserved.
//

import Foundation

class TempRecords {
    var list: [PiData] = [PiData]()
    
    init(){
        
    }
    
    func append(data: PiData){
        list.append(data)
    }
    
    func last(number: Int) -> [PiData]{
        let length = list.count
        if (length  < number){
            return []
        }
        let data = list[length-number...length-1]
        return Array(data)
        
    }
}