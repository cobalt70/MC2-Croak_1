//
//  SummaryView.swift
//  Croak
//
//  Created by jeong hyein on 5/17/24.
//

import SwiftUI
import SwiftData
import Foundation

struct SummaryView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: [SortDescriptor(\DailyStat.date) ]) var dailyStat: [DailyStat]

    @State var numberOfWarnings : Int?
    @State var numberOfFix : Int?
    @State var rateOfFix : Double?
    @State var numberOfSit : Int?
    @State var numberOfLeftLie : Int?
    @State var numberOfRightLie: Int?
    @State var firstPosture : Int?
    @State var seconPosture: Int?
    @State var thirdPosture:Int?
    @State var firstPostureString: String? = "앉은자세"
    @State var seconPostureString: String? = "왼쪽으로 누운자세"
    @State var thirdPostureString: String? = "오른쪽으로 누운자세"
    var status : Bool = true
    var body: some View {
    
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment:.leading){
                        
// 오늘 날짜
                        Text("\(todayMonth())월 \(todayDay())일 \(todayWeek())")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 0.68, green: 0.68, blue: 0.68))
                            .padding(.bottom,4)
                        
// 상태
                        if status == true {
                            VStack(alignment: .leading) {
                                Text("오늘 브라운님의 자세는")
                                    .font(.system(size: 24, weight: .semibold))
                                    .kerning(0.4)
                                HStack {
                                    Text("주의 요함")
                                        .font(.system(size: 24, weight: .semibold))
                                        .kerning(0.4)
                                        .foregroundColor(Color(red: 1, green: 0.39, blue: 0))
                                    Text("입니다")
                                        .font(.system(size: 24, weight: .semibold))
                                        .kerning(0.4)
                                    Spacer()
                                }
                            }
                            .padding(.bottom, 20)
                            Image("Badsign")
                                .padding(.leading, 180)
                            ZStack(alignment: .leading){
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 353, height: 6)
                                    .background(Color(red: 0.61, green: 0.61, blue: 0.61).opacity(0.2))
                                    .cornerRadius(100)
                                Image("StatusBarbad")
                            }
                            .padding(.bottom, 16)
                            } else {
                                VStack(alignment: .leading) {
                                    Text("오늘 브라운님의 자세는")
                                        .font(.system(size: 24, weight: .semibold))
                                        .kerning(0.4)
                                    HStack {
                                        Text("매우 좋음")
                                            .font(.system(size: 24, weight: .semibold))
                                            .kerning(0.4)
                                            .foregroundColor(Color("CroakGreen"))
                                        Text("입니다")
                                            .font(.system(size: 24, weight: .semibold))
                                            .kerning(0.4)
                                        Spacer()
                                    }
                                }
                                .padding(.bottom, 20)
                                Image("Goodsign")
                                ZStack(alignment: .leading){
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 353, height: 6)
                                        .background(Color(red: 0.61, green: 0.61, blue: 0.61).opacity(0.2))
                                        .cornerRadius(100)
                                    Image("StatusBargood")
                                }
                                .padding(.bottom, 16)
                            }
                            
                        
