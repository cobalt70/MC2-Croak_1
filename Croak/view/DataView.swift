
import Charts
import SwiftUI
import SwiftData


struct DayPosture: Identifiable {
    var posture: PostureToKor
    var day: DateToWeekDay
    var time: Double
    var id = UUID()
}

struct DayPosture2: Identifiable {
    var id = UUID()
    var date : String
    var day: DateToWeekDay
    var posture: PostureToKor
    var time: Double
    
}

enum DateToWeekDay: String, CaseIterable {
    case MON = "월"
    case TUE = "화"
    case WED = "수"
    case THR = "목"
    case FRI = "금"
    case SAT = "토"
    case SUN = "일"
}

// var stackedBarData: [DayPosture2] = []
//    .init(posture: .SITTING, day: .MON, time: 6),
//    .init(posture: .LYING_LEFT, day: .MON, time: 1.5),
//    .init(posture: .LYING, day: .MON, time: 1.5),
//    .init(posture: .LYING_RIGHT, day: .MON, time: 3),
//    .init(posture: .SITTING, day: .TUE, time: 5),
//    .init(posture: .LYING_LEFT, day: .TUE, time: 1.5),
//    .init(posture: .LYING, day: .TUE, time: 1.5),
//    .init(posture: .LYING_RIGHT, day: .TUE, time: 0.5),
//    .init(posture: .SITTING, day: .WED, time: 5),
//    .init(posture: .LYING_LEFT, day: .WED, time: 1.5),
//    .init(posture: .LYING, day: .WED, time: 1.5),
//    .init(posture: .LYING_RIGHT, day: .WED, time: 1),
//    .init(posture: .SITTING, day: .THR, time: 1.5),
//    .init(posture: .LYING_LEFT, day: .THR, time: 1.5),
//    .init(posture: .LYING, day: .THR, time: 2),
//    .init(posture: .LYING_RIGHT, day: .THR, time: 3.5),
//    .init(posture: .SITTING, day: .FRI, time: 4),
//    .init(posture: .LYING_LEFT, day: .FRI, time: 1.5),
//    .init(posture: .LYING, day: .FRI, time: 2.5),
//    .init(posture: .LYING_RIGHT, day: .FRI, time: 2.5),
//    .init(posture: .SITTING, day: .SAT, time: 6),
//    .init(posture: .LYING_LEFT, day: .SAT, time: 2),
//    .init(posture: .LYING, day: .SAT, time: 1),
//    .init(posture: .LYING_RIGHT, day: .SAT, time: 3),
//    .init(posture: .SITTING, day: .SUN, time: 4),
//    .init(posture: .LYING_LEFT, day: .SUN, time: 1),
//    .init(posture: .LYING, day: .SUN, time: 2),
//    .init(posture: .LYING_RIGHT, day: .SUN, time: 4),






struct DataView: View {
    @Environment(\.modelContext) var modelContext
    @State private var selectedPosture: PostureToKor = .SITTING
    @State private var showingPicker = false
    @Query(sort: [SortDescriptor(\PosturePer10m.date, order: .reverse), SortDescriptor(\PosturePer10m.startTime, order: .reverse)] ) private var  allPosturePer10m : [PosturePer10m ]
    
    @State var sevenDaysData : [PosturePer10m] = []
    @State var oneDayData: [PosturePer10m] = []
    @State var stackedBarData2 : [DayPosture2] = []
    @State var stackedBarData: [DayPosture2] = []
    
