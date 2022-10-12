//
//  OnboardingMain.swift
//  ClassManager
//
//  Created by leejunmo on 2022/10/13.
//

import SwiftUI

struct OnboardingMain: View {
    @State var mode: Mode = .first
    
    var body: some View {
        switch mode {
        case .first:
            OnboardingFirst(mode: $mode)
        case .second:
            OnboardingSecond()
        }
    }
}

enum Mode {
    case first
    case second
}