// 알림 횟수, 이행 횟수, 이행율 정보
                            HStack(alignment:.center){
                                Spacer()
                                VStack(spacing: 6){
                                    Text("알림 횟수")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(red: 0.69, green: 0.69, blue: 0.69))
                                    Text("\(String(describing: numberOfWarnings ?? 0))")
                                        .font(.system(size: 26, weight: .bold))
                                        .opacity(0.8)
                                }
                                Spacer()
                                Divider()
                                    .foregroundColor(.black.opacity(0.1))
                                    .frame(width: 1, height: 60)
                                Spacer()
                                VStack(spacing: 6){
                                    Text("이행 횟수")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(red: 0.69, green: 0.69, blue: 0.69))
                                    Text("\(numberOfFix ?? 0)")
                                        .font(.system(size: 26, weight: .bold))
                                        .opacity(0.8)
                                }
                                Spacer()
                                Divider()
                                    .foregroundColor(.black.opacity(0.1))
                                    .frame(width: 1, height: 60)
                                Spacer()
                                VStack(spacing: 6){
                                    Text("이행율")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(red: 0.69, green: 0.69, blue: 0.69))
                                    
                                    
                                    if let rate = rateOfFix {
                                        Text("\(String(format: "%.0f", rate))%")
                                            .font(.system(size: 26, weight: .bold))
                                            .opacity(0.8)
                                            .foregroundColor(Color("CroakGreen"))
                                    } else {
                                        Text("미정")    .font(.system(size: 26, weight: .bold))
                                            .opacity(0.8)
                                            .foregroundColor(Color("CroakGreen"))
                                        
                                    }
                                       
                                }
                                Spacer()
                                
                            }
                            .padding(.vertical, 10)
                            .background(.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .inset(by: 0.5)
                                    .stroke(.black.opacity(0.05), lineWidth: 1)
                            )
                            .padding(.bottom, 20)
                        
// 오늘 나의 주요자세
                            
                            VStack(alignment: .leading){
                                Text("오늘 나의 주요 자세")
                                    .font(.system(size: 20, weight: .bold))
                                    .padding(.top,4)
                                Text(firstPostureString ?? "")
                                    .font(.system(size: 14, weight: .bold))
                                    .padding(.top,6)
                                    .foregroundColor(Color(red: 1, green: 0.39, blue: 0))
                                Image("Image")
                                    .padding(.top,10)
                                    .padding(.bottom,20)
                                Text("물가에 부족 인터넷의 자전거를 비추다. 현상의 개장의 앞두던 속에 기업체가 정치를 전달하다. 거기의 그러나 오후로 소개하게 많이 이뤄지다. ")
                                    .font(.system(size: 14, weight: .medium))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color(red: 0.15, green: 0.67, blue: 0.45))
                                    .padding(10)
                                    .background(Color(red: 0.92, green: 0.98, blue: 0.95))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .inset(by: 0.5)
                                            .stroke(Color(red: 0.75, green: 0.95, blue: 0.87))
                                    )
                                Divider()
                                    .padding(.vertical, 16)
                                Text("오늘 나의 자세 랭킹")
                                    .font(.system(size: 20, weight: .bold))
                                    .padding(.top,4)
                                HStack(spacing: 16){
                                    Text("1")
                                        .font(.system(size: 14, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.36, green: 0.36, blue: 0.36))
                                        .frame(width: 20, height: 20)
                                        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                                        .cornerRadius(60)
                                    Text(firstPostureString ?? "")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(red: 0.36, green: 0.36, blue: 0.36))
                                }
                                HStack(spacing: 16){
                                    Text("2")
                                        .font(.system(size: 14, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.36, green: 0.36, blue: 0.36))
                                        .frame(width: 20, height: 20)
                                        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                                        .cornerRadius(60)
                                    Text(seconPostureString ?? "")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(red: 0.36, green: 0.36, blue: 0.36))
                                }
                                HStack(spacing: 16){
                                    Text("3")
                                        .font(.system(size: 14, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color(red: 0.36, green: 0.36, blue: 0.36))
                                        .frame(width: 20, height: 20)
                                        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                                        .cornerRadius(60)
                                    Text(thirdPostureString ?? "")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(red: 0.36, green: 0.36, blue: 0.36))
                                }
                            }
                            .padding(20)
                            .background(.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .inset(by: 0.5)
                                    .stroke(.black.opacity(0.05), lineWidth: 1)
                            )
                            
                        }
                        .padding(20)
                }
