//
//  EditClassView.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/11/05.
//

import SwiftUI

struct EditClassView: View {
    @Binding var isShowingEditSheet: Bool
    @Binding var isShowingToast: Bool
    @State var isShowingErrorToast = false
    
    @State var title: String
    @State var instructorName: String
    
    @State var date: Date
    @State var tenTimesDuration: Int
    @State var isPopUp: Bool
    @State var repetition: Int
    @State var selectedHall: Int
    
    let applicantsCount: Int
    let classID: String
    
    @State var isChanged = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextFieldRow(label: "댄서 이름", value: $instructorName)
                    
                    TextFieldRow(label: "장르", value: $title)
                }
                .onTapGesture { hideKeyboard() }
                
                Section {
                    StartDateRow(date: $date)
                    DurationRow(tenTimesDuration: $tenTimesDuration)
                }
                .onTapGesture { hideKeyboard() }
                
                Section {
                    ClassTypeRow(isPopUp: $isPopUp)
                }
                
                if !isPopUp {
                    Section {
                        repetitionRow(repetition: $repetition)
                    }
                }
                
                Section {
                    hallRow(selectedHall: $selectedHall)
                }
            }
            .toast(message: "모든 양식을 입력해주세요", isShowing: $isShowingErrorToast, duration: Toast.short)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("클래스 수정")
                        .font(.system(size: 16))
                        .accessibilityAddTraits(.isHeader)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingEditSheet.toggle()
                    } label: {
                        Text("취소")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if isChanged {
                            if !title.isEmpty && !instructorName.isEmpty {
                                DataService.shared.updateClass(classID: classID, studioID: Constant.shared.studio?.ID ?? "Undefined", title: title, instructorName: instructorName, date: date, durationMinute: tenTimesDuration * 10, repetition: Constant.shared.repetitionNumber(repetition: repetition), hall: Constant.shared.studio?.halls?[selectedHall], applicantsCount: applicantsCount, isPopUP: isPopUp)
                                isShowingEditSheet.toggle()
                                isShowingToast.toggle()
                            } else {
                                isShowingErrorToast.toggle()
                            }
                        }
                    } label: {
                        Text("완료")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(isChanged ? Color("Accent") : Color("Gray"))
                    }
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        hideKeyboard()
                    } label: {
                        Text("완료")
                    }
                }
            }
            .onChange(of: title) { _ in
                isChanged = true
            }
            .onChange(of: instructorName) { _ in
                isChanged = true
            }
            .onChange(of: date) { _ in
                isChanged = true
            }
            .onChange(of: tenTimesDuration) { _ in
                isChanged = true
            }
            .onChange(of: isPopUp) { _ in
                isChanged = true
            }
            .onChange(of: repetition) { _ in
                isChanged = true
            }
            .onChange(of: selectedHall) { _ in
                isChanged = true
            }
        }
    }
}

struct EditClassView_Previews: PreviewProvider {
    static var previews: some View {
        EditClassView(isShowingEditSheet: .constant(true), isShowingToast: .constant(false), title: "힙합 클래스", instructorName: "Narae", date: Date(), tenTimesDuration: 6, isPopUp: false, repetition: 1, selectedHall: 0, applicantsCount: 0, classID: "Something")
    }
}
