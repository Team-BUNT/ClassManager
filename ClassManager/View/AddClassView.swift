//
//  AddClassView.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/10/12.
//

import SwiftUI

struct AddClassView: View {
    @Binding var isShowingAddSheet: Bool
    @Binding var isShowingToast: Bool
    @State var isShowingErrorToast = false
    
    @State var title = ""
    @State var instructorName = ""
    
    @State var date: Date
    @State var tenTimesDuration = 6
    @State var isPopUp = false
    @State var repetition = 2
    @State var selectedHall = 0
    
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
            .padding(.top, -34)
            .toast(message: "모든 양식을 입력해주세요", isShowing: $isShowingErrorToast, duration: Toast.short)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("새로운 클래스")
                        .font(.system(size: 16))
                        .accessibilityAddTraits(.isHeader)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingAddSheet.toggle()
                    } label: {
                        Text("취소")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if !title.isEmpty && !instructorName.isEmpty {
                            DataService.shared.createClass(studioID: Constant.shared.studio?.ID ?? "Undefined", title: title, instructorName: instructorName, date: date, durationMinute: tenTimesDuration * 10, repetition: Constant.shared.repetitionNumber(repetition: repetition), hall: Constant.shared.studio?.halls?[selectedHall], isPopUP: isPopUp)
                            isShowingAddSheet.toggle()
                            isShowingToast.toggle()
                        } else {
                            isShowingErrorToast.toggle()
                        }
                    } label: {
                        Text("추가")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color("Accent"))
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
        }
    }
}

struct TextFieldRow: View {
    let label: String
    @Binding var value: String
    
    var body: some View {
        TextField(label, text: $value)
            .textInputAutocapitalization(.never)
    }
}

struct StartDateRow: View {
    @Binding var date: Date
    
    var body: some View {
        HStack {
            Text("시작")
            Spacer()
            DatePicker("", selection: $date)
                .labelsHidden()
        }
    }
}

struct DurationRow: View {
    @Binding var tenTimesDuration: Int
    
    var body: some View {
        HStack {
            Text("시간")
            Menu {
                Picker("picker", selection: $tenTimesDuration) {
                    ForEach(5...12, id: \.self) { option in
                        Text("\(option * 10)분")
                    }
                }
                .labelsHidden()
                .pickerStyle(.inline)
                
            } label: {
                HStack {
                    Spacer()
                    Text("\(tenTimesDuration * 10)분")
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct ClassTypeRow: View {
    @Binding var isPopUp: Bool
    var isDisabled = false
    
    var body: some View {
        HStack {
            Text("수업 형태")
            Picker("", selection: $isPopUp) {
                Text("정규").tag(false)
                Text("팝업").tag(true)
            }
            .disabled(isDisabled)
        }
    }
}

struct repetitionRow: View {
    let repetitionOptions = ["안함", "2회", "4회", "8회"]
    
    @Binding var repetition: Int
    
    var body: some View {
        HStack {
            Text("반복")
            Picker("", selection: $repetition) {
                ForEach(0 ..< repetitionOptions.count, id: \.self) {
                    Text(repetitionOptions[$0]).tag($0)
                }
            }
        }
    }
}

struct hallRow: View {
    @Binding var selectedHall: Int
    
    var body: some View {
        HStack {
            Text("홀")
            if Constant.shared.studio != nil && Constant.shared.studio!.halls != nil {
                Picker("", selection: $selectedHall) {
                    ForEach(0 ..< Constant.shared.studio!.halls!.count, id: \.self) {
                        Text(Constant.shared.studio!.halls![$0].name ?? "").tag($0)
                    }
                }
            }
        }
    }
}

struct AddClassView_Previews: PreviewProvider {
    static var previews: some View {
        AddClassView(isShowingAddSheet: .constant(true), isShowingToast: .constant(false), date: Date())
    }
}
