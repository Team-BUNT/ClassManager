//
//  ContainerView.swift
//  ClassManager
//
//  Created by 김남건 on 2022/11/09.
//

import SwiftUI

struct ContainerView: View {
    let link: String
    let studioID: String
    
    var body: some View {
        TabView {
            ClassCalendarView(link: self.link, studioID: self.studioID)
                .tabItem {
                    VStack {
                        Image("Door")
                        Text("클래스")
                    }
                }
            
            PaymentStatusView()
                .tabItem {
                    VStack {
                        Image("Card")
                        Text("결제")
                    }
                }
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(named: "TabBarBackground")
        }
        .tint(.accent)
        .accentColor(Color("Accent"))
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView(link: "", studioID: "")
    }
}
