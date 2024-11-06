//
//  PostureFind.swift
//  Croak
//
//  Created by Giwoo Kim on 5/25/24.
//

import Foundation
import CoreMotion
import CoreLocation
import Foundation
import SwiftData

class PostureFind {
    
    var sharedModelContainer: ModelContainer
    
   
    var dailyStat : [DailyStat] = []
    
    
    
    var accelData : [AccelData ] = []
    var posturePer10m : [PosturePer10m] = []
    var postureSnapShotFromGravity : [PostureSnapShotFromGravity] = []
    var postureSnapShotFromAngle : [PostureSnapShotFromAngle] = []
    

    static var continuedPosture : [PostureSnapShotFromGravity] = []
    //for Daily statistics
    static var dailyNotificationCount  =  0
    static var dailyFixCount = 0
    static var dailyNumberOfSit = 0
    static var dailyNumberOfLeftLie = 0
    static var dailyNumberOfRightLie = 0
    
    static var previousNotification = false
    static var previousPosture : String = ""
    var localNotificationManager = LocalNotificationManager.shared
  
    
    init() {
        self.sharedModelContainer = CroakApp().modelContainer
        
        
    }
    func handleMotionData(completionHandler : @escaping () -> Void) {
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
        print("started to run in the PostureFind handler.\(formattedDate)")
        let motionManager = CMMotionManager()
        
        
        // expiration Hanldler must be exist
        
        
        
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
//                    print("accelerometerDataArray 출력")
//                    var count  : Int = 0
//                    for data in accelerometerDataArray {
//                        //  각 축의 가속도 출력
//                        count += 1
//                        print("Accelerometer Data: \(count): T = \(String(format: "%.2f", data.0)), X = \(String(format: "%.2f", data.1)), Y = \(String(format: "%.2f", data.2)), Z = \(String(format: "%.2f", data.3)), RollAngle = \(String(format: "%.2f", data.4)), PitchAngle = \(String(format: "%.2f", data.5))")
//                    }
                    group.leave()
                }
                
