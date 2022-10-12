//
//  OnboardingSecond.swift
//  ClassManager
//
//  Created by leejunmo on 2022/10/13.
//

import SwiftUI

struct OnboardingSecond: View {
    @AppStorage("onboarding") var isOnboardingActive: Bool = true
    
    var body: some View {
        VStack {
            Button(action: {
                isOnboardingActive.toggle()
            }, label: {
                Text("test")
            })
        }
    }
}

