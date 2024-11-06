//
//  AppDelegate.swift
//  Croak
//
//  Created by jeong hyein on 5/14/24.
//

import SwiftUI
//import SwiftData
import Combine

class AppDelegate: UIResponder, UIApplicationDelegate {
//    @Environment(\.modelContext) var modelContext
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var timer: Timer?
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        registerBackgroundTask()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        endBackgroundTask()
    }

    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }

        assert(backgroundTask != .invalid)

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let currentTime = Date()
            print("Current Time: \(currentTime)")
//            modelContext.insert(tempDateModel(id: UUID(), tempDate: currentTime))
        }
    }

    func endBackgroundTask() {
        timer?.invalidate()
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
}
