//
//  ContainerView.swift
//  ClassManager
//
//  Created by 김남건 on 2022/11/09.
//

import SwiftUI

struct ContainerView: View {
    var body: some View {
        TabView {
            ClassCalendarView()
                .tabItem {
                    VStack {
                        Image("Door")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24.06, height: 24.79)
                            .padding(.top, 10)
                        Text("클래스")
                    }
                }
            
            PaymentStatusView()
                .tabItem {
                    VStack {
                        Image("Card")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26, height: 20)
                            .padding(.top, 10)
                        Text("결제")
                    }
                }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(named: "TabBarBackground")
        }
        .tint(.accent)
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
