//
//  ClassCalendarView.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/10/12.
//

import SwiftUI

struct ClassCalendarView: View {
    @State var isShowingAddSheet = false
    @State var isShowingSaveToast = false
    
    @State private var date = Date()
    @State var dummyClass = Class(
        ID: "classID",
        studioID: "studioID",
        title: "팝업 클래스",
        instructorName: "Narae",
        date: Calendar.current.date(
            from: DateComponents(year: 2022, month: 10, day: 14, hour: 20, minute: 0)
        ),
        durationMinute: 60,
        hall: Hall(name: "Hall A", capacity: 40),
        applicantsCount: 30
    )
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Pick a class date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .padding()
                .datePickerStyle(.graphical)
                .accentColor(Color("Del"))
                .background(
                    Color("Box"),
                    in: RoundedRectangle(cornerRadius: 13)
                ).padding(.bottom, 10)


                ScrollView {
                    NavigationLink(
                        destination: Text("asdf"),
                        label: {
                            ClassInfoBox(danceClass: $dummyClass)
                        })
                    Divider()

                    NavigationLink(
                        destination: Text("asdf"),
                        label: {
                            ClassInfoBox(danceClass: $dummyClass)
                        })
                    Divider()

                    NavigationLink(
                        destination: Text("asdf"),
                        label: {
                            ClassInfoBox(danceClass: $dummyClass)
                        })
                    Divider()

                }
                Spacer()
            }
            .toast(message: "클래스가 추가되었습니다", isShowing: $isShowingSaveToast, duration: Toast.short)
            .sheet(isPresented: $isShowingAddSheet) {
                AddClassView(isShowingAddSheet: $isShowingAddSheet, isShowingToast: $isShowingSaveToast)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("CLASS 관리")
                        .accessibilityAddTraits(.isHeader)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("링크 복사하기")
                    } label: {
                        Image(systemName: "link")
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingAddSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .task {
            do {
                Constant.shared.studio = try await DataService.shared.requestStudioBy(studioID: "SampleID")
                Constant.shared.classes = try await DataService.shared.requestAllClassesBy(studioID: "SampleID")
            } catch {
                print(error)
            }
        }
    }
}

struct ClassCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ClassCalendarView()
    }
}
