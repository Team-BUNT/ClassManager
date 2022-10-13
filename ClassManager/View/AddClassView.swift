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
    @State var duration = ""
    @State var repetition = 0
    @State var selectedHall = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextFieldRow(label: "Title", value: $title)
                    TextFieldRow(label: "Instructor", value: $instructorName)
                }
                
                Section {
                    startDateRow(date: $date)
                    durationRow(duration: $duration)
                }
                
                Section {
                    repetitionRow(repetition: $repetition)
                }
                
                Section {
                    hallRow(selectedHall: $selectedHall)
                }
            }
            .toast(message: "모든 양식을 입력해주세요", isShowing: $isShowingErrorToast, duration: Toast.short)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("NEW CLASS")
                        .font(.custom(FontManager.Montserrat.semibold, size: 15))
                        .accessibilityAddTraits(.isHeader)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingAddSheet.toggle()
                    } label: {
                        Text("취소")
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if !title.isEmpty && !instructorName.isEmpty && !duration.isEmpty {
                            DataService.shared.createClass(studioID: Constant.shared.studio?.ID ?? "Undefined", title: title, instructorName: instructorName, date: date, durationMinute: Int(duration) ?? 0, repetition: repetitionNumber(repetition: repetition), hall: Constant.shared.studio?.halls?[selectedHall])
                            isShowingAddSheet.toggle()
                            isShowingToast.toggle()
                        } else {
                            isShowingErrorToast.toggle()
                        }
                    } label: {
                        Text("추가")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    func repetitionNumber(repetition: Int) -> Int {
        switch repetition {
        case 0: return 1
        case 1: return 2
        case 2: return 4
        case 3: return 8
        default: return 0
        }
    }
    
    struct TextFieldRow: View {
        let label: String
        @Binding var value: String
        
        var body: some View {
            HStack {
                Text(label)
                TextField("", text: $value)
            }
        }
    }
    
    struct startDateRow: View {
        @Binding var date: Date
        
        var body: some View {
            HStack {
                Text("시작")
                Spacer()
                DatePicker("", selection: $date).labelsHidden()
            }
        }
    }
    
    struct durationRow: View {
        @Binding var duration: String
        
        var body: some View {
            HStack {
                Text("시간")
                Spacer()
                TextField("", text: $duration)
                    .keyboardType(.decimalPad)
                    .frame(width: 30)
                Text("분")
            }
        }
    }
    
    struct repetitionRow: View {
        let repetitionOptions = ["1회", "2회", "4회", "8회"]

        @Binding var repetition: Int
        
        var body: some View {
            HStack {
                Text("수업 횟수")
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
}


struct AddClassView_Previews: PreviewProvider {
    static var previews: some View {
        AddClassView(isShowingAddSheet: .constant(true), isShowingToast: .constant(false), date: Date())
    }
}
