//
//  PostureViewModel.swift
//  Croak
//
//  Created by jeong hyein on 5/16/24.
//

import SwiftUI
import CoreData

class PostureViewModel: ObservableObject {
    @Published var postures: [PosturePer10mData] = []
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchPostures()
    }
    
    func createPosturePer10m(id: UUID, date: String, startTime: String, posture: String, tempDate: Date) {
        let newPosture = PosturePer10mData(context: context)
        newPosture.id = id
        newPosture.date = date
        newPosture.startTime = startTime
        newPosture.posture = posture
        newPosture.tempDate = tempDate
        
        do {
            try context.save()
            fetchPostures() // 데이터가 업데이트된 후에 다시 불러옵니다.
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func fetchPostures() {
        let fetchRequest = PosturePer10mData.fetchRequest() as NSFetchRequest<PosturePer10mData>
        
        do {
            postures = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch postures: \(error)")
            postures = []
        }
    }
}
