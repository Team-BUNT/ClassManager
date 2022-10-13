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
    @State var isShowingLinkToast = false
    
    @State private var selectedDate = Date()
    @State private var classesToday = [Class]()
    
    // TODO: 신청폼 링크 실제 데이터로 교체
    let link = "https://this.is.sample.link"
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .padding(16)
                    .datePickerStyle(.graphical)
                    .accentColor(Color("Del"))
                    .background(RoundedRectangle(cornerRadius: 13).foregroundColor(Color("Box")))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)

                ScrollView {
                    ForEach(classesToday, id: \.self.ID) { danceClass in
                        ClassInfoBox(danceClass: danceClass)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
            .toast(message: "클래스가 추가되었습니다", isShowing: $isShowingSaveToast, duration: Toast.short)
            .toast(message: "신청폼 링크가 복사되었습니다", isShowing: $isShowingLinkToast, duration: Toast.short)
            .sheet(isPresented: $isShowingAddSheet) {
                AddClassView(isShowingAddSheet: $isShowingAddSheet, isShowingToast: $isShowingSaveToast, date: selectedDate)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("CLASS 관리")
                        .font(.custom(FontManager.Montserrat.semibold, size: 15))
                        .accessibilityAddTraits(.isHeader)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        UIPasteboard.general.string = link
                        isShowingLinkToast.toggle()
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
        .onAppear {
            if Constant.shared.classes != nil {
                classesToday = Constant.shared.classes!.filter{ $0.date != nil && Calendar.current.isDate($0.date!, inSameDayAs: selectedDate) }
            }
        }
        .onChange(of: selectedDate) { date in
            if Constant.shared.classes != nil {
                classesToday = Constant.shared.classes!.filter{ $0.date != nil && Calendar.current.isDate($0.date!, inSameDayAs: selectedDate) }
            }
        }
        .task {
            do {
                // TODO: studioID 실제 데이터로 교체
                Constant.shared.studio = try await DataService.shared.requestStudioBy(studioID: "SampleID")
                Constant.shared.classes = try await DataService.shared.requestAllClassesBy(studioID: "SampleID")
            } catch {
                print(error)
            }
            classesToday = Constant.shared.classes!.filter{ $0.date != nil && Calendar.current.isDate($0.date!, inSameDayAs: selectedDate)
            }
        }
    }
}

struct ClassCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ClassCalendarView()
    }
}
