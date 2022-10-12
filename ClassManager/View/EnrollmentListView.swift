//
//  EnrollmentListView.swift
//  ClassManager
//
//  Created by 김남건 on 2022/10/12.
//

import SwiftUI

struct EnrollmentListView: View {
    let enrolledClass = Class(ID: "id1234", studioID: "studio1111", title: "Narae의 팝업 클래스", instructorName: "Narae", date: Date(), durationMinute: 60, repetition: nil, hall: Hall(name: "Hall A", capacity: 30), applicantsCount: nil)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 17) {
            classBanner
            VStack(alignment: .leading, spacing: 6) {
                Text("신청내역")
                    .fontWeight(.bold)
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
    
    private func getTimeString(from date: Date?) -> String {
        if let date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            return dateFormatter.string(from: date)
        } else {
            return "xx:xx"
        }
    }
}

struct EnrollmentListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EnrollmentListView()
        }
    }
}
