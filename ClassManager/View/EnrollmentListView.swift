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
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 23) {
            classBanner
                .padding(.top, 18)
            VStack(alignment: .leading, spacing: 12) {
                Text("신청내역")
                    .fontWeight(.bold)
                table
            }
        }
        .navigationTitle(enrolledClass.title ?? "기본 타이틀")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal, 20)
        .onAppear { attachListener() }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.init(uiColor: .label))
                }

            }
        }
    }
    
    var classBanner: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13, style: .circular)
                .foregroundColor(Color("Box"))
            LazyVStack(alignment: .leading, spacing: 4) {
                Text("Hall " + (enrolledClass.hall?.name ?? "A"))
                    .foregroundColor(Color("Gray"))
                    .font(.subheadline)
                HStack(spacing: 0) {
                    if let instructorName = enrolledClass.instructorName {
                        Text("\(instructorName)")
                            .fontWeight(.semibold)
                    }
                    if let title = enrolledClass.title {
                        Text("의 \(title)")
                    }
                }
                Text("\(getTimeString(from: enrolledClass.date)) - \(getTimeString(from: (enrolledClass.date ?? Date()) + TimeInterval(enrolledClass.durationMinute ?? 0) * 60))")
                    .foregroundColor(Color("Gray"))
                    .font(.system(size: 15))
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
        }
        .frame(maxHeight: 106)
    }
    
    var table: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
                .padding(.bottom, 12)
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
            .foregroundColor(Color("Gray"))
            .padding(.bottom, 20)
            tableRows
        }
        .font(.system(size: 15))
    }
    
    var tableRows: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 18) {
                ForEach(enrollmentList, id: \.ID) { enrollment in
                    HStack(alignment: .top, spacing: 22) {
                        Text("0")
                            .frame(width: 27)
                        Text(enrollment.userName ?? "익명")
                            .frame(width: 50)
                        Text(enrollment.phoneNumber ?? "xxx-xxxx-xxxx")
                            .multilineTextAlignment(.leading)
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
            }
    }
    
    var classDescription: String {
        guard let instructorName = enrolledClass.instructorName else {
            return enrolledClass.title ?? "수업"
        }
        
        return "\(instructorName)의 \(enrolledClass.title ?? "수업")"
    }
}

struct EnrollmentListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EnrollmentListView(enrolledClass: Class(ID: "10725BA3-0919-47E1-A2F4-1433EF293055", studioID: "studio1111", title: "힙합 클래스", instructorName: "레이븐", date: Date(), durationMinute: 60, hall: Hall(name: "A", capacity: 30), applicantsCount: nil))
        }
    }
}
