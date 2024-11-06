//
//  TutoriorView.swift
//  Croak
//
//  Created by Giwoo Kim on 5/22/24.
//

import SwiftUI

struct TutoriorView: View {
    var body: some View {
        VStack(alignment: .leading){
            Rectangle()
                .frame(width: 333, height: 405)
                .padding(.bottom, 30)
            HStack(spacing: 10){
                //뭔가 반복되지 않게 할 수 있는 방법이 있을 것 같은데 잘 모르겠음....
                Circle()
                    .frame(width: 10)
                    .foregroundColor(Color("CroakGreen"))
                Circle()
                    .frame(width: 10)
                    .foregroundColor(Color("Gray200"))
                Circle()
                    .frame(width: 10)
                    .foregroundColor(Color("Gray200"))
                Spacer()
            }
            .padding(.bottom, 12)
            Text("알림을 받으면 \n자세를 바꿔주세요")
                .font(.custom("Pretendard-Bold", size: 28))
                .padding(.bottom, 10)
                .lineSpacing(4)
            Text("몸에 부담을 줄이려면 자주 자세를 바꾸는 것이 중요해요. 크록과 함께 실천해봐요!")
                .font(.custom("Pretendard-Medium", size: 18))
                .foregroundStyle(Color("Gray700"))
                .lineSpacing(4)
            Spacer()
            NavigationLink(destination: MainView()){
                Text("다음으로")
                    .foregroundStyle(Color.black)
                    .font(.custom("Pretendard-Bold", size: 16))
            }
            .bold()
            .padding(.vertical, 18)
            .padding(.horizontal, 138)
            .background(Color("CroakGreen"))
            .cornerRadius(8)
            
        }
        .padding(30)
    }
}

#Preview {
    TutoriorView()
}
