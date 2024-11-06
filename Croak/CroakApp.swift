//
//  CroakApp.swift
//  Croak
//
//  Created by jeong hyein on 5/11/24.
//

import SwiftUI
import SwiftData
import Combine
import FirebaseCore

@main

struct CroakApp: App {


//    @Environment(\.scenePhase) var scenePhase
    
//    let persistenceController = PersistenceController.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate 
    
    var modelContainer: ModelContainer = {
        
        let schema = Schema([PosturePer10m.self , AccelData.self,  PostureSnapShotFromGravity.self , PostureSnapShotFromAngle.self , DailyStat.self ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
           
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
   
    
    var body: some Scene {
        WindowGroup {
     
        MainView()
                .modelContainer(modelContainer)

        }
    }
}
