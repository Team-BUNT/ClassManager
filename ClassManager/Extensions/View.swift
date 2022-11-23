//
//  View.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/11/05.
//

import SwiftUI

extension View {
    //MARK: 키보드를 내리는 메소드.
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func limitText(_ text: Binding<String>, to characterLimit: Int) -> some View {
            self
                .onChange(of: text.wrappedValue) { _ in
                    text.wrappedValue = String(text.wrappedValue.prefix(characterLimit))
                }
        }
}
