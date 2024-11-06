//
//  HabbitView.swift
//  Croak
//
//  Created by jeong hyein on 5/17/24.
//

import SwiftUI

import Charts
import SwiftUI

struct HabitView: View {
    
    var body: some View {
        
        
        VStack{
            ScrollView(showsIndicators: false) {
                HStack{
                    Text("알람 추세")
                        .font(.custom("Pretendard-Bold", size: 20))
                        .foregroundStyle(Color("Gray700"))
                    Spacer()
                }
                .padding(.bottom, 10)
                
                GroupBox{
                    AlarmCalendar()
                }
                .groupBoxStyle(TransparentGroupBox())
                
                
                HStack{
                    Text("알람 이행 추세")
                        .font(.custom("Pretendard-Bold", size: 20))
                        .foregroundStyle(Color("Gray700"))
                    Spacer()
                }
                .padding(.top)
                .padding(.bottom, 12)
                
                GroupBox{
                    AlarmDataComponent()
                    

                    
                    // 그래프 설명
                    // 알람횟수, 이행횟수도 enum 변수 지정, 사각형도 forEach사용해서 바꿔보기!
                    
                    
                }
                .groupBoxStyle(TransparentGroupBox())
                
                Spacer()
            }
        }
        .padding(20)
    }
}


struct TransparentGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
    }
}

#Preview {
    HabitView()
}
