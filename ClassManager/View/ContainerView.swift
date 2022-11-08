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
                    Text("클래스")
                }
            PaymentStatusView()
                .tabItem {
                    Text("결제")
                }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(named: "TabBarBackground")
        }
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