    var chartPosture: [PostureToKor] {
        return PostureToKor.allCases.filter { posture in
            switch posture {
            case .SITTING, .LYING, .LYING_LEFT, .LYING_RIGHT, .LYING_FACE_DOWN:
                return true
            default:
                return false
            }
        }
    }
    
    
    var body: some View {
        VStack{
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading){
                    HStack{
                        Text("자세별 유지 시간")
                            .font(Font.custom("Pretendard-Bold", size: 20))
                            .foregroundColor(Color("Gray700"))
                        Spacer()
                    }
                    .padding(.bottom, 16)
                    .padding(.leading, 4)
                    
                    VStack(alignment: .leading) {
                        Text("일일 평균")
                            .font(Font.custom("Pretendard-Medium", size: 14))
                            .foregroundColor(Color("Gray700"))
                            .padding(.bottom, 4)
                        Text(TotalTimeAverage(for: stackedBarData))
                            .font(Font.custom("Pretendard-Bold", size: 24))
                            .foregroundColor(Color("CroakBlack"))
                            .padding(.bottom, 4)
                        Text(sixDaysAgoToDateRange())
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color("Gray500"))
                            .padding(.bottom, 18)
                        Chart {
                            ForEach(stackedBarData) { posture in
                                BarMark(
                                    x: .value("Week", posture.day.rawValue),
                                    y: .value("Time", posture.time)
                                )
                                .foregroundStyle(Color( posture.posture.rawValue))
                            }
                        }
                        .frame(height:140)
                        .padding(.bottom, 16)
                        HStack {
                            VStack(alignment:.leading){
                                HStack {
                                    Rectangle()
                                        .foregroundColor(color(for:(.LYING_LEFT)))
                                        .frame(width: 8, height: 8)
                                        .cornerRadius(2)
                                        .padding(.horizontal, 6)
                                    Text(PostureToKor.SITTING.rawValue)
                                        .font(Font.custom("Pretendard-ㅡMedium", size: 10))
                                        .foregroundColor(Color("Gray700"))
                                    
                                }
                                HStack {
                                    Rectangle()
                                        .foregroundColor(color(for: .LYING_LEFT))
                                        .frame(width: 8, height: 8)
                                        .cornerRadius(2)
                                        .padding(.horizontal, 6)
                                    Text(PostureToKor.LYING.rawValue)
                                        .font(Font.custom("Pretendard-ㅡMedium", size: 10))
                                        .foregroundColor(Color("Gray700"))
                                    
                                }
                            }
                            .padding(.trailing, 12)
                            VStack(alignment:.leading){
                                HStack {
                                    Rectangle()
                                        .foregroundColor(color(for: .LYING_LEFT))
                                        .frame(width: 8, height: 8)
                                        .cornerRadius(2)
                                        .padding(.horizontal, 6)
                                    Text(PostureToKor.LYING_LEFT.rawValue)
                                        .font(Font.custom("Pretendard-ㅡMedium", size: 10))
                                        .foregroundColor(Color("Gray700"))
                                    
                                }
                                HStack {
                                    Rectangle()
                                        .foregroundColor(color(for: .LYING_LEFT))
                                        .frame(width: 8, height: 8)
                                        .cornerRadius(2)
                                        .padding(.horizontal, 6)
                                    Text(PostureToKor.LYING_RIGHT.rawValue)
                                        .font(Font.custom("Pretendard-ㅡMedium", size: 10))
                                        .foregroundColor(Color("Gray700"))
                                    
                                }
                            }
                        }
                    }
                    .padding(.top, 16)
                    .padding(.horizontal,20)
                    .padding(.bottom,20)
                    .background(Color("CroakWhite"))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.5)
                            .stroke(Color("Gray200"), lineWidth: 1)
                    )
                    .padding(.bottom, 24)
                    
                    HStack{
                        
                        Menu {
                            Button {
                                selectedPosture = .SITTING
                            } label: {
                                Text("앉은 자세")
                            }
                            Button {
                                selectedPosture = .LYING_LEFT
                            } label: {
                                Text("왼쪽으로 누운 자세")
                            }
                            Button {
                                selectedPosture = .LYING
                            } label: {
                                Text("바로 누운 자세")
                            }
                            Button {
                                selectedPosture = .LYING_RIGHT
                            } label: {
                                Text("오른쪽으로 누운 자세")
                            }
                        } label: {
                            HStack {
                                Text(selectedPosture.rawValue)
                                    .font(Font.custom("Pretendard-Bold", size: 20))
                                    .foregroundColor(Color("Gray700"))
                                Image(systemName: "chevron.down")
                                    .font(Font.custom("Pretendard-Bold", size: 16))
                                    .foregroundColor(Color("Gray700"))
                            }
                        }
                    }
                    .padding(.bottom, 16)
                    .padding(.leading, 4)
                    
                    VStack(alignment: .leading) {
                        Text("일일 평균")
                            .font(Font.custom("Pretendard-Medium", size: 14))
                            .foregroundColor(Color("Gray700"))
                            .padding(.bottom, 4)
                        Text(PostureTimeAverage(for: stackedBarData, posture: selectedPosture))
                            .font(Font.custom("Pretendard-Bold", size: 24))
                            .foregroundColor(Color("CroakBlack"))
                            .padding(.bottom, 4)
                        Text(sixDaysAgoToDateRange())
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color("Gray500"))
                            .padding(.bottom, 18)
                        Chart {
                            ForEach(stackedBarData.filter { $0.posture == selectedPosture }) { posture in
                                BarMark(
                                    x: .value("Week", posture.day.rawValue),
                                    y: .value("Time", posture.time)
                                )
                              //  .foregroundStyle(Color(for: selectedPosture))
                            }
                        }
                        .frame(height:121)
                    }
                    .padding(.top, 16)
                    .padding(.horizontal,20)
                    .padding(.bottom,20)
                    .background(Color("CroakWhite"))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.5)
                            .stroke(Color("Gray200"), lineWidth: 1)
                    )
                    .padding(.bottom, 24)
                }
                
            }
            Spacer()
        }
        .padding(20)
        .background(Color("Gray100"))
        .ignoresSafeArea()
        .onAppear{
            
            let startDate  = Date.now
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // 입력 문자열의 형식
            dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let endDateString  = dateFormatter.string(from: Date())
            let startDateString =  previousDateString(from: endDateString, daysago :6)
         
          
            
            print("startDate ", startDateString ?? "error in startDate" , "endString" , endDateString)
            initStackedBarDataFromTo(startDate: startDateString!, endDate: endDateString)
            var count = 0
            for  data in stackedBarData2 {
                count += 1
                print(count , data)
               
            }
            
            stackedBarData.removeAll()
            stackedBarData = stackedBarData2
            
        }//onAppear
        
    }
    
    func initStackedBarDataFromTo(startDate :String = "" ,endDate: String = "" ) {
        var LYING : Int = 0
        var LYING_TIME : Double  = 0
        var LYING_FACE_DOWN : Int = 0
        var LYING_FACE_DOWN_TIME : Double = 0
        var LYING_LEFT : Int = 0
        var LYING_LEFT_TIME: Double = 0
        var LYING_RIGHT : Int = 0
        var LYING_RIGHT_TIME : Double = 0
        var SITTING : Int = 0
        var SITTING_TIME :Double = 0
        var NIL = 0
        var NOT_AVAILABLE = 0
     
        var weekOfDay : DateToWeekDay?
        print("numberof10m data \(allPosturePer10m.count)")
        
        sevenDaysData = allPosturePer10m.filter{ $0.date >= startDate && $0.date <=  endDate }
        print("sevenDaysData", sevenDaysData.count)
        var currentDate = startDate
        print("start Date" , startDate)
        
        while currentDate <= endDate {
            print("currentDate" , currentDate)
            oneDayData = sevenDaysData.filter{ $0.date == currentDate }
            LYING = 0
            LYING_TIME  = 0
            LYING_FACE_DOWN = 0
            LYING_FACE_DOWN_TIME = 0
            LYING_LEFT = 0
            LYING_LEFT_TIME = 0
            LYING_RIGHT = 0
            LYING_RIGHT_TIME = 0
            NIL = 0
            NOT_AVAILABLE = 0
            SITTING = 0
            SITTING_TIME = 0
            for data in oneDayData {
                
                
                if (data.posture == PostureToKor.LYING.rawValue ) {
                    LYING += 1
                } else if ( data.posture == PostureToKor.LYING_FACE_DOWN.rawValue ) {
                    LYING_FACE_DOWN += 1
                } else if ( data.posture == PostureToKor.LYING_LEFT.rawValue ) {
                    LYING_LEFT += 1
                } else if ( data.posture == PostureToKor.LYING_RIGHT.rawValue ) {
                    LYING_RIGHT += 1
                } else if ( data.posture == PostureToKor.NIL.rawValue ) {
                    NIL += 1
                } else if ( data.posture == PostureToKor.NOT_AVAILABLE.rawValue ) {
                    NOT_AVAILABLE += 1
                } else if ( data.posture == PostureToKor.SITTING.rawValue ) {
                    SITTING += 1
                }
            }
            
            //   LYING_TIME = LYING  * 10 / 60
            LYING_TIME =  Double(Int.random(in: 10...20) * 10) / 60
            
            //   LYING_FACE_DOWN_TIME = Double(LYING_FACE_DOWN * 10) / 60
            
            LYING_FACE_DOWN_TIME = Double(Int.random(in: 10...20) * 10 ) / 60
            //   LYING_LEFT_TIME = Double( LYING_LEFT  * 10) / 60
            LYING_LEFT_TIME =  Double(Int.random(in: 10...20) * 10) / 60
            
            //     LYING_RIGHT_TIME  =  Double(LYING_RIGHT_TIME * 10) / 60
            LYING_RIGHT_TIME  =  Double(Int.random(in: 10...20) * 10) / 60
            //      SITTING_TIME = Double(SITTING * 10) / 60
            SITTING_TIME = Double(Int.random(in: 10...20) * 10) / 60
            
            print(" 시간계산:", LYING_TIME, LYING_FACE_DOWN_TIME, LYING_LEFT_TIME, LYING_RIGHT_TIME , SITTING_TIME)
            
            let calendar  = Calendar.current
            if  let weekDay = getDayOfWeek(from: currentDate) {
                if weekDay == 1 {
                    weekOfDay = .SUN
                } else if weekDay == 2{
                    weekOfDay = .MON
                } else if weekDay == 3 {
                    weekOfDay = .TUE
                } else if weekDay == 4{
                    weekOfDay = .WED
                } else if weekDay == 5 {
                    weekOfDay = .THR
                } else if weekDay == 6 {
                    weekOfDay = .FRI
                } else  {
                    weekOfDay = .SAT
                    
                }
            }
            stackedBarData2.append(DayPosture2(date: currentDate, day: weekOfDay!, posture: .LYING , time: Double(LYING_TIME)))
            stackedBarData2.append(DayPosture2(date: currentDate, day: weekOfDay!, posture: .LYING_FACE_DOWN , time: Double(LYING_FACE_DOWN_TIME)))
            stackedBarData2.append(DayPosture2(date: currentDate, day: weekOfDay!, posture: .LYING_LEFT , time: Double(LYING_LEFT_TIME)))
            stackedBarData2.append(DayPosture2(date: currentDate, day: weekOfDay!, posture: .LYING_RIGHT , time: Double(LYING_RIGHT_TIME)))
            stackedBarData2.append(DayPosture2(date: currentDate, day: weekOfDay!, posture: .SITTING , time: Double(SITTING_TIME)))
            
            if let tmpDate = addOneDay(to: currentDate) {
                currentDate = tmpDate
                
            }
            else {
                print("date data error!!")
            }
            
        }
        
        
    }
    func getDayOfWeek(from dateString: String) -> Int? {
        // DateFormatter 인스턴스 생성 및 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 입력 문자열의 형식
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        let calendar = Calendar.current
        // 문자열을 Date 객체로 변환
        if let date = dateFormatter.date(from: dateString) {
            return calendar.component(.weekday, from: date)
        } else {
            return nil // 유효하지 않은 날짜 형식일 경우 nil 반환
        }
    }
    
    
    func addOneDay(to dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 입력 문자열의 형식
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        if let date = dateFormatter.date(from: dateString) {
            
            let calendar = Calendar.current
            // 날짜를 하루 증가
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: date) {
                // 증가된 날짜를 문자열로 변환하여 반환
                return dateFormatter.string(from: nextDate)
            }
        }
        return nil // 유효하지 않은 날짜 형식이거나 날짜 증가에 실패한 경우 nil 반환
    }
    
    func  previousDateString(from dateString: String, daysago : Int) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 입력 문자열의 형식
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            if let previousDate = calendar.date(byAdding: .day, value: -daysago, to: date) {
                print("dateString \(dateString) previous date \(previousDate)")
                print("previousDate",dateFormatter.string(from: previousDate))
                return dateFormatter.string(from: previousDate)
            }
        }
        return nil
    }
    
    func color(for posture: PostureToKor) -> Color {
            switch posture {
            case .SITTING:
                return .croakBlue
            case .LYING_LEFT:
                return .croakPink
            case .LYING:
                return .croakOrange
            case .LYING_RIGHT:
                return .croakGreen
            case .LYING_FACE_DOWN:
                return .croakGreen
            case .NOT_AVAILABLE:
                return .croakGreen
            case .NIL:
                return .croakGreen
            }
        }
}





#Preview {
    DataView()
}

