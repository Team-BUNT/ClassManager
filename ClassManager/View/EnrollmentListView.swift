//
//  EnrollmentListView.swift
//  ClassManager
//
//  Created by 김남건 on 2022/10/12.
//

import SwiftUI

struct EnrollmentListView: View {
    let enrolledClass = Class(ID: "id1234", studioID: "studio1111", title: "Narae의 팝업 클래스", instructorName: "Narae", date: Date(), durationMinute: 60, repetition: nil, hall: Hall(name: "Hall A", capacity: 30), applicantsCount: nil)
    
    let dummyData = [
        Enrollment(ID: "1", classID: "1", number: 1, userName: "강지인", phoneNumber: "010-1234-5678", enrolledDate: Date(), paid: false),
        Enrollment(ID: "2", classID: "1", number: 2, userName: "강지인", phoneNumber: "010-1234-5678", enrolledDate: Date() - 60.0, paid: true),
        Enrollment(ID: "3", classID: "1", number: 3, userName: "강지인", phoneNumber: "010-1234-5678", enrolledDate: Date() - 120.0, paid: true),
        Enrollment(ID: "4", classID: "1", number: 4, userName: "강지인", phoneNumber: "010-1234-5678", enrolledDate: Date(), paid: true),
        Enrollment(ID: "5", classID: "1", number: 5, userName: "강지인", phoneNumber: "010-1234-5678", enrolledDate: Date(), paid: true),
        Enrollment(ID: "6", classID: "1", number: 6, userName: "강지인", phoneNumber: "010-1234-5678", enrolledDate: Date(), paid: true),
        Enrollment(ID: "7", classID: "1", number: 7, userName: "강지인", phoneNumber: "010-1234-5678", enrolledDate: Date(), paid: true),
        Enrollment(ID: "8", classID: "1", number: 8, userName: "강지인", phoneNumber: "010-1234-5678", enrolledDate: Date(), paid: true),
        Enrollment(ID: "9", classID: "1", number: 9, userName: "강지인", phoneNumber: "010-1234-5678", enrolledDate: Date(), paid: true),
        Enrollment(ID: "10", classID: "1", number: 10, userName: "강지인", phoneNumber: "010-1234-5678", enrolledDate: Date(), paid: true),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 17) {
            classBanner
            VStack(alignment: .leading, spacing: 6) {
                Text("신청내역")
                    .fontWeight(.bold)
                table
            }
            .padding(.leading, 24)
            .padding(.trailing, 9)
                
        }
        .navigationTitle(enrolledClass.title ?? "기본 타이틀")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var classBanner: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13, style: .circular)
                .foregroundColor(Color("Box"))
            HStack {
                VStack(alignment: .leading) {
                    Text(enrolledClass.hall?.name ?? "기본 홀")
                    Spacer()
                    Text(enrolledClass.title ?? "기본 타이틀")
                        .bold()
                }
                Spacer()
                VStack {
                    Text(getTimeString(from: enrolledClass.date))
                    Spacer()
                    Text(getTimeString(from: (enrolledClass.date ?? Date()) + Double(enrolledClass.durationMinute ?? 0) * 60))
                }
            }
            .padding(.top, 14)
            .padding(.bottom, 17)
            .padding(.horizontal, 17)
        }
        .frame(height: 77)
        .padding(.horizontal, 24)
    }
    
    var table: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
                .padding(.trailing, 15)
                .padding(.bottom, 6)
            HStack(spacing: 0) {
                Text("No.")
                    .padding(.trailing, 22)
                Text("성명")
                    .padding(.trailing, 44)
                Text("연락처")
                    .padding(.trailing, 41)
                Text("신청시각")
                    .padding(.trailing, 41)
                Text("상태")
            }
            .padding(.bottom, 12)
            tableRows
        }
    }
    
    var tableRows: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                ForEach(dummyData, id: \.ID) { enrollment in
                    HStack(spacing: 0) {
                        Text("\(enrollment.number ?? 0)")
                            .frame(width: 25)
                            .padding(.trailing, 14)
                        Text(enrollment.userName ?? "익명")
                            .frame(width: 50)
                            .padding(.trailing, 27)
                        Text(getFormattedPhoneNumberString(from: enrollment.phoneNumber ?? "xxx-xxxx-xxxx"))
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing, 29)
                        Text("\(getMinutesAgo(from: enrollment.enrolledDate))분 전")
                            .padding(.trailing, 28)
                        Text(getPaidStatusString(from: enrollment.paid))
                            .foregroundColor((enrollment.paid ?? false) ? Color("Del") : Color(uiColor: UIColor.label))
                    }
                }
            }
        }
    }
    
    private func getTimeString(from date: Date?) -> String {
        if let date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            return dateFormatter.string(from: date)
        } else {
            return "xx:xx"
        }
    }
    
    private func getFormattedPhoneNumberString(from phoneNumber: String?) -> String {
        guard let phoneNumber else {
            return "xxx-xxxx-\nxxxx"
        }
        
        let arr = phoneNumber.components(separatedBy: "-")
        
        return "\(arr[0])-\(arr[1])\n-\(arr[2])"
    }
    
    private func getMinutesAgo(from date: Date?) -> Int {
        guard let date else {
            return 0
        }
        
        let timeInterval = Date().timeIntervalSince(date)
        
        return Int(timeInterval / 60)
    }
    
    private func getPaidStatusString(from paid: Bool?) -> String {
        guard let paid else {
            return "에러발생"
        }
        
        return paid ? "결제완료" : "결제대기"
    }
}

struct EnrollmentListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EnrollmentListView()
        }
    }
}
