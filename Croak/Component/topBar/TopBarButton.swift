//
//  TopBarButton.swift
//  Croak
//
//  Created by jeong hyein on 5/17/24.
//

import SwiftUI

struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    
    var body: some View {
        VStack(){
            Circle()
                .frame(height: 6)
                .foregroundColor(isSelected ? Color("CroakOrange") : .clear)
            Text(text)
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .black : .gray)
                .font(.custom("Pretendard", size: 16))
        }
        .padding(.horizontal, 10)
        .padding(.leading, 10)
        
    }
}


