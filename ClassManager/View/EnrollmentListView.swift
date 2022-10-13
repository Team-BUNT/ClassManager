//
//  EnrollmentListView.swift
//  ClassManager
//
//  Created by 김남건 on 2022/10/12.
//

import SwiftUI
import FirebaseFirestore

struct EnrollmentListView: View {
    let enrolledClass: Class
    
    @State private var enrollmentList = [Enrollment]()
    
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
        .onAppear { attachListener() }
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
            HStack(spacing: 22) {
                Text("No.")
                    .frame(width: 27)
                Text("성명")
                    .frame(width: 50)
                Text("연락처")
                    .frame(width: 70)
                Text("신청시각")
                    .frame(width: 60)
                Text("상태")
                    .frame(width: 60)
            }
            .padding(.bottom, 12)
            tableRows
        }
        .font(.system(size: 15))
    }
    
    var tableRows: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                ForEach(enrollmentList, id: \.ID) { enrollment in
                    HStack(spacing: 22) {
                        Text("\(enrollment.number ?? 0)")
                            .frame(width: 27)
                        Text(enrollment.userName ?? "익명")
                            .frame(width: 50)
                        Text(getFormattedPhoneNumberString(from: enrollment.phoneNumber ?? "xxx-xxxx-xxxx"))
                            .multilineTextAlignment(.trailing)
                            .frame(width: 70)
                        if getMinutesAgo(from: enrollment.enrolledDate) < 60 {
                            Text("\(getMinutesAgo(from: enrollment.enrolledDate))분 전")
                                .frame(width: 60)
                        } else if getMinutesAgo(from: enrollment.enrolledDate) / 60 < 24 {
                            Text("\(getMinutesAgo(from: enrollment.enrolledDate) / 60)시간 전")
                                .frame(width: 60)
                        } else {
                            Text("\(getMinutesAgo(from: enrollment.enrolledDate) / 1440)일 전")
                                .frame(width: 60)
                        }
                        Text(getPaidStatusString(from: enrollment.paid))
                            .foregroundColor((enrollment.paid ?? false) ? Color("Del") : Color(uiColor: UIColor.label))
                            .frame(width: 60)
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
    
    private func attachListener() {
        Firestore.firestore().collection("enrollment").whereField("classID", isEqualTo: enrolledClass.ID)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                enrollmentList = documents.map { Enrollment(documentSnapShot: $0) }
                    .sorted(by: {
                        $0.enrolledDate ?? Date() > $1.enrolledDate ?? Date()
                    })
            }
    }
}

struct EnrollmentListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EnrollmentListView(enrolledClass: Class(ID: "07172CCF-CE6B-48EE-94F6-983CE4CF4185", studioID: "studio1111", title: "Narae의 팝업 클래스", instructorName: "Narae", date: Date(), durationMinute: 60, hall: Hall(name: "Hall A", capacity: 30), applicantsCount: nil))
        }
    }
}
