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
        VStack(alignment: .center, spacing: 0) {
            Text("신청폼 링크를 복사해서")
                .font(.system(size: 24, weight: .semibold))
            Text("SNS에 활용하세요.")
                .font(.system(size: 24, weight: .semibold))
                .padding(.bottom)
            
            Image("onboardingSecond")
                .padding()
            
            Button(action: {
                withAnimation(.spring()) {
                    isOnboardingActive.toggle()
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.accent)
                        .frame(maxHeight: CGFloat(50))
                        .padding()
                    Text("시작하기")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .semibold))
                }
            }).padding(.bottom, 12)
        }
    }
}

