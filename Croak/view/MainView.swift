//
//  MainView.swift
//  Croak
//
//  Created by jeong hyein on 5/17/24.
//

import SwiftUI

import SwiftData

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: [SortDescriptor(\DailyStat.date) ]) var dailyStat: [DailyStat]
    @State var tabIndex: tapInfo = .SUMMARY
    @State var programRunnedFirst = false
    @State var numberOfWarnings : Int?
    @State var numberOfFix : Int?
    
    var body: some View {
        VStack {
            HStack{
                Text("Croak")
                    .font(.custom("Poppins-Bold", size: 32))
                Spacer()
                Button {
                    
                } label: {
//                    Image(systemName: "plus.circle")
                    Image("profile")
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            CustomTopTabBar(tabIndex: $tabIndex)
                .padding(.bottom, 6)
            
            Divider()
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            
           
            VStack {
                if tabIndex == .SUMMARY {
                    SummaryView()
                } else if tabIndex == .DATA {
                    DataView()
                } else if tabIndex == .HABBIT {
                    HabitView()
                } else if tabIndex == .MONITOR {
                    AndyUIView()
                }
            }
            .background(Color("Gray100"))
            
        } .onAppear {
            do {
                try modelContext.delete(model: DailyStat.self)
            } catch {
                print("Failed to delete all schools.")
            }
            
        }
    }
}

#Preview {
    MainView(tabIndex: .SUMMARY)
}
