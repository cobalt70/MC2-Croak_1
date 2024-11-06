//
//  postureAverageTimeFunc.swift .swift
//  Croak
//
//  Created by Giwoo Kim on 5/25/24.
//

import Foundation

//struct DayPosture: Identifiable {
//    var posture: PostureToKor
//    var day: DateToWeekDay
//    var time: Double
//    var id = UUID()
//}
//
//struct DayPosture2: Identifiable {
//    var id = UUID()
//    var date : String
//    var day: DateToWeekDay
//    var posture: PostureToKor
//    var time: Double
//    
//}
//
//enum DateToWeekDay: String, CaseIterable {
//    case MON = "월"
//    case TUE = "화"
//    case WED = "수"
//    case THR = "목"
//    case FRI = "금"
//    case SAT = "토"
//    case SUN = "일"
//}


func TotalTimeAverage(for data: [DayPosture2]) -> String {
    let totalSum = data.reduce(0.0) { (sum, dataPoint) -> Double in
        return sum + dataPoint.time
    }
    return "\(Int(totalSum / 7))시 \(Int(Int((totalSum / 7) * 60) % 60))분"
}

func PostureTimeAverage(for data: [DayPosture2], posture: PostureToKor) -> String {
    let filteredData = data.filter { $0.posture == posture }
    
    let totalSum = filteredData.reduce(0.0) { (sum, dataPoint) -> Double in
        return sum + dataPoint.time
    }
    return "\(Int(totalSum / 7))시 \(Int(Int((totalSum / 7) * 60) % 60))분"
}
