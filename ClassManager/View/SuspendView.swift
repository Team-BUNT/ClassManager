//
//  SuspendView.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/11/05.
//

import SwiftUI

struct SuspendView: View {
    let currentClass: Class
    let enrollments: [Enrollment]
    
    @State var students = [Student]()
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var isShowingToast: Bool
    
    @State var selectedReason = ""
    @State var selectedIndex: Int?
    
    @State var suspendedReason = ""
    
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
                    suspendedReason = reason
                }
            }
            if selectedIndex == 4 {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 106)
                        .foregroundColor(Color("Box"))
                    if suspendedReason.isEmpty {
                        Text("수강생에게 전달될 휴강 사유를 직접 입력해주세요.")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(Color("DarkGray"))
                            .padding(12)
                    }
                    if #available(iOS 16.0, *) {
                        TextEditor(text: $suspendedReason)
                            .scrollContentBackground(.hidden)
                            .padding(.leading, 6)
                            .padding(.top, 1)
                    } else {
                        TextEditor(text: $suspendedReason)
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
        .task {
            do {
                students = try await DataService.shared.requestAllStudents(of: currentClass.studioID ?? "") ?? [Student]()
                students = students.filter({ $0.coupons.contains(where: { $0.classID == currentClass.ID }) })
            } catch {
            }
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
                    guard let instructorName = currentClass.instructorName,
                          let date = currentClass.date,
                          let studioID = currentClass.studioID,
                          let durationMinute = currentClass.durationMinute,
                          let title = currentClass.title,
                          let _ = selectedIndex else { return }
                        
                    Task {
                        await DataService.shared.updateSuspendedClasses(classID: currentClass.ID, studioID: studioID)

                        for enrollment in enrollments {
                            guard let studioName = DataService.StudioName(rawValue: studioID),
                                  let phoneNumber = enrollment.phoneNumber,
                                  let userName = enrollment.userName else { return }
                            
                             DataService.shared.requestSuspendedAlimTalk(
                                to: phoneNumber,
                                disableSms: true,
                                from: "01024405830",
                                studioName: studioName.getStudioName(),
                                studentName: userName,
                                instructorName: instructorName,
                                genre: title,
                                time: date.timeRangeString(interval: durationMinute),
                                suspended: suspendedReason,
                                studioPhoneNumber: studioName.getStudioPhoneNumber()
                             )
                        }
                    }
                    refundCoupons()
                    isShowingToast.toggle()
                    presentationMode.wrappedValue.dismiss()
                    
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
    
    func refundCoupons() {
        // update coupon
        for student in students {
            for coupon in student.coupons {
                if coupon.classID == currentClass.ID {
                    coupon.classID = nil
                    DataService.shared.updateStudentCoupons(student: student, coupons: student.coupons)
                }
            }
        }
        
        // update enrollment
        for enrollment in enrollments {
            if enrollment.paymentType == "쿠폰 결제" || enrollment.paymentType == "쿠폰 사용" {
                enrollment.isRefunded = true
                
                // update enrollment
                DataService.shared.updateEnrollment(enrollment: enrollment)
                
                // update enrollments in student
                if let student = students.filter({ $0.enrollments.contains(where: { $0.ID == enrollment.ID }) }).first {
                    for enrolment in student.enrollments {
                        if enrolment.classID == currentClass.ID {
                            enrolment.isRefunded = true
                            DataService.shared.updateStudentEnrollments(student: student)
                        }
                    }
                }
            }
        }
    }
}
