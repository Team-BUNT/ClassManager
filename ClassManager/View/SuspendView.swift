//
//  SuspendView.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/11/05.
//

import SwiftUI

struct SuspendView: View {
    let currentClass: Class
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var isShowingToast: Bool
    
    @State var selectedReason = ""
    @State var selectedIndex: Int?
    
    @State var otherReason = ""
    
    let reasons = ["건강 이슈", "외부 일정", "개인 사정", "스튜디오 사정", "기타"]
    
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
        .navigationBarBackButtonHidden(true)
        .navigationTitle("휴강 사유")
        .toolbar {
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
                    if selectedIndex != nil {
                        Task {
                            await DataService.shared.updateSuspendedClasses(classID: currentClass.ID, studioID: currentClass.studioID ?? "")
                        }
                        // TODO: Kakaotalk messaging
                        isShowingToast.toggle()
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("완료")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(selectedIndex != nil ? Color("Accent") : Color("Gray"))
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
