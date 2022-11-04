//
//  SuspendView.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/11/05.
//

import SwiftUI

struct SuspendView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State var selectedReason = ""
    @State var selectedIndex = 0
    
    @State var otherReason = ""
    
    let reasons = ["건강 이슈", "외부 일정", "외부 스케줄", "개인 사정", "기타"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ForEach(Array(reasons.enumerated()), id: \.offset) { index, reason in
                HStack(spacing: 0) {
                    if selectedIndex == index {
                        selected
                    } else {
                        unselected
                    }
                    Text(reason)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.leading, 16)
                    if index == 4 {
                        Text("(직접 입력)")
                            .padding(.leading, 4)
                            .foregroundColor(Color("DarkGray"))
                    }
                    Spacer()
                }
                .onTapGesture {
                    selectedIndex = index
                }
            }
            if selectedIndex == 4 {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 106)
                        .foregroundColor(Color("Box"))
                    if otherReason.isEmpty {
                        Text("수강생에게 전달될 휴강 사유를 직접 입력해주세요.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("DarkGray"))
                            .padding(12)
                    }
                    if #available(iOS 16.0, *) {
                        TextEditor(text: $otherReason)
                            .scrollContentBackground(.hidden)
                            .padding(.leading, 6)
                            .padding(.top, 1)
                    } else {
                        TextEditor(text: $otherReason)
                            .padding(.leading, 6)
                            .padding(.top, 1)
                    }
                }
            }
            Spacer()
        }
        .padding(20)
        .padding(.top, 20)
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("휴강 사유")
                    .font(.system(size: 16))
                    .accessibilityAddTraits(.isHeader)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("취소")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // TODO: Update Firebase data
                    // TODO: Kakaotalk messaging
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("추가")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color("Accent"))
                }
            }
        }
    }
    
    var selected: some View {
        Image(systemName: "record.circle.fill")
            .foregroundColor(Color("Accent"))
    }
    
    var unselected: some View {
        Image(systemName: "circle")
            .foregroundColor(Color("Radio"))
    }
}

struct SuspendView_Previews: PreviewProvider {
    static var previews: some View {
        SuspendView()
    }
}
