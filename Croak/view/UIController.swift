//
//  UIController.swift
//  Croak
//
//  Created by jeong hyein on 5/14/24.
//

import SwiftUI
import UIKit
import SwiftData
import CoreData

//struct ViewControllerRepresentable: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> ViewController {
//        return ViewController(PostureViewModel(context: context))
//    }
//
//    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
//        // Update the UIViewController if needed
//    }
//}
//
//class ViewController: UIViewController {
////    @StateObject private var viewModel: PostureViewModel
//    
////    init(context: NSManagedObjectContext) {
////        _viewModel = StateObject(wrappedValue: PostureViewModel(context: context))
////    }
//    
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
//
//    var viewModel = PostureViewModel
//
//    
//    var mainView: MainView?
//    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
//    var timer: Timer?
//    var timeLabel: UILabel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateDate), userInfo: nil, repeats: true)
////        setupTimeLabel()
////        registerBackgroundTask()
//    }
//
//    @objc func updateDate() {
//        print("update")
//        let context = persistentContainer.viewContext
//        let viewModel = PostureViewModel(context: context)
//        viewModel.createPosturePer10m(id: UUID(), date: returnOnlyDateToString(param: Date()), startTime: returnDateToTime(param: Date()), posture: "aaa", tempDate: Date())
//    }
//    func setupTimeLabel() {
//        // UILabel 생성 및 초기 설정
//        timeLabel = UILabel()
//        timeLabel.translatesAutoresizingMaskIntoConstraints = false
//        timeLabel.textAlignment = .center
//        timeLabel.font = UIFont.systemFont(ofSize: 32)
//        
//        // UILabel을 ViewController의 view에 추가
//        view.addSubview(timeLabel)
//        
//        // UILabel의 제약 조건 설정
//        NSLayoutConstraint.activate([
//            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//
////    func registerBackgroundTask() {
////        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
////            self?.endBackgroundTask()
////        }
////
////        assert(backgroundTask != .invalid)
////
////        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
////            guard let self = self else { return }
////            // 현재 시간을 가져오는 로직
////            let currentTime = Date()
////            let dateFormatter = DateFormatter()
////            dateFormatter.timeStyle = .medium
////            let timeString = dateFormatter.string(from: currentTime)
////            
////            // UILabel의 텍스트 갱신
////            DispatchQueue.main.async {
////                self.timeLabel.text = "Current Time: \(timeString)"
////                self.mainView?.updateSensorDataAndSave()
////                print("cc")
////            }
////
////                let paramData = PosturePer10m(id: UUID(), date: "2", startTime: "1", posture: "Aa", tempDate: Date())
////                self.modelContext.insert(paramData)
////                print("A")
////            
////        }
////    }
//
//    func endBackgroundTask() {
//        timer?.invalidate()
//        UIApplication.shared.endBackgroundTask(backgroundTask)
//        backgroundTask = .invalid
//    }
//    
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "PosturePer10mData")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//}
