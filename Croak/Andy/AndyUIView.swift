//
//  SwiftUIView.swift
//  Croak
//
//  Created by Giwoo Kim on 5/20/24.
//

import SwiftUI
import SwiftData
import BackgroundTasks
//여기서 실제 필요할까?




struct AndyUIView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: [SortDescriptor(\PosturePer10m.date), SortDescriptor(\PosturePer10m.startTime)]) var savedPostureList: [PosturePer10m]
    
    @Query(sort: [SortDescriptor(\AccelData.date, order: .reverse), SortDescriptor(\AccelData.timeStamp, order: .reverse)]) var allsavedAccelDataList: [AccelData]
    
    @Query(sort: [SortDescriptor(\PostureSnapShotFromGravity.timeStamp, order: .reverse), SortDescriptor(\PostureSnapShotFromGravity.startTime, order: .reverse)]) var allsavedPostureListfromGravity: [PostureSnapShotFromGravity]
    
    @Query(sort: [SortDescriptor(\PostureSnapShotFromAngle.timeStamp, order: .reverse), SortDescriptor(\PostureSnapShotFromAngle.startTime, order: .reverse)]) var allsavedPostureListfromAngle: [PostureSnapShotFromAngle]
    
    @State var bgTaskPending: [String]? = []
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    var savedAccelDataList: [AccelData] {
        return Array(allsavedAccelDataList.prefix(30))
    }
    
    var savedPostureListFromGravity: [PostureSnapShotFromGravity] {
        return Array(allsavedPostureListfromGravity.prefix(30))
    }
    
    var savedPostureListFromAngle: [PostureSnapShotFromAngle] {
        return Array(allsavedPostureListfromAngle.prefix(30))
    }
    
    @State var accessToken : String = ""
    @State var  fcmToken : String = ""
    var body: some View {
        NavigationStack {
            VStack {
                
               
                List {
                    Section(header: Text("Accelerometer & Angle").font(.caption)) {
                        ForEach(savedAccelDataList) { data in
                            HStack {
                                Text(formattedDate(date: data.date))
                                    .font(.system(size: 12))
                                Text("x: \(String(format: "%.2f", data.x))")
                                    .font(.system(size: 12))
                                Text("y: \(String(format: "%.2f", data.y))")
                                    .font(.system(size: 12))
                                Text("z: \(String(format: "%.2f", data.z))")
                                    .font(.system(size: 12))
                                Text("r: \(String(format: "%.2f", data.rollAngle))")
                                    .font(.system(size: 12))
                                Text("p: \(String(format: "%.2f", data.pitchAngle))")
                                    .font(.system(size: 12))
                            }
                        }
                    }
                }
                
                List {
                    Section(header: Text("Posture from Gravity").font(.caption)) {
                        ForEach(savedPostureListFromGravity) { data in
                            HStack {
                                Text(formattedDate(date: data.timeStamp))
                                    .font(.system(size: 12))
                                Text(data.startTime)
                                    .font(.system(size: 12))
                                Text(data.posture)
                                    .font(.system(size: 12))
                            }
                        }
                    }
                }
                
                List {
                    Section(header: Text("Posture From Angle").font(.caption)) {
                        ForEach(savedPostureListFromAngle) { data in
                            HStack {
                                Text(formattedDate(date: data.timeStamp))
                                    .font(.system(size: 12))
                                Text(data.startTime)
                                    .font(.system(size: 12))
                                Text(data.posture)
                                    .font(.system(size: 12))
                            }
                        }
                    }
                }
            }
            .onAppear {
                // 사용 예시
                
               
                
                
            }
            .navigationTitle("Retrieve the data").font(.subheadline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //
                        bgTaskStart()
                        //   sendRemoteNotificaton()
                    }) {
                        Label("Start", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    
    func bgTaskStart() {
        //
        
              let localNotificationManager = LocalNotificationManager()
       
           
        LocalNotificationManager.shared.pushNotification(title: "Hi Andy", subtitle: "Have a good Day!", body : "What's up?", seconds: 5, identifier: "TEST_NOTIF", repeates: false)
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ko_KR")
                dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let currentTime = Date()
                let koreanTime = dateFormatter.string(from: currentTime)
                print("로칼푸쉬 타임 " ,koreanTime)
            
            
            
        }
        
        
        
    }

#Preview {
    AndyUIView()
}
