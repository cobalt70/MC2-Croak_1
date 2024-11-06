//
//  dateTransferFunc.swift
//  Croak
//
//  Created by jeong hyein on 5/11/24.
//


import Foundation

func returnOnlyDateToString(param: Date) -> String {
    var formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    var current_date_string = formatter.string(from: param)
  //  print(current_date_string)
    
    return current_date_string
}

func returnDateToTime(param: Date) -> String {
    var formatter_time = DateFormatter()
    formatter_time.dateFormat = "HH:mm"
    var current_time_string = formatter_time.string(from: param)
  //  print(current_time_string)
    
    return current_time_string
}

func returnRoundTime(param: String) -> String? {
    let components = param.split(separator: ":")
    
    // 시간과 분 추출
    guard components.count == 2,
          let hour = Int(components[0]),
          let minute = Int(components[1]) else {
        return nil
    }
    

    let roundedMinute = (minute / 5) * 5
    let roundedHour = hour + (minute / 60)

    // %d : 정수값을 나타내는 형식, 02는 최소 두자리로 표시하고 부족한 자리는 0을 채움
    return String(format: "%02d:%02d", roundedHour, roundedMinute)
}


// 오늘 (연) 가져오기
    func todayYear() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        
        return dateFormatter.string(from:now)
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

func sixDaysAgo() -> String {
    let now = Date()
    let calendar = Calendar.current
    
    // 6일 전을 계산하기 위해 DateComponents 사용
    if let sixDaysAgo = calendar.date(byAdding: .day, value: -6, to: now) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"  // 월의 일자만 출력
        return dateFormatter.string(from: sixDaysAgo)
    }
    
    return "Date not available"  // 날짜 계산에 실패한 경우
}

func sixDaysAgoToDateRange() -> String {
    let now = Date()
    let calendar = Calendar.current
    
    // 6일 전 날짜를 계산
    if let sixDaysAgo = calendar.date(byAdding: .day, value: -6, to: now) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"  // 연, 월, 일 형식으로 설정
        let startDateFormat = dateFormatter.string(from: sixDaysAgo)
        
        dateFormatter.dateFormat = "d일"  // 오직 '일'만 표시
        let endDateFormat = dateFormatter.string(from: now)  // 오늘 날짜의 일자만
        
        return "\(startDateFormat) ~ \(endDateFormat)"  // 결과 문자열 생성
    }
    
    return "Date not available"  // 날짜 계산에 실패한 경우
}
