//
//  AlarmCalendar.swift
//  Croak
//
//  Created by jeong hyein on 5/17/24.
//

import SwiftUI

struct AlarmCalendar: View {
    
    @State private var color: Color = Color("CroakGreen")
    @State private var date = Date.now
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days: [Date] = []
    
    var body: some View {
        
        VStack{
            HStack{
                Text("알림을 많이 받은 날은 총 12일입니다.")
                    .font(.custom("Pretendard-Regular", size: 16))
                    .foregroundStyle(Color("CroakBlack"))
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding(.bottom, 8)
            
            HStack{
                Text("5월")
                    .font(.custom("Pretendard-Regular", size: 20))
                    .fontWeight(.bold)
                Spacer()
            }
            
            VStack {
                Divider()
                    .padding(.bottom, 5)
                HStack {
                    ForEach(daysOfWeek.indices, id: \.self) { index in
                        Text(daysOfWeek[index])
                            .font(.custom("Pretendard-Medium", size: 14))
                            .foregroundStyle(Color("Gray700"))
                            .frame(maxWidth: .infinity)
                    }
                }
                
                Divider()
                    .padding(.top, 5)
                    .padding(.bottom, 10)
                
                LazyVGrid(columns: columns) {
                    ForEach(days, id: \.self) { day in
                        if day.monthInt != date.monthInt {
                            Text("")
                        } else if day < Date.now.startOfDay {
                            VStack{
                                Text(day.formatted(.dateTime.day()))
                                    .font(.custom("Pretendard-Bold", size: 14))
                                    .foregroundStyle(Color("Gray700"))
                                    .frame(maxWidth: .infinity, minHeight: 30)
                                    .background(
                                        Circle()
                                            .foregroundStyle(Color("CroakGreen")
                                                            )
                                    )
                            }
                            .padding(.vertical, 5)
                            
                        } else if day == Date.now.startOfDay {
                            VStack {
                                
                                Circle()
                                    .frame(height: 6)
                                    .foregroundStyle(Color("CroakOrange"))
                                Text(day.formatted(.dateTime.day()))
                                    .font(.custom("Pretendard-Bold", size: 14))
                                    .foregroundStyle(Color("Gray700"))
                                Spacer()
                            }
                            
                        } else {
                            VStack{
                                Text(day.formatted(.dateTime.day()))
                                    .font(.custom("Pretendard-Bold", size: 14))
                                    .foregroundStyle(Color("Gray300"))
                                    .frame(maxWidth: .infinity, minHeight: 30)
                                
                            }
                            .padding(.vertical, 5)
                            
                        }
                    }
                }
            }
            .padding(.top, 6)
            .onAppear {
                days = date.calendarDisplayDays
            }
            .onChange(of: date) {
                days = date.calendarDisplayDays
            }
            
            
        }
    }
}

#Preview {
    AlarmCalendar()
}
