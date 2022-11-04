//
//  AttendanceView.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/11/04.
//

import SwiftUI

struct AttendanceView: View {
    let currentClass: Class
    
    @State var isPresentingConfirm = false
    
    var body: some View {
        VStack {
            classCard
        }
        .padding(20)
        .foregroundColor(.white)
    }
    
    var classCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("클래스")
                .font(.montserrat(.semibold, size: 17))
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Hall \(currentClass.hall?.name ?? "A")")
                        .font(.subheadline)
                        .foregroundColor(Color("Gray"))
                    Spacer()
                    Image(systemName: "ellipsis")
                        .onTapGesture {
                            isPresentingConfirm = true
                        }
                        .confirmationDialog("", isPresented: $isPresentingConfirm) {
                            Button("수정하기", role: .none) {
                                // TODO: Push EditClassView
                            }
                            Button("삭제하기", role: .none) {
                                // TODO: Remove this class
                            }
                            Button("휴강하기", role: .destructive) {
                                // TODO: Make this class suspended
                            }
                        }
                }
                HStack(spacing: 4) {
                    Text(currentClass.instructorName ?? "")
                        .font(.montserrat(.semibold, size: 16))
                    Text("의 \(currentClass.title ?? "")")
                        .font(.callout)
                }
                Text(currentClass.date?.timeRangeString(interval: currentClass.durationMinute ?? 0) ?? "")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color("DarkGray"))
            }
            .padding(20)
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("Box")))
        }
    }
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView(currentClass: Class(ID: "Something", studioID: "", title: "팝업 클래스", instructorName: "Narae", date: Date(), durationMinute: 60, hall: Hall(name: "A", capacity: 30), applicantsCount: 15))
    }
}
