//
//  checkDataAndNotify.swift
//  Croak
//
//  Created by jeong hyein on 5/12/24.
//

import Foundation

func checkAndNotify(for savedPostureList: [PosturePer10m]) -> Bool {
    // 최근 3개의 항목이 없는 경우
    guard savedPostureList.count >= 3 else {
        print("최근 3개 항목이 없습니다.")
        return false
    }
    
    // 최근 3개의 항목을 가져옴
    let recentPostures = Array(savedPostureList.suffix(3))
    

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    
    guard let lastTime = dateFormatter.date(from: recentPostures[2].date + " " + recentPostures[2].startTime),
          let secondLastTime = dateFormatter.date(from: recentPostures[1].date + " " + recentPostures[1].startTime),
          let thirdLastTime = dateFormatter.date(from: recentPostures[0].date + " " + recentPostures[0].startTime) else {
        print("시간을 Date로 변환하는 중 오류가 발생했습니다.")
        return false
    }
    
//    print("최근 3개의 포스트의 시간 파싱 결과:")
//    print("\(recentPostures[2].startTime) -> \(lastTime)")
//    print("\(recentPostures[1].startTime) -> \(secondLastTime)")
//    print("\(recentPostures[0].startTime) -> \(thirdLastTime)")
    
    // 최근 3개의 항목이 10분 단위로 연속되어 있는지 확인, value 값에 -10 넣기
    let oneMinuteBeforeLastTime = Calendar.current.date(byAdding: .minute, value: -10, to: lastTime)!
    let twoMinutesBeforeSecondLastTime = Calendar.current.date(byAdding: .minute, value: -10, to: secondLastTime)!
    
    guard oneMinuteBeforeLastTime == secondLastTime, twoMinutesBeforeSecondLastTime == thirdLastTime else {
        print("최근 3개의 포스트의 시간 간격이 10분 단위로 연속되지 않습니다.")
        return false
    }
    
    // 최근 3개의 항목의 posture가 모두 같은지 확인합니다.
    if recentPostures[2].posture == recentPostures[1].posture && recentPostures[2].posture == recentPostures[0].posture {
        print("최근 3개의 포스트의 posture가 모두 같습니다.")
        return true
    }
    
    return false
}
