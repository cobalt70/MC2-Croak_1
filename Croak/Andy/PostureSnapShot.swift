//
//  PostureSnapShot.swift
//  Croak
//
//  Created by Giwoo Kim on 5/20/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class PostureSnapShotFromGravity{
    var id: UUID
    var timeStamp : Date
    var date : String
    var startTime: String
    var posture: String
  
    
    init(date: String, startTime: String, posture: String) {
        self.id = UUID()
        self.timeStamp =  Date()
        self.date = date
        self.startTime = startTime
        self.posture = posture
    }
}

@Model

class PostureSnapShotFromAngle{
    var id: UUID
    var timeStamp : Date
    var date : String
    var startTime: String
    var posture: String
    
    init(date: String, startTime: String, posture: String) {
        self.id = UUID()
        self.timeStamp =  Date()
        self.date = date
        self.startTime = startTime
        self.posture = posture
    }
}


