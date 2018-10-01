//
//  Util.swift
//  MyMusicPlayer
//
//  Created on 2018/9/30.
//  Copyright © 2018 yume. All rights reserved.
//

import Foundation
import CoreMedia

struct Util {
    
    static func convertCMTimeToSeconds(time : CMTime) -> TimeInterval? {
        guard time.value != 0 && time.timescale != 0 else {
            return nil
        }
        return Double.init(time.value / Int64(time.timescale))
    }
    
    static func convertSecondsForReading(second : Double) -> String {
        
        let date : Date = Date.init(timeIntervalSince1970: second)
        let formatter : DateFormatter = DateFormatter.init()
        
        if second/3600 >= 1 {
            formatter.dateFormat = "HH:mm:ss"
        }
        else {
            formatter.dateFormat = "mm:ss"
        }
        
        let resultTime : String = formatter.string(from: date)
        
        return resultTime
    }
}
