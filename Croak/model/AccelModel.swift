//
//  AccModel.swift
//  Croak
//
//  Created by Giwoo Kim on 5/18/24.
//

import Foundation
import SwiftData

@Model

final class AccData  {
    
    @Attribute(.unique) var id: UUID
    var date: Date
    var timeStamp: TimeInterval
    var x : Double
    var y : Double
    var z : Double
    var rollAngle: Double
    var pitchAngle: Double
    
    init(date :Date , timeStamp:TimeInterval, x: Double, y:Double, z:Double, rollAngle: Double, pitchAngle: Double){
        self.id = UUID()
        self.date = date
        self.timeStamp = timeStamp
        self.x = x
        self.y = y
        self.z = z
        self.rollAngle = rollAngle
        self.pitchAngle = pitchAngle
       
    }
}

public class DeviceMotionData : ObservableObject{
    
    var date: Date
    var timeStamp: TimeInterval
    
    public var rollAngle : Double
    public var pitchAngle: Double
    public var yawAngle: Double

    init(date:Date , timeStamp:TimeInterval, rollAngle: Double, pitchAngle: Double, yawAngle: Double) {
        self.date  = date
        self.timeStamp = timeStamp
        self.rollAngle = rollAngle
        self.pitchAngle = pitchAngle
        self.yawAngle = yawAngle
       
    }
}
