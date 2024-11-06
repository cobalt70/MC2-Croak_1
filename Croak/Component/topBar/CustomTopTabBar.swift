//
//  CustomTopTabBar.swift
//  Croak
//
//  Created by jeong hyein on 5/17/24.
//

import Foundation
import SwiftUI

struct CustomTopTabBar: View {
    @Binding var tabIndex: tapInfo
    
    var body: some View {
        HStack{
            TabBarButton(text: "요약", isSelected: .constant(tabIndex == .SUMMARY))
                .onTapGesture { onButtonTapped(index: .SUMMARY) }
            TabBarButton(text: "자세 분석", isSelected: .constant(tabIndex == .DATA))
                .onTapGesture { onButtonTapped(index: .DATA) }
            TabBarButton(text: "자세 습관", isSelected: .constant(tabIndex == .HABBIT))
                .onTapGesture { onButtonTapped(index: .HABBIT) }
            TabBarButton(text: "과거", isSelected: .constant(tabIndex == .MONITOR))
                .onTapGesture { onButtonTapped(index: .MONITOR) }
            Spacer()
        }
    }
    
    private func onButtonTapped(index: tapInfo) {
        withAnimation { tabIndex = index }
    }
}


