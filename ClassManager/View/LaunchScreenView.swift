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
    
    @State var link = "https://this.is.sample.link"
    @State var studioID = ""
    
    var body: some View {
        if isActive {
            if isOnboardingActive {
                OnboardingMain()
            } else {
                ContainerView(link: self.link, studioID: self.studioID)
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
                    do {
                        // 임시 테스트 플라이트용 함수
                        let linkStruct = try await DataService.shared.requestLink()
                        if linkStruct != nil {
                            link = linkStruct!.link!
                            studioID = linkStruct!.studioID!
                        }
                        if !studioID.isEmpty {
                            Constant.shared.studio = try await DataService.shared.requestStudioBy(studioID: studioID)
                            Constant.shared.classes = try await DataService.shared.requestAllClassesBy(studioID: studioID)
                        }
                        Constant.shared.suspendedClasses = try await DataService.shared.requestSuspendedClassesBy(studioID: studioID)
                    } catch {
                        print(error)
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
