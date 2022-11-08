//
//  StudentInfoView.swift
//  ClassManager
//
//  Created by 김남건 on 2022/11/08.
//

import SwiftUI

struct StudentInfoView: View {
    @State private var student: Student = Student(ID: "ddd", studioID: "BuntStudioSample", phoneNumber: "01012340101", subPhoneNumber: nil, name: "김철수", enrollments: [
        Enrollment(ID: "Bunt-Class1-Sample1", classID: "Bunt-Class1", studioID: "BuntStudioSample", userName: "김철수", phoneNumber: "01012340101", enrolledDate: Date(), paid: false),
        Enrollment(ID: "Bunt-Class4-Sample1", classID: "Bunt-Class4", studioID: "BuntStudioSample", userName: "김철수", phoneNumber: "01012340101", enrolledDate: Date(), paid: false),
        Enrollment(ID: "Bunt-Class5-Sample1", classID: "Bunt-Class5", studioID: "BuntStudioSample", userName: "김철수", phoneNumber: "01012340101", enrolledDate: Date(), paid: false)
    ], coupons: [
        Student.Coupon(studioID: "BuntStudioSample", studentID: "ddd", isFreePass: false, expiredDate: Date()),
        Student.Coupon(studioID: "BuntStudioSample", studentID: "ddd", isFreePass: false, expiredDate: Date()),
        Student.Coupon(studioID: "BuntStudioSample", studentID: "ddd", isFreePass: true, expiredDate: Date() + 86400)
    ])
    
    var body: some View {
        VStack(alignment: .leading, spacing: 38) {
            personalInfoView
                .padding(.top, 20)
            
            couponsView
            
            enrollmentsView
            
            Spacer()
        }
        .navigationTitle("수강생 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var personalInfoView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("개인 정보")
                .font(.montserrat(.semibold, size: 17))
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(student.name ?? "익명")")
                        .font(.subheadline)
                    Text("\(student.phoneNumber ?? "xxxxxxxxxxx")")
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color("InfoBox")))
        }
        .padding(.horizontal, 20)
    }
    
    var couponsView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("잔여 쿠폰")
                .font(.montserrat(.semibold, size: 17))
            ScrollView(.horizontal) {
                HStack(spacing: 14) {
                    ForEach(student.groupedCoupons, id: \.[0].expiredDate) { group in
                        couponView(couponGroup: group)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    func couponView(couponGroup: [Student.Coupon]) -> some View {
        let expiredDateString = (couponGroup[0].expiredDate ?? Date()).formattedString(format: "yyyy.MM.dd")
        let dateGap = (couponGroup[0].expiredDate ?? Date()).dateGap(from: Date())
        
        return VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(Color("InfoBox"))
                    .frame(width: 72, height: 85)
                Text((couponGroup[0].isFreePass ?? false) ? "프리패스" : "\(couponGroup.count)회")
            }
            Text("\(expiredDateString)\nD-\(dateGap)")
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .foregroundColor(Color("InfoDate"))
        }
    }
    
    var enrollmentsView: some View {
        VStack(spacing: 21) {
            HStack(alignment: .top) {
                Text("결제 상태")
                    .font(.montserrat(.semibold, size: 17))
                Spacer()
                Button {
                    
                } label: {
                    Text("저장")
                        .font(.system(size: 15))
                        .frame(width: 60, height: 33)
                        .background(Color("InfoBox"))
                        .cornerRadius(7)
                        .foregroundColor(Color(.label))
                }
            }
            .padding(.horizontal, 20)
            
            
            enrollmentRow()
            
        }
    }
    
    func enrollmentRow() -> some View {
        VStack(alignment:.leading, spacing: 15) {
            HStack(spacing: 25) {
                Text("클래스")
                    .frame(width: 82, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("InfoText"))
                Text("12.07 Narae 18:00")
                Spacer()
            }
            .padding(.horizontal, 20)
            
            HStack(spacing: 25) {
                Text("결제 형태")
                    .frame(width: 82, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("InfoText"))
                Text("쿠폰 사용")
                Spacer()
            }
            .padding(.horizontal, 20)
            
            HStack(spacing: 25) {
                Text("결제 여부")
                    .frame(width: 82, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color("InfoText"))
                
                Text("완료")
                
                Spacer()
                
                Button {
                    
                } label: {
                    boxChecked
                }
                
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(Color("InfoPayBox"))
            .font(.system(size: 15))
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
}

struct StudentInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StudentInfoView()
        }
    }
}
