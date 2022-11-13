//
//  AttendanceView.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/11/04.
//

import SwiftUI

struct AttendanceView: View {
    @State var currentClass: Class
    
    @State var isPresentingConfirm = false
    @State var isAllChecked = false
    @State var isShowingFailAlert = false
    @State var isShowingDeleteAlert = false
    @State var isNavigationLinkActive = false
    @State var isShowingEditSheet = false
    @State var isShowingToast = false
    @State var isShowingUpdateToast = false
    @State var isChanged = false
    
    @State var enrollments = [Enrollment]()
        
    let columnRatio: [Double] = [5/32, 7/32, 7/16, 3/16]
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        if isNavigationLinkActive {
            NavigationLink("", destination: SuspendView(currentClass: currentClass), isActive: $isNavigationLinkActive)
        }
        
        ScrollView {
            VStack(spacing: 0) {
                classCard
                studentList
                    .padding(.top, 32)
            }
            .padding(20)
            .foregroundColor(.white)
        }
        .onChange(of: isShowingEditSheet) { _ in
            currentClass = Constant.shared.classes?.filter({ $0.ID == currentClass.ID }).first ?? currentClass
        }
        .toast(message: "클래스가 수정되었습니다", isShowing: $isShowingToast, duration: Toast.short)
        .toast(message: "현재 출결 상태가 저장되었습니다.", isShowing: $isShowingUpdateToast, duration: Toast.short)
        .alert("삭제하기", isPresented: $isShowingFailAlert, actions: {
            Button("확인", role: .cancel) {}
        }, message: {
            Text("수강생이 있어 삭제가 불가능합니다.\n‘휴강하기’를 선택해주세요.")
        })
        .alert("삭제하기", isPresented: $isShowingDeleteAlert, actions: {
            Button("취소", role: .cancel) {}
            Button("확인", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
                Constant.shared.classes = Constant.shared.classes!.filter( { $0.ID != currentClass.ID } )
                DataService.shared.deleteClass(classID: currentClass.ID)
            }
        }, message: {
            Text("클래스를 삭제하시겠습니까?")
        })
        .fullScreenCover(isPresented: $isShowingEditSheet) {
            EditClassView(isShowingEditSheet: $isShowingEditSheet, isShowingToast: $isShowingToast, title: currentClass.title ?? "", instructorName: currentClass.instructorName ?? "", date: currentClass.date ?? Date(), tenTimesDuration: (currentClass.durationMinute ?? 60) / 10, isPopUp: currentClass.isPopUp ?? false, repetition: 0, selectedHall: hallIndex(), applicantsCount: currentClass.applicantsCount ?? 0, classID: currentClass.ID)
        }
        .navigationTitle("출석부")
        .task {
            do {
                enrollments = try await DataService.shared.requestEnrollmentsBy(classID: currentClass.ID) ?? []
                enrollments = enrollments.filter( { $0.paid ?? false } )
                sortEnrollments()
                if attendanceCount() == enrollments.count {
                    isAllChecked = true
                }
            } catch {
                print(error)
            }
        }
    }
    
    var classCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("클래스")
                .font(.montserrat(.semibold, size: 17))
            if Constant.shared.isSuspended(classID: currentClass.ID) {
                Text("클래스가 휴강 처리 되었습니다.")
                    .font(.system(size: 14))
                    .foregroundColor(Color("DarkGray"))
            }
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Hall \(currentClass.hall?.name ?? "A")")
                            .font(.subheadline)
                            .foregroundColor(Constant.shared.isSuspended(classID: currentClass.ID) ? Color("DarkGray") : Color("Gray"))
                        Spacer()
                    }
                    HStack(spacing: 4) {
                        Text(currentClass.instructorName ?? "")
                            .font(.montserrat(.semibold, size: 16))
                            .strikethrough(Constant.shared.isSuspended(classID: currentClass.ID))
                        Text("의 \(currentClass.title ?? "")")
                            .font(.callout)
                            .strikethrough(Constant.shared.isSuspended(classID: currentClass.ID))
                    }
                    .foregroundColor(Constant.shared.isSuspended(classID: currentClass.ID) ? Color("DarkGray") : .white)
                    Text(currentClass.date?.timeRangeString(interval: currentClass.durationMinute ?? 0) ?? "")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color("DarkGray"))
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("Box")))
                
                if !Constant.shared.isSuspended(classID: currentClass.ID) {
                    Image(systemName: "ellipsis")
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                        .padding(.top, 5)
                        .padding(.trailing, 5)
                        .onTapGesture {
                            isPresentingConfirm = true
                        }
                        .confirmationDialog("", isPresented: $isPresentingConfirm) {
                            Button("취소", role: .cancel) {
                            }
                            Button("수정하기", role: .none) {
                                isShowingEditSheet.toggle()
                            }
                            if enrollments.isEmpty {
                                Button("삭제하기", role: .destructive) {
                                    if enrollments.count > 0 {
                                        isShowingFailAlert = true
                                    } else {
                                        isShowingDeleteAlert = true
                                    }
                                }
                            }
                            else {
                                Button("휴강하기", role: .destructive) {
                                    isNavigationLinkActive = true
                                }
                            }
                        }
                }
            }
        }
    }
    
    var studentList: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("수강생")
                .font(.montserrat(.semibold, size: 17))
            
            HStack {
                attendanceStatus
                Spacer()
                saveButton
                    .padding(.trailing, 20)
                    .onTapGesture {
                        if !Constant.shared.isSuspended(classID: currentClass.ID) && isChanged {
                            DataService.shared.updateAttendance(enrollments: enrollments)
                            isChanged = false
                            isShowingUpdateToast.toggle()
                        }
                    }
            }
            .font(.montserrat(.semibold, size: 15))
            
            Divider()
                .padding(.top, 6)
            
            studentListHeader
            studentListBody
        }
    }
    
    var attendanceStatus: some View {
        HStack(spacing: 8) {
            HStack(spacing: 0) {
                Text("출석 ")
                    .font(.system(size: 15))
                Text("\(attendanceCount())")
            }
            HStack(spacing: 0) {
                Text("미출석 ")
                    .font(.system(size: 15))
                Text("\(enrollments.count - attendanceCount())")
            }
            .foregroundColor(Color("Accent"))
        }
    }
    
    var saveButton: some View {
        Text("저장")
            .font(.system(size: 15))
            .foregroundColor(isChanged ? .black : .white)
            .background(RoundedRectangle(cornerRadius: 7).frame(width: 60, height: 33).foregroundColor(isChanged ? Color("Accent") : Color("Box")))
    }
    
    var studentListHeader: some View {
        GeometryReader { geometry in
            HStack(spacing: 10) {
                Text("No.")
                    .frame(width: (geometry.size.width - 30) * columnRatio[0])
                Text("성명")
                    .frame(width: (geometry.size.width - 30) * columnRatio[1])
                Text("연락처")
                    .frame(width: (geometry.size.width - 30) * columnRatio[2])
                Text("출결상태")
                    .frame(width: (geometry.size.width - 30) * columnRatio[3])
            }
            .foregroundColor(Color("DarkGray"))
            .font(.system(size: 15))
        }
    }
    
    var studentListBody: some View {
        GeometryReader { geometry in
            VStack(spacing: 35) {
                if enrollments.count > 0 {
                    HStack(spacing: 10) {
                        Text("All")
                            .frame(width: (geometry.size.width - 30) * columnRatio[0])
                            .font(.montserrat(.semibold, size: 15))
                        Text("")
                            .frame(width: (geometry.size.width - 30) * columnRatio[1])
                        Text("")
                            .frame(width: (geometry.size.width - 30) * columnRatio[2])
                        if Constant.shared.isSuspended(classID: currentClass.ID) {
                            boxUnabled
                                .frame(width: (geometry.size.width - 30) * columnRatio[3])
                        } else {
                            ZStack {
                                if isAllChecked {
                                    boxChecked
                                } else {
                                    boxUnchecked
                                }
                            }
                            .frame(width: (geometry.size.width - 30) * columnRatio[3])
                            .onTapGesture {
                                isChanged = true
                                isAllChecked.toggle()
                                if isAllChecked {
                                    allChecked()
                                } else {
                                    allUnchecked()
                                }
                            }
                        }
                    }
                }
                ForEach(Array(enrollments.enumerated()), id: \.offset) { index, enrollment in
                    HStack(spacing: 10) {
                        Text("\(enrollments.count - index)")
                            .frame(width: (geometry.size.width - 30) * columnRatio[0])
                            .font(.montserrat(.semibold, size: 15))
                        Text(enrollment.userName ?? "")
                            .frame(width: (geometry.size.width - 30) * columnRatio[1])
                        Text(enrollment.phoneNumber ?? "")
                            .frame(width: (geometry.size.width - 30) * columnRatio[2])
                            .font(.montserrat(.semibold, size: 15))
                        if Constant.shared.isSuspended(classID: currentClass.ID) {
                            boxUnabled
                                .frame(width: (geometry.size.width - 30) * columnRatio[3])
                        } else {
                            ZStack {
                                if enrollment.attendance ?? false {
                                    boxChecked
                                } else {
                                    boxUnchecked
                                }
                            }
                            .frame(width: (geometry.size.width - 30) * columnRatio[3])
                            .onTapGesture {
                                isChanged = true
                                enrollment.attendance?.toggle()
                                enrollments = enrollments.map { $0 }
                                if attendanceCount() == enrollments.count {
                                    isAllChecked = true
                                } else {
                                    isAllChecked = false
                                }
                            }
                        }
                    }
                    .font(.system(size: 15))
                }
            }
            .padding(.top, 20)
        }
    }
    
    var boxChecked: some View {
        Image(systemName: "checkmark.square.fill")
            .font(.system(size: 20))
            .foregroundColor(Color("Accent"))
    }
    
    var boxUnchecked: some View {
        Image(systemName: "square")
            .font(.system(size: 20))
            .foregroundColor(Color("CheckGray"))
    }
    
    var boxUnabled: some View {
        Image(systemName: "square.fill")
            .font(.system(size: 20))
            .foregroundColor(Color("CheckGray"))
    }
    
    private func attendanceCount() -> Int {
        if enrollments.count > 0 {
            var count = 0
            enrollments.forEach { enrollment in
                if enrollment.attendance ?? false { count += 1 }
            }
            return count
        }
        return 0
    }
    
    private func allChecked() {
        enrollments.forEach { enrollment in
            enrollment.attendance = true
        }
    }
    
    private func allUnchecked() {
        enrollments.forEach { enrollment in
            enrollment.attendance = false
        }
    }
    
    private func sortEnrollments() {
        enrollments.sort(by: { $0.enrolledDate ?? Date() > $1.enrolledDate ?? Date() })
    }
    
    private func hallIndex() -> Int {
        for index in 0..<(Constant.shared.studio?.halls?.count ?? 0) {
            if Constant.shared.studio?.halls?[index].name == currentClass.hall?.name {
                return index
            }
        }
        return 0
    }
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView(currentClass: Class(ID: "Something", studioID: "", title: "팝업 클래스", instructorName: "Narae", date: Date(), durationMinute: 60, hall: Hall(name: "A", capacity: 30), applicantsCount: 15, isPopUp: false))
    }
}
