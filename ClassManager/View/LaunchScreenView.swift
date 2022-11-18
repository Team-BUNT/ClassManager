//
//  LaunchScreenView.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/11/15.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    @AppStorage("onboarding") var isOnboardingActive: Bool = true
    @AppStorage("studioID") private var studioID: String?
    
    @State var link = "https://this.is.sample.link"
    
    var body: some View {
        if isActive {
            if isOnboardingActive {
                OnboardingMain()
            } else {
                if let id = studioID {
                    ContainerView(link: self.link, studioID: id)
                } else {
                    LoginView(link: $link)
                }
            }
        } else {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.isActive = true
                    }
                }
                .task {
                    if let id = studioID {
                        link = await Constant.shared.fetchLink(id: id)
                    }
                }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
