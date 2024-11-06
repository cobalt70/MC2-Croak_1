

//
//  CroakAppDelegatge.swift
//  Croak
//
//  Created by Giwoo Kim on 5/18/24.


import BackgroundTasks
import CoreMotion
import CoreLocation
import Foundation
import SwiftData
import UIKit
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging
// ...
      
class CroakAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?
    var taskId : String  = "com.giwoo.andy.Croak"
    var granted : Bool = false
    var distance : Double = 0
    var accelData : [AccelData ] = []
 //   var posturePer10m : [PosturePer10m] = []
    var postureSnapShotFromGravity : [PostureSnapShotFromGravity] = []
    var postureSnapShotFromAngle : [PostureSnapShotFromAngle] = []
    var sharedModelContainer: ModelContainer

    var fcmRegTokenMessage : String = ""
    var fcmToken : String = ""
    var accessToken: String = ""
    let localNotificanManager = LocalNotificationManager.shared
    let fcmNotificationManager = FCMNotificationManager.shared
    override init() {
        self.sharedModelContainer = CroakApp().modelContainer
        super.init()
       
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs 토큰 등록 오류: \(error)")
    }
    // Query는 swiftUI에서만 되나????
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
           print("APNs Device Token: \(tokenString)")
        
        // FCM 토큰 요청
        Messaging.messaging().token { token, error in
            if let error = error {
                print("FCM 토큰 오류: \(error)")
            } else if let token = token {
                print("FCM 토큰: \(token)")
                
                self.fcmToken = token
                self.localNotificanManager.fcmToken = token
                self.fcmNotificationManager.fcmToken = token
                // 토큰을 서버로 전송하는 등 필요한 작업 수행
            }
        }
       
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
      print("Firebase registration token: \(String(describing: fcmToken ?? ""))")
      let localNotificationManager = LocalNotificationManager.shared
      localNotificationManager.fcmToken = fcmToken ?? ""
        
      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
      
        self.fcmToken = fcmToken ?? ""
        self.localNotificanManager.fcmToken = fcmToken ?? ""
        self.fcmNotificationManager.fcmToken = fcmToken ?? ""
        print("FCMToken : \(String(describing: fcmToken))")
        
        let fcmClient = FCMNotificationManager.shared
        fcmClient.signInWithEmailAndPassword(email: "giwoo.kim@gmail.com", password: "feng5713!"){ result in
            if let accessToken = result {
                self.accessToken  = accessToken
                self.fcmNotificationManager.accessToken = accessToken ?? ""
                print("accessToken :\(result) \n")
              
            } else {
                self.accessToken = ""
                print("accessToken is nil :\(result) \n")
                    
            }
        }
        
    }

    
    
    func registerBackground() {
        UserDefaults.standard.set(0,forKey: "task_run_count")
        
        let resultRegister =   BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil) { task in
            
            self.handleAppRefresh(task: task as! BGProcessingTask) {
                
                let count = UserDefaults.standard.integer(forKey: "task_run_count")
                
                print("BGTask is runned \(count) times")
                //하루 기준으로 테스트한다고 가정
                if count < 5 {
                    
                    print("Keep load the BGTask continuously ")
                    
                    self.scheduleAppRefreshIfNotScheduled()
                    
                } else {
                    print("Today we did all the BGTask enough")
                    
                }
                
            }
            
        } // Register Task
        if resultRegister == true {
            print("task registered successfully")
        } else {
            print("task register failure")
            
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
            // 앱 종료 시 수행할 작업
        print("App will be terminated soon")
        LocalNotificationManager.shared.removeAllNotifications()
       
        }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //        registerBackground()
        
        FirebaseApp.configure()
        
        LocalNotificationManager.shared.setAuthorization()
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
      
