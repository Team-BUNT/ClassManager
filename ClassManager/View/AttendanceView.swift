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
    @State var isAllChecked = false
    
    let columnRatio: [Double] = [5/32, 7/32, 7/16, 3/16]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                classCard
                studentList
                    .padding(.top, 32)
            }
            .padding(20)
            .foregroundColor(.white)
        }
        .navigationTitle("출석부")
        .task {
            // TODO: Fetch enrollments
        }
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
    
    var studentList: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("수강생")
                .font(.montserrat(.semibold, size: 17))
            
            HStack {
                attendanceStatus
                Spacer()
                saveButton
                    .onTapGesture {
                        // TODO: Update attendance status
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
                Text("11")
            }
            HStack(spacing: 0) {
                Text("미출석 ")
                    .font(.system(size: 15))
                Text("5")
            }
            .foregroundColor(Color("Accent"))
        }
    }
    
    var saveButton: some View {
        Text("저장")
            .font(.system(size: 15))
            .background(RoundedRectangle(cornerRadius: 7).frame(width: 60, height: 33).foregroundColor(Color("Box")))
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
                HStack(spacing: 10) {
                    Text("All")
                        .frame(width: (geometry.size.width - 30) * columnRatio[0])
                        .font(.montserrat(.semibold, size: 15))
                    Text("")
                        .frame(width: (geometry.size.width - 30) * columnRatio[1])
                    Text("")
                        .frame(width: (geometry.size.width - 30) * columnRatio[2])
                    
                    ZStack {
                        if isAllChecked {
                            boxChecked
                        } else {
                            boxUnchecked
                        }
                    }
                    .frame(width: (geometry.size.width - 30) * columnRatio[3])
                    .onTapGesture {
                        isAllChecked.toggle()
                    }
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
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView(currentClass: Class(ID: "Something", studioID: "", title: "팝업 클래스", instructorName: "Narae", date: Date(), durationMinute: 60, hall: Hall(name: "A", capacity: 30), applicantsCount: 15))
    }
}
