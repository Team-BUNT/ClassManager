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
    @State var repetition = 0
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
                    startDateRow(date: $date)
                    durationRow(tenTimesDuration: $tenTimesDuration)
                }
                .onTapGesture { hideKeyboard() }
                
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
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if !title.isEmpty && !instructorName.isEmpty {
                            DataService.shared.createClass(studioID: Constant.shared.studio?.ID ?? "Undefined", title: title, instructorName: instructorName, date: date, durationMinute: tenTimesDuration*10, repetition: repetitionNumber(repetition: repetition), hall: Constant.shared.studio?.halls?[selectedHall])
                            isShowingAddSheet.toggle()
                            isShowingToast.toggle()
                        } else {
                            isShowingErrorToast.toggle()
                        }
                    } label: {
                        Text("추가")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color("Del"))
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
            TextField("", text: $value)
                .textInputAutocapitalization(.never)
                .placeholder(when: value.isEmpty) {
                    Text(label).foregroundColor(.gray)
                }
        }
    }
    
    struct startDateRow: View {
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
    
    struct durationRow: View {
//        @Binding var duration: String
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
}

//MARK: TextField의 placeholder를 커스텀 해준다.
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

//MARK: 키보드를 내리는 메소드. View에서 사용하기 위함
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



struct AddClassView_Previews: PreviewProvider {
    static var previews: some View {
        AddClassView(isShowingAddSheet: .constant(true), isShowingToast: .constant(false), date: Date())
    }
}