//
//        let calendar = Calendar.current
//        let endOfDay = Date.now
//        let startOfDay = calendar.date(byAdding: .hour, value: -12, to: endOfDay)!
//        
//        let startOfDayString  = returnOnlyDateToString(param: startOfDay)
//        let endOfDayString =  returnOnlyDateToString(param: endOfDay)
//        print("start Of Day",startOfDayString, "end Of Day " , endOfDayString)
//        
//        let group = DispatchGroup()
//        //
//        group.enter()
//        DispatchQueue.global(qos:.userInteractive).async {
//            
//            do {
//                
//                var descriptor = FetchDescriptor<AccelData>(
//                    predicate: #Predicate { $0.date  >= startOfDay && $0.date <= endOfDay
//                    },
//                    sortBy: [
//                        SortDescriptor(\AccelData.date, order: .reverse)
//                    ]
//                )
//                descriptor.fetchLimit = 20
//                try self.accelData = self.sharedModelContainer.mainContext.fetch(descriptor)
//                self.showAccelData()
//                } catch{
//                print("SwitData retrieving error")
//            }
//            group.leave() // group leave() should be in the DispatchQueue{}
//        }
//        
//          
//            group.enter() // group leave() should be in the DispatchQueue{}
//            DispatchQueue.global(qos:.userInteractive).async {
//               
//                do {
//                    
//                    var descriptor = FetchDescriptor< PostureSnapShotFromGravity>(
//                        predicate: #Predicate { $0.timeStamp  >= startOfDay && $0.timeStamp <= endOfDay
//                        },
//                        sortBy: [
//                            SortDescriptor(\PostureSnapShotFromGravity.timeStamp, order: .reverse)
//                        ]
//                    )
//                    descriptor.fetchLimit = 20
//                    try self.postureSnapShotFromGravity = self.sharedModelContainer.mainContext.fetch(descriptor)
//                    self.showPostureDataFromGravity()
//                } catch{
//                    print("SwitData retrieving error PostureDataFromGravity")
//                }
//               group.leave() // group leave() should be in the DispatchQueue{}
//            }
//        
//            
//            group.enter()
//            
//            DispatchQueue.global(qos:.userInteractive).async {
//                
//                do {
//                    
//                    var descriptor = FetchDescriptor< PostureSnapShotFromAngle>(
//                        predicate: #Predicate { $0.timeStamp  >= startOfDay && $0.timeStamp <= endOfDay
//                        },
//                        sortBy: [
//                            SortDescriptor(\PostureSnapShotFromAngle.timeStamp, order: .reverse)
//                        ]
//                    )
//                    descriptor.fetchLimit = 20
//                    try self.postureSnapShotFromAngle = self.sharedModelContainer.mainContext.fetch(descriptor)
//                    self.showPostureDataFromAngle()
//                } catch{
//                    print("SwitData retrieving error from PostureDataFromAngle")
//                }
//                group.leave() // group leave() should be in the DispatchQueue{}
//            }
//        
//        
//        group.notify(queue: .global(qos: .userInteractive)) {
//            
//            print(" all tasks are executed separately")
//            
//            
//            let count =  UserDefaults.standard.integer(forKey: "task_run_count")
//            if count == 0  {
//                print("First schedule is loaded, later scheduler will be called at the closure")
//                self.scheduleAppRefreshIfNotScheduled()
//            }
//            
//          
//        }
        return true
    }
    
    // for showing the accelData in the Database upto 100  for test purpose
    func showAccelData() {
        // DateFormatter 생성
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short  // 짧은 날짜 형식
        dateFormatter.dateFormat =  "MM-dd HH:mm:ss" // 시간 표시 없음
        
        for data in self.accelData {
            let formattedDate = dateFormatter.string(from: data.date)
            let formattedT = String(data.timeStamp)
            let formattedX = String(format: "%.2f", data.x)
            let formattedY = String(format: "%.2f", data.y)
            let formattedZ = String(format: "%.2f", data.z)
            print("Accelerometer: Date: \(formattedDate), t: \(formattedT), x: \(formattedX), y: \(formattedY), z: \(formattedZ)")
        }
    }
    
    func showPostureDataFromGravity()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short  // 짧은 날짜 형식
        dateFormatter.dateFormat =  "MM-dd HH:mm:ss"
        
        for data in self.postureSnapShotFromGravity {
            
            
            let formattedDate = dateFormatter.string(from:data.timeStamp )
            
            print("FromGravity: timeStamp:\(formattedDate) Date:\(data.date) startTime:\(data.startTime)  posture:\(data.posture)")
        }
        
        
    }
    
    func showPostureDataFromAngle()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short  // 짧은 날짜 형식
        dateFormatter.dateFormat =  "MM-dd HH:mm:ss"
        
        for data in self.postureSnapShotFromAngle {
            
            
            let formattedDate = dateFormatter.string(from:data.timeStamp )
            
            print("FromAngle: timeStamp:\(formattedDate) Date:\(data.date) startTime:\(data.startTime)  posture:\(data.posture)")
        }
        
        
    }
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        //for test purpose
        print("application Did Enter Background---")
        BGTaskScheduler.shared.getPendingTaskRequests(completionHandler: { taskRequests in
            for taskRequest in taskRequests {
                print("we have \(taskRequest.identifier)  pending BGTask ")
            }
        })
        
        
        
    }
    //debugging expression
    //e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.giwoo.andy.Croak"]
   // e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"com.giwoo.andy.Croak"]
    
    
    func scheduleAppRefresh() {
       
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let localTime = dateFormatter.string(from: now)
        let count = UserDefaults.standard.integer(forKey: "task_run_count")
        
        
       
        let request = BGProcessingTaskRequest(identifier: taskId)
        request.requiresExternalPower = false
        request.requiresNetworkConnectivity = false
      
        let requestedDate = Date(timeIntervalSinceNow: 60*10)
        
        request.earliestBeginDate = requestedDate
  
        
        let requestedTime = dateFormatter.string(from: request.earliestBeginDate! )
        
        do {
            try BGTaskScheduler.shared.submit(request)
            
        } catch {
            print("BGTask submit error : \(error)")
        }
        
        print("\(count) BGTask request is submitted  at \(localTime) and scheduled at \(requestedTime)")
        
        BGTaskScheduler.shared.getPendingTaskRequests { taskRequests in
            print("Number of pending tasks : ", taskRequests.count, taskRequests)
        }
            
    }
    
    func scheduleAppRefreshIfNotScheduled() {
        
        BGTaskScheduler.shared.getPendingTaskRequests { taskRequests in
            
            print("Number of pending tasks : ", taskRequests.count)
            
            let isTaskAlreadyScheduled = taskRequests.contains { taskRequest in
                
                return taskRequest.identifier == self.taskId
            }
            
            if !isTaskAlreadyScheduled {
                print("No pending BGTask, we will schedule the BGTask.")
                self.scheduleAppRefresh()
            }
            else {
                let count = UserDefaults.standard.integer(forKey: "task_run_count")
                if count == 0 {
                    print("There is a pending BGTask on start, we will empty it.")
                    BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: self.taskId)
                    self.scheduleAppRefresh()
                } else {
                    print("Wait till pending BGTask is finished.")
                }
            }
        }
    }
    
    
    func handleAppRefresh(task: BGProcessingTask , completion : @escaping () -> Void) {
        //for later use to check if the motionManager is completed
        // for later use if we try to do a multiple bgground task
        
        var motionTaskCompleted = false
        var accelerometerDataArray: [(Double, Double, Double, Double, Double, Double)] = []
        
        let tmpcount = UserDefaults.standard.integer(forKey: "task_run_count")
        UserDefaults.standard.set(tmpcount+1, forKey: "task_run_count")
        let count = UserDefaults.standard.integer(forKey: "task_run_count")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short  // 짧은 날짜 형식
        dateFormatter.dateFormat =  "MM-dd HH:mm:ss" // 시간 표시 없음
        let formattedDate = dateFormatter.string(from: Date.now)
        print("\(count)th BGTask is started to run in the handler.\(formattedDate)")
        let motionManager = CMMotionManager()
        
        
        // expiration Hanldler must be exist
        task.expirationHandler = {
            // 작업이 만료되었을 때 수행할 작업을 정의합니다.
            print("Background task expired  unintentionally")
            // MUST MUST
            task.setTaskCompleted(success: false)
            if motionManager.isAccelerometerActive {
                motionManager.stopAccelerometerUpdates()
            }
        }
        
        
        if motionManager.isAccelerometerAvailable {
            
            print("isAccelerometerAvailable" , motionManager.isAccelerometerAvailable)
        } else {
            print("we can't process the task, hardware failure")
            return
        }
        if motionManager.isAccelerometerActive {
            print("isAccelerometerActive" , motionManager.isAccelerometerActive )
        }
        else {
            print("Next step, it will be activated " , motionManager.isAccelerometerActive )
        }
        
        
        motionManager.accelerometerUpdateInterval = 0.2
      
        let operationQueue = OperationQueue()
       
        operationQueue.qualityOfService = .userInteractive
        
        motionManager.startAccelerometerUpdates(to: operationQueue ) {(accelerometerData, error) in
            
            if let accelerometerData = accelerometerData {
                // 수집된 데이터 처리
                let accelerationX = accelerometerData.acceleration.x
                let accelerationY = accelerometerData.acceleration.y
                let accelerationZ = accelerometerData.acceleration.z
                let accelerationT = accelerometerData.timestamp
                //여기서 각도 계산해서 디비에 저장하자..
                //asin의 정의역 [-1,1]과 atan값의 cos(theta)가 0이 될때 예외상황 고려
                //Accelerometor 데이터에 비해 민감한 이유는 뭘까 ?
                
                let rollAngle = asin(accelerationX  > 1 ? 1 : (accelerationX  < -1 ? -1 : accelerationX  )) * 180 / .pi
                let pitchAngle = self.atanForSmallZ(y: accelerationY , z: accelerationZ )  * 180 / .pi
                
                accelerometerDataArray.append((accelerationT, accelerationX,accelerationY, accelerationZ, rollAngle, pitchAngle))
                
                let group = DispatchGroup()
                group.enter()
                // 일단 여기는 background로 해도에러가 나지 않았음...  main.async는 사용하지 않는걸로
                // 여차하면 main.async로 수정..아무래도 여기서 비면
                DispatchQueue.main.async {
                    let newAccelData  = AccelData(date: Date.now, timeStamp: accelerationT, x: accelerationX, y: accelerationY, z: accelerationZ, rollAngle: rollAngle, pitchAngle:  pitchAngle)
                    
                    self.sharedModelContainer.mainContext.insert(newAccelData)
     
                    print("save the accelerometer data")
                    do {
                        try self.sharedModelContainer.mainContext.save()
                    }catch {
                        print("saving error \(error)")
                    }
                    group.leave()
                }
           // 작업 완료 표시
            print("insert accelData finished")
            } else if let error  = error {
                // 가속도 데이터를 읽을 수 없는 경우
                print("error in the accelerometer:  \(String(describing: error))")
            }
            else{
                print("No accelerometer data and no error")
                
            }
            //  최소 10 개의 데이타를 저장하고 저장된 데이타로 Posture를 판단하고 Posture는 한개만 저장
            if accelerometerDataArray.count >= 10 {
                // DispatchQueue를 사용하여 비동기적으로 데이터 처리
               
                
                
                if motionManager.isAccelerometerActive {
                    motionManager.stopAccelerometerUpdates()
                }
                let group = DispatchGroup()
                group.enter()
                DispatchQueue.global(qos:.userInteractive).async {
                    print("accelerometerDataArray 출력")
                    var count  : Int = 0
                    for data in accelerometerDataArray {
                        //  각 축의 가속도 출력
                        count += 1
                        print("Accelerometer Data: \(count): T = \(String(format: "%.2f", data.0)), X = \(String(format: "%.2f", data.1)), Y = \(String(format: "%.2f", data.2)), Z = \(String(format: "%.2f", data.3)), RollAngle = \(String(format: "%.2f", data.4)), PitchAngle = \(String(format: "%.2f", data.5))")
                    }
                    group.leave()
                }
                
                //determine the posture and save it to the data base
                group.notify(queue: .global(qos: .userInteractive)) {
                   
                    print("guessPostureAndSave is completing")
                    // guessPostureAndSave
                    self.guessPostureAndSave(accelerometerDataArray: accelerometerDataArray)
                    print("\(count)th BGTask is completed successufully ")
                    motionTaskCompleted = true
                    //배열 비우기
                    // after insert we have to save asap and At this time I seperated the insert and the save..
                    accelerometerDataArray.removeAll()
                    // MUST MUST notify to the task
                    // 지금은 조건을 구별해놓고 쓸일이 있을걸로 예상중
                    task.setTaskCompleted(success: true)
                    
                    completion()
                }
            }
            
            
        }
        
   }
    
    
    
    func guessPostureAndSave(accelerometerDataArray : [(Double?,Double?,Double?,Double?, Double?, Double?)]?){
        
        var postureArrayGravity : [PostureToKor] = []
        var postureArrayAngle : [PostureToKor] = []
      //  var posture : PostureToKor?
        guard let accelerometerDataArray = accelerometerDataArray else {
            return
        }
        for data in accelerometerDataArray {
            if let x = data.1 , let y = data.2,  let z = data.3 {
                postureArrayGravity.append(guesspostureFromGravity(x: x, y: y, z:z))
          
            }
        }
        for data in accelerometerDataArray {
            if  let z = data.3 , let rollAngle = data.4 , let pitchAngle = data.5 {
                
//                let gravityAcceleration = 9.8 // 중력가속도, 단위: m/s^2  9.8m/sec^2 == 1로 가정했음
           
                
                //  혹시 에러 나면 x의 정의역 문제니..그때가서 생각해.
                
//                let rollAngle = asin(x > 1 ? 1 : (x < -1 ? -1 : x ))
//
//                let pitchAngle = atanForSmallZ(y: y , z: z )
//
//
//
//
//                print("roll : " , rollAngle * 180 / Double.pi)
//                print("pitch: " , pitchAngle * 180 / Double.pi)
//
                
                postureArrayAngle.append( guessPostureFromAngle(rollAngle: rollAngle, pitchAngle: pitchAngle , yawAngle: Double(0), z:z))
                
            //    postureArrayAngle.append(guesspostureFromAngle(x: x, y: y, z:z)),
            }
        }
  
        /*
//
//        class PostureSnapShot {
//            var id: UUID
//            var timeStamp : Date
//            var date : String
//            var startTime: String
//            var posture: String
//
//            init(date: String, startTime: String, posture: String) {
//                self.id = UUID()
//                self.timeStamp =  Date()
//                self.date = date
//                self.startTime = startTime
//                self.posture = posture
//            }
//        }
         */
        
        let group = DispatchGroup()

        if let postureGravity = maxPosture(postureArray: postureArrayGravity) {
           
            print(("will save postureGravity"))
            group.enter()
            DispatchQueue.global(qos:.userInteractive).async {
                let date = returnOnlyDateToString(param: Date())
                let startTime = returnDateToTime(param: Date())
                
                let newPostureData = PostureSnapShotFromGravity(date: date, startTime: startTime, posture: postureGravity.rawValue)
                // main async에서 충돌 없이 실행되는지 체크 해볼 필요가ㅣ있음..
                // DispatchQueue.global(qos:.userInteractive).async 에서  BAD access에러 발생..어쩌다가 한번
                DispatchQueue.main.async {
                    self.sharedModelContainer.mainContext.insert(newPostureData)
                    
                    do {
                        print("Attempting to save context for PostureSnapShotFromGravity")
                        try self.sharedModelContainer.mainContext.save()
                        print("Successfully saved context for PostureSnapShotFromGravity")
                    } catch {
                        print("Failed to save context:PostureSnapShotFromGravity \(error)")
                    }
                }
                group.leave()
            }
        }

        if let postureAngle = maxPosture(postureArray: postureArrayAngle) {
            print(("will save postureAngle"))
            group.enter()
            DispatchQueue.global(qos:.userInteractive).async {
               
                let date = returnOnlyDateToString(param: Date())
                let startTime = returnDateToTime(param: Date())
                
                let newPostureData = PostureSnapShotFromAngle(date: date, startTime: startTime, posture: postureAngle.rawValue)
               //insert 와 save는 main.async에서 처리를 해보는걸로  BAD ACCESS ERROR 발생
                DispatchQueue.main.async {
                self.sharedModelContainer.mainContext.insert(newPostureData)
                    do {
                        print("Attempting to save context for PostureSnapShotFromAngle")
                        try self.sharedModelContainer.mainContext.save()
                        print("Successfully saved context for PostureSnapShotFromAngle")
                    } catch {
                        print("Failed to save context:PostureSnapShotFromAngle \(error)")
                    }
                }
                group.leave()
            }
        }

        // 모든 비동기 작업이 완료된 후 실행할 코드
        
        group.notify(queue: .global(qos: .userInteractive)) {
            print("All tasks are completed")
            // 필요한 후속 작업 수행
        }

       
    
    }//func
    
    func atanForSmallZ(y: Double, z: Double) -> Double {
        let epsilon = 0.000001 // 아주 작은 값의 임계값 설정
        let piOverTwo = Double.pi / 2.0
        
        // x가 아주 작은 값인 경우 예외 처리
        if abs(z) < epsilon {
            if y < 0 {
                // y가 음수인 경우
                return -piOverTwo
            } else {
                // y가 양수인 경우
                return piOverTwo
            }
        } else {
            // 일반적인 경우 atan 함수 사용
            return atan(y/z)
        }
    }

    func maxPosture(postureArray : [PostureToKor]? ) -> PostureToKor?{
        var postureCounts = [PostureToKor: Int]()

        guard let postureArray = postureArray else {
            return nil
        }
        for pos in postureArray {
            
            if let count = postureCounts[pos] {
                postureCounts[pos] = count + 1
            } else {
                postureCounts[pos] = 1
            }
        }

        // 빈도수가 가장 높은 자세 찾기
        var maxPosture: PostureToKor?
        var maxCount = 0

        for (pos, count) in postureCounts {
            if count > maxCount {
                maxPosture = pos
                maxCount = count
            }
        }
     
        if let maxPosture = maxPosture {
            print("가장 빈도가 높은 자세: \(maxPosture)")
        } else {
            print("자세 데이터가 비어있습니다.")
        }
        if maxCount > 0 { return maxPosture}
        else {return nil}
        
    }
}
    
 

/*
Launch a Task
To launch a task:
Set a breakpoint in the code that executes after a successful call to submit(_:).
Run your app on a device until the breakpoint pauses your app.
In the debugger, execute the line shown below, substituting the identifier of the desired task for TASK_IDENTIFIER.
Resume your app. The system calls the launch handler for the desired task.
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"TASK_IDENTIFIER"]
 
Force Early Termination of a Task
To force termination of a task:
Set a breakpoint in the desired task.
Launch the task using the debugger as described in the previous section.
Wait for your app to pause at the breakpoint.
In the debugger, execute the line shown below, substituting the identifier of the desired task for TASK_IDENTIFIER.
Resume your app. The system calls the expiration handler for the desired task.
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"TASK_IDENTIFIER"]
*/

    
 
