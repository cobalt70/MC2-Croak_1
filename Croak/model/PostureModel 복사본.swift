//
//  PostureModel.swift
//  Croak
//
//  Created by jeong hyein on 5/11/24.
//

import SwiftUI
import SwiftData

@Model
class PosturePer10m {
    var id: UUID
    var date: String
    var startTime: String
    var posture: String
    
    init(id: UUID, date: String, startTime: String, posture: String) {
        self.id = id
        self.date = date
        self.startTime = startTime
        self.posture = posture
    }
}




class PostureModel: ObservableObject {
    @Published var savedPostureList: [PosturePer10m]
    let modelContext: ModelContext
    
    init(savedPostureList: [PosturePer10m], modelContext: ModelContext) {
        self.savedPostureList = savedPostureList
        self.modelContext = modelContext
    }
    
//    func deleteDream(dream: Dream) {
//        for (index, groupedDream) in tempDreamDataList.enumerated() {
//            if let dreamIndex = groupedDream.dreamList.firstIndex(of: dream) {
//                tempDreamDataList[index].dreamList.remove(at: dreamIndex)
//                if tempDreamDataList[index].dreamList.isEmpty {
//                    modelContext.delete(groupedDream)
//                }
//                return
//            }
//        }
//    }
}
