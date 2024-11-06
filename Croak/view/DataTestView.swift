//
//  ContentView.swift
//  Croak
//
//  Created by jeong hyein on 5/11/24.
//

import SwiftUI
import CoreMotion
import UserNotifications
import ActivityKit
import SwiftData
import CoreData

struct DataTestView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\PosturePer10m.date), SortDescriptor(\PosturePer10m.startTime)]) var savedPostureList: [PosturePer10m]
    
    
    let motionManager = CMMotionManager()
    @State private var isPhoneUpsideDown = false
    //    @State private var quaternion: CMQuaternion = CMQuaternion(x: 0, y: 0, z: 0, w: 0)
    
    @State private var rollAngle: Double = 0
    @State private var pitchAngle: Double = 0
    @State private var yawAngle: Double = 0
    
    //    @State var tempDateList: [String] = []
    
    @State var posture: PostureToKor = .NIL
    
    // 현재 시각을 계속 추적하는 타이머
    @State private var timer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()
    //   Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateDate), userInfo: nil, repeats: true)
    
    //    @State var currentDateParam = returnOnlyDateToString(param: Date())
    //    @State var currentStartTimeParam = returnDateToTime(param: Date())
    @State var currentDate = Date()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                
                Text("Roll: \(rollAngle)")
                Text("Pitch: \(pitchAngle)")
                Text("Yaw: \(yawAngle)")
                
                Text("\(posture.rawValue)")
                
                Text("폰 뒤집어짐 여부: \(isPhoneUpsideDown ? "Yes" : "No")")
                
                ForEach(savedPostureList, id: \.id) {
                    el in
                    Text("\(el.date), \(el.startTime), \(el.posture)")
                }

            }
            .onReceive(timer) { _ in
                //                 매 초마다 현재 시간을 확인해서 정각에 맞게 함수를 호출할지 결정
                DispatchQueue.global(qos: .userInteractive).async {
                    performScheduledTask()
                }
            }
            
            .onAppear {
                //requestNotificationAuthorization()
                //                startBackgroundTask()
                //                self.startSensorUpdates()
            }
            .onChange(of: scenePhase) { phase in    // 화면 phase
                switch phase {
                case .active:
                    print("켜짐")
                case .inactive:
                    print("꺼짐")
                case .background:
                    print("백그라운드에서 동작")
                    //                    Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
                    //                                updateSensorDataAndSave()
                    //                        viewModel.createPosturePer10m(id: UUID(), date: returnOnlyDateToString(param: Date()), startTime: returnDateToTime(param: Date()), posture: self.posture.rawValue, tempDate: Date())
                    //                            }
                    
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    //    // 매 10분 정각에 호출하는 함수
    func performScheduledTask() {
        // 현재 시간을 가져와서 분 단위로 확인
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        guard let hour = components.hour, let minute = components.minute else { return }
        
        
        if minute % 10 == 0 {
            //            print("0.5번")
            
            DispatchQueue.global().async {
                startSensorUpdates()
//                updateSensorDataAndSave()
            }
        }
    }
    
    //    func startBackgroundTask() {
    //        DispatchQueue.global(qos: .background).async {
    //            while true {
    //                startSensorUpdates()
    //                sleep(60) // 60초마다 갱신
    //            }
    //        }
    //    }
    
    func startSensorUpdates() {
        
        //        DispatchQueue.global(qos: .userInteractive).sync {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 600 // 초 단위
            motionManager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
                guard let motionData = motionData else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.rollAngle = motionData.attitude.roll * 180 / .pi
                self.pitchAngle = motionData.attitude.pitch * 180 / .pi
                self.yawAngle = motionData.attitude.yaw * 180 / .pi
                
                // 센서 데이터를 사용하여 휴대폰이 뒤집혀있는지 여부를 확인 (가속도 센서 중 z를 이용)
                let gravity = motionData.gravity
                let userAcceleration = motionData.userAcceleration
                let z = gravity.z + userAcceleration.z
                
                
                if (rollAngle < -80 && rollAngle > -110 && pitchAngle < 10 && pitchAngle > -10) {
                    self.posture = PostureToKor.LYING_LEFT
                } else if (rollAngle > 80 && rollAngle < 140 && pitchAngle < 10 && pitchAngle > -10) {
                    self.posture = PostureToKor.LYING_RIGHT
                } else if (rollAngle < 4 && rollAngle > -4 && pitchAngle < 60 && pitchAngle > 30) {
                    self.posture = PostureToKor.SITTING
                } else if (z > 0.9) {
                    self.posture = PostureToKor.LYING
                } else if (z <= 0.9) {
                    self.posture = PostureToKor.LYING_FACE_DOWN
                } else {
                    self.posture = PostureToKor.NOT_AVAILABLE
                }
                

                
                // 휴대폰이 뒤집혀있는지 여부를 판단하는 조건
                self.isPhoneUpsideDown = (z > 0.9) // TODO 임의의 기준값으로 설정, 수정 필요

                
                self.currentDate = Date()

                
                let paramData = PosturePer10m(id: UUID(), date: returnOnlyDateToString(param: self.currentDate), startTime: returnDateToTime(param: self.currentDate), posture: self.posture.rawValue)
                modelContext.insert(paramData)

                
                // 똑같은 자세가 세번 연속인 경우
//                if checkAndNotify(for: savedPostureList) {
//                    showLiveActivityNotification(posture: self.posture)
//                }
//                print("6번")
//                
            }
            
            
            
        } else {
            print("Device motion is not available.")
        }
        //        }
        
        
    }
    
    
    func updateSensorDataAndSave() {
        print(Date())
        
        let paramData = PosturePer10m(id: UUID(), date: returnOnlyDateToString(param: Date()), startTime: returnDateToTime(param: Date()), posture: self.posture.rawValue)
        modelContext.insert(paramData)
        print("Aa")
        writeLog(_writeValue: returnDateToTime(param: self.currentDate))
        
    }
}


