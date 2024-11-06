//
//  PostureSnapShot.swift
//  Croak
//
//  Created by Giwoo Kim on 5/18/24.
//

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

class PostureSnapShotModelFromGravity: ObservableObject {
    @Published var savedPostureSnapShotFromGravityList: [PostureSnapShotFromGravity]
    let modelContext: ModelContext
    
    init(savedPostureList: [PostureSnapShotFromGravity], modelContext: ModelContext) {
        self.savedPostureSnapShotFromGravityList = savedPostureList
        self.modelContext = modelContext
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

class PostureSnapShotModelFromAngle: ObservableObject {
    @Published var savedPostureSnapShotFromAngleList: [PostureSnapShotFromAngle]
    let modelContext: ModelContext
    
    init(savedPostureList: [PostureSnapShotFromAngle], modelContext: ModelContext) {
        self.savedPostureSnapShotFromAngleList = savedPostureList
        self.modelContext = modelContext
    }
    
}