//                    .ignoresSafeArea()
            }.onAppear{
               
                if let rec = dailyStat.filter({ $0.date == returnOnlyDateToString(param: Date())}).first {
                    
                    numberOfWarnings = rec.numberOfWarnings
                    numberOfFix = rec.numberOfFix
                    
                    numberOfSit = rec.numberOfSit
                    numberOfLeftLie = rec.numberOfLeftLie
                    numberOfRightLie = rec.numberOfRightLie
                    // 오늘의 통계치를 디비에서 새로 가져와서 수정하고 이걸로 계속 저장.. 사실 이부분은 뷰에 있을게 아니라
                    // 어디든 앱이 시작될때 초기화 화면에 있어야 함..
                    
                    PostureFind.dailyNotificationCount = numberOfWarnings ?? 0
                    PostureFind.dailyFixCount = numberOfFix ?? 0
                    PostureFind.dailyNumberOfSit = numberOfSit ?? 0
                    PostureFind.dailyNumberOfLeftLie = numberOfLeftLie ?? 0
                    PostureFind.dailyNumberOfRightLie = numberOfRightLie ?? 0
                    
                    
                    if numberOfSit == max(numberOfSit ?? 0,numberOfLeftLie ?? 0, numberOfRightLie ?? 0) {
                        firstPostureString = "앉은자세"
                        if numberOfLeftLie ==  max(numberOfLeftLie ?? 0, numberOfRightLie ?? 0) {
                            seconPostureString = "왼쪽으로 누운자세"
                            thirdPostureString = "오른쪽으로 누운자세"
                        }
                        else {
                            seconPostureString = "오른쪽으로 누운자세"
                            thirdPostureString = "왼쪽으로 누운자세"
                        }
                        
                    }
                    else if numberOfLeftLie == max(numberOfSit ?? 0,numberOfLeftLie ?? 0, numberOfRightLie ?? 0){
                        firstPostureString = "왼쪽으로 누운자세"
                        if numberOfSit ==  max(numberOfSit ?? 0, numberOfRightLie ?? 0) {
                            seconPostureString = "앉은 자세"
                            thirdPostureString = "오른쪽으로 누운자세"
                        }
                        else {
                            seconPostureString = "오른쪽으로 누운자세"
                            thirdPostureString = "앉은 자세"
                        }
                        
                    }
                    else if numberOfRightLie == max(numberOfSit ?? 0,numberOfLeftLie ?? 0, numberOfRightLie ?? 0) {
                        firstPostureString = "오른쪽으로 누운자세"
                        if numberOfSit ==  max(numberOfSit ?? 0, numberOfLeftLie ?? 0) {
                            seconPostureString = "앉은 자세"
                            thirdPostureString = "왼쪽으로 누운자세"
                        }
                        else {
                            seconPostureString = "왼쪽으로 누운자세"
                            thirdPostureString = "앉은 자세"
                        }
                        
                        
                    }
                }
                else {
                    let newDailyStat = DailyStat(date: returnOnlyDateToString(param: Date()), numberOfWarnings: 0, numberOfFix: 0, numberOfSit : 0, numberOfLeftLie: 0, numberOfRightLie :0 )
                    do {
                        modelContext.insert(newDailyStat)
                        try  modelContext.save()
                    } catch {
                        print("generating dailyStat error: \(error)")
                    }
                }
                if let num_w = numberOfWarnings {
                    if let num_f = numberOfFix {
                        if num_w > 0 {
                            print(num_f, num_w ,Double(num_f) / Double(num_w) )
                            rateOfFix = Double(num_f) / Double(num_w) * 100
                        } else {
                            rateOfFix = nil
                        }
                    }
                    
                }
                
            }
            .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                Spacer()
            
            
            
            
        }
    }
  
    // 오늘 (달) 가져오기
        func todayMonth() -> String {
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M"
            
            return dateFormatter.string(from:now)
        }

    // 오늘 (일) 가져오기
        func todayDay() -> String {
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d"
            
            return dateFormatter.string(from:now)
        }

    // 오늘 (요일) 가져오기
        func todayWeek() -> String {
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            
            return dateFormatter.string(from:now)
        }
        
        
    // 자세 상태 변수

    
    
}

#Preview {
    SummaryView()
}
