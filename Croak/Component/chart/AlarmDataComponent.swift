//
//  AlarmDataComponent.swift
//  Croak
//
//  Created by jeong hyein on 5/17/24.
//

import SwiftUI
import Charts

struct Order: Identifiable {
    var id: String = UUID().uuidString
    var amount: Int
    var day: String
}

struct AlarmDataComponent: View {
    var ordersWeekOne: [Order] = [
            Order(amount: 10, day: "월"),
            Order(amount: 7, day: "화"),
            Order(amount: 4, day: "수"),
            Order(amount: 13, day: "목"),
            Order(amount: 19, day: "금"),
            Order(amount: 6, day: "토"),
            Order(amount: 16, day: "일")
        ]
        var ordersWeekTwo: [Order] = [
            Order(amount: 20, day: "월"),
            Order(amount: 14, day: "화"),
            Order(amount: 8, day: "수"),
            Order(amount: 26, day: "목"),
            Order(amount: 27, day: "금"),
            Order(amount: 12, day: "토"),
            Order(amount: 32, day: "일")
        ]
    var body: some View {
        VStack(spacing: 4){
            HStack{
                Text("주간 이행률")
                    .font(.custom("Pretendard-Regular", size: 14))
                    .foregroundColor(Color("Gray700"))
                Spacer()
            }
            HStack{
                Text("75%")
                    .font(.custom("Pretendard-Bold", size: 24))
                    .foregroundColor(Color("CroakBlack"))
                Spacer()
            }
            HStack{
                Text("2024년 5월 7일 - 13일")
                    .font(.custom("Pretendard-Medium", size: 12))
                    .foregroundColor(Color("Gray500"))
                Spacer()
            }
            
            Chart {
                ForEach(ordersWeekOne, id: \.id) { order in
                    LineMark(
                        x: PlottableValue.value("Week 1", order.day),
                        y: PlottableValue.value("Orders 1", order.amount),
                        series: .value("Week", "One")
                    )
                    .foregroundStyle(Color("CroakOrange"))
                    .symbol(.circle)
                }
                
                ForEach(ordersWeekTwo, id: \.id) { order in
                    LineMark(
                        x: PlottableValue.value("Week 2", order.day),
                        y: PlottableValue.value("Orders 2", order.amount),
                        series: .value("Week", "Two")
                    )
                    .foregroundStyle(Color("CroakGreen"))
                    .symbol(.circle)

                }
                
            }
            .frame(height: 186)
            .padding(.bottom, 24)
            .padding(.top, 20)
            
            HStack{
                Rectangle()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(Color("CroakGreen"))
                Text("알림 횟수")
                    .font(.custom("Pretendard-Medium", size: 10))
                    .foregroundStyle(Color("Gray700"))
                    .padding(.trailing)
                Rectangle()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(Color("CroakOrange"))
                Text("이행 횟수")
                    .font(.custom("Pretendard-Medium", size: 10))
                    .foregroundStyle(Color("Gray700"))
                Spacer()
            }
            
        }
        
    }
}

#Preview {
    AlarmDataComponent()
}
