//
//  OnboardingFirst.swift
//  ClassManager
//
//  Created by leejunmo on 2022/10/13.
//

import SwiftUI

struct OnboardingFirst: View {
    @AppStorage("onboarding") var isOnboardingActive: Bool = true
    @Binding var mode: Mode
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("신청폼, 매번 고칠 필요 없어요.")
                .font(.system(size: 24, weight: .semibold))
            Text("일정만 등록해도, 신청폼이 자동으로 업데이트")
                .font(.system(size: 17, weight: .regular))
                .padding()
            
            Image("onboardingFirst")
                .padding()
            
            Button(action: {
                withAnimation(.spring()) {
                    mode = .second
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.accent)
                        .frame(maxHeight: CGFloat(50))
                        .padding()
                    Text("다음")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .semibold))
                }
            })
            Button(action: {
                isOnboardingActive.toggle()
            }, label: {
                Text("건너뛰기")
                    .foregroundColor(.white)
                    .font(.system(size: 17, weight: .regular))
            })
        }
    }
}