                //determine the posture and save it to the data base
                group.notify(queue: .global(qos: .userInteractive)) {
                    
                    print("guessPostureAndSave is started")
                    // guessPostureAndSave  클로져의 기술~~
                     
                    self.guessPostureAndSave(accelerometerDataArray: accelerometerDataArray) {
                        
                        //3개의 연속된 데이타가있으면 자세 교정을 통보  for testing purpose only
                        
                        for i in 0..<PostureFind.continuedPosture.count {
                            print(i, PostureFind.continuedPosture[i].posture)
                            
                        }
                        
                        
                        self.ifBadPostureSendNotificaion()
                        
                    }
                    
                    
                    // after insert we have to save asap and At this time I seperated the insert and the save..
                    accelerometerDataArray.removeAll()
                    // MUST MUST notify to the task
                    // 지금은 조건을 구별해놓고 쓸일이 있을걸로 예상중
                    
                    
                    completionHandler()
                }
            }
            
            
        }
        
    }
    
    func  ifBadPostureSendNotificaion(){
        // 엄밀히 말하면 로직은 단순하고 중복되지만 시간관계상 결과 위주로 꼬고씽
        if PostureFind.continuedPosture.count == 3 {
            print("자세 세번 측정 여기서 통보가능성있음")
            
            if PostureFind.continuedPosture[0].posture == PostureFind.continuedPosture[1].posture , PostureFind.continuedPosture[1].posture == PostureFind.continuedPosture[2].posture {
                
                LocalNotificationManager.shared.pushNotification(title: "하이 버디", subtitle : "관절생각해서 몸좀 움직여봐~~~", body: "자세 좀 바꿔봐요 !!!", seconds: 3, identifier: "POSTURE_CHANGE", repeates: false)
                
                PostureFind.dailyNotificationCount += 1
                let date = returnOnlyDateToString(param: Date())
                // DB update
                
                DispatchQueue.main.async {
                    let newDailyStat = DailyStat(date: date, numberOfWarnings: PostureFind.dailyNotificationCount ,numberOfFix: PostureFind.dailyFixCount ,numberOfSit: PostureFind.dailyNumberOfSit, numberOfLeftLie: PostureFind.dailyNumberOfLeftLie,
                        numberOfRightLie: PostureFind.dailyNumberOfRightLie )
                    
                    let statPredicate = #Predicate<DailyStat> { stat in
                        stat.date == date
                    }
                    do {
                        try self.sharedModelContainer.mainContext.delete(model: DailyStat.self, where: statPredicate)
                    } catch{
                        print("delete error\(error)")
                    }
                    
                    self.sharedModelContainer.mainContext.insert(newDailyStat)
                    do {
                        try  self.sharedModelContainer.mainContext.save()
                    } catch {
                        print("save daily stat error \(error)")
                    }
                }
                PostureFind.previousNotification = true
                
                PostureFind.previousPosture = PostureFind.continuedPosture[0].posture
                //Reset the array
                PostureFind.continuedPosture.removeAll()
                
            } else {
                
                PostureFind.continuedPosture.removeFirst()
                PostureFind.previousPosture = "NIL"
                PostureFind.previousNotification = false
            }
            
        } else if PostureFind.continuedPosture.count == 1 && PostureFind.previousNotification{
            if PostureFind.previousPosture != PostureFind.continuedPosture[0].posture {
         
                PostureFind.dailyFixCount += 1
                let date = returnOnlyDateToString(param: Date())
                
                DispatchQueue.main.async {
                    
                    let newDailyStat = DailyStat(date: date, numberOfWarnings: PostureFind.dailyNotificationCount ,numberOfFix: PostureFind.dailyFixCount ,numberOfSit: PostureFind.dailyNumberOfSit, numberOfLeftLie: PostureFind.dailyNumberOfLeftLie,
                        numberOfRightLie: PostureFind.dailyNumberOfRightLie )
                    
                    let statPredicate = #Predicate<DailyStat> { stat in
                        stat.date == date
                    }
                    do {
                        try self.sharedModelContainer.mainContext.delete(model: DailyStat.self, where: statPredicate)
                    } catch{
                        print("delete error\(error)")
                    }
                    
                    self.sharedModelContainer.mainContext.insert(newDailyStat)
                    do {
                        try  self.sharedModelContainer.mainContext.save()
                    } catch {
                        print("save daily stat error \(error)")
                    }
                }
                
                LocalNotificationManager.shared.pushNotification(title: "하이 버디", subtitle : "관절은 젊을때부터", body: "자세 바꿈 좋아요~~~ ", seconds: 3, identifier: "POSTURE_FIX", repeates: false)
                print("자세교정했다는 알람 통보")
                PostureFind.previousPosture = "NIL"
                PostureFind.previousNotification = false
            }
        } else {
            print("...")
            PostureFind.previousPosture = "NIL"
            PostureFind.previousNotification = false
        }
    }
    func guessPostureAndSave(accelerometerDataArray : [(Double?,Double?,Double?,Double?, Double?, Double?)]? ,
                             completionHandler : @escaping () -> Void){
        
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
            
            if postureGravity == .LYING_LEFT {
                PostureFind.dailyNumberOfLeftLie += 1
            }
            if postureGravity == .LYING_RIGHT {
                PostureFind.dailyNumberOfLeftLie += 1
            }
            if postureGravity == .SITTING {
                PostureFind.dailyNumberOfSit += 1
            }
            // 삭제하고 추가하고 ==> 언제가 업데이트하는 메소드를 찾으면 그때 수정
            let date = returnOnlyDateToString(param: Date())
            DispatchQueue.main.async {
                let newDailyStat = DailyStat(date: date, numberOfWarnings: PostureFind.dailyNotificationCount ,numberOfFix: PostureFind.dailyFixCount ,numberOfSit: PostureFind.dailyNumberOfSit, numberOfLeftLie: PostureFind.dailyNumberOfLeftLie,
                    numberOfRightLie: PostureFind.dailyNumberOfRightLie )
                
                let statPredicate = #Predicate<DailyStat> { stat in
                    stat.date == date
                }
                do {
                    try self.sharedModelContainer.mainContext.delete(model: DailyStat.self, where: statPredicate)
                } catch{
                    print("delete error\(error)")
                }
                
                self.sharedModelContainer.mainContext.insert(newDailyStat)
                do {
                    try  self.sharedModelContainer.mainContext.save()
                } catch {
                    print("save daily stat error \(error)")
                }
            }
            
            
            
            //
            
            
            
            print(("will save postureGravity"))
            group.enter()
            DispatchQueue.global(qos:.userInteractive).async {
                let date = returnOnlyDateToString(param: Date())
                let startTime = returnDateToTime(param: Date())
                
                let newPostureData = PostureSnapShotFromGravity(date: date, startTime: startTime, posture: postureGravity.rawValue)
                // main async에서 충돌 없이 실행되는지 체크 해볼 필요가ㅣ있음..
                // DispatchQueue.global(qos:.userInteractive).async 에서  BAD access에러 발생..어쩌다가 한번
               
                // 사실상 같은건데 다른데서 사용하고 있으니까 그냥 중복해서 쓰는걸로 일종의 오마주
                let newPosture10m = PosturePer10m(id: UUID(), date: date, startTime: startTime, posture: postureGravity.rawValue)
                
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
                
                if PostureFind.continuedPosture.count <= 2 {
                    PostureFind.continuedPosture.append(newPostureData)
                } else {
                    if  PostureFind.continuedPosture.count ==  3 {
                        print("in the closure we'll guess how long the brown stick to one posture")
                    }
                    if PostureFind.continuedPosture.count > 3 {
                        print("index is over the 3 in the PostureFind.continuedPosture.count")
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
            print("All saving tasks are completed")
            // 필요한 후속 작업 수행
            completionHandler()
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
}




