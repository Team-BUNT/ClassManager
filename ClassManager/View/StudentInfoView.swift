//
//  StudentInfoView.swift
//  ClassManager
//
//  Created by 김남건 on 2022/11/08.
//

import SwiftUI

struct StudentInfoView: View {
    @State private var student: Student
    @State private var isChanged = false
    @State private var isShowingSaveToast = false
    @State private var reasons = [String]()
    
    @FocusState private var focusField: Int?
        
    init(student: Student) {
        self._student = State(wrappedValue: student)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 38) {
                personalInfoView
                    .padding(.top, 20)
                
                couponsView
                
                paymentView
                
                Spacer()
            }
        }
        .toast(message: "현재 결제 상태가 저장되었습니다.", isShowing: $isShowingSaveToast, duration: Toast.short)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("수강생 정보")
                    .font(.system(size: 16))
            }
        }
        .task {
            do {
                if student.enrollments.isEmpty {
                    return
                }
                
                let classIDs = try await DataService.shared.requestAllClassesBy(classIDs: student.enrollments.map { $0.classID ?? "" }) ?? []
                
                for i in 0..<student.enrollments.count {
                    student.enrollments[i].findClass(in: classIDs)
                    reasons.append(student.enrollments[i].refundReason ?? "")
                }
                
                student.enrollments.sort {
                    !($0.paid ?? false) && ($1.paid ?? false)
                }
            } catch {
                print(error)
            }
        }
    }
    
    var personalInfoView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("개인 정보")
                .font(.montserrat(.semibold, size: 17))
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(student.name ?? "익명")")
                        .font(.subheadline)
                    Text("\(student.phoneNumber?.toPhoneNumberFormat() ?? "xxx xxxx xxxx")")
                        .kerning(0.3)
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 20)
            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color("InfoBox")))
        }
        .padding(.horizontal, 20)
    }
    
    var couponsView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("잔여 쿠폰")
                .font(.montserrat(.semibold, size: 17))
                .padding(.horizontal, 20)
            ScrollView(.horizontal) {
                HStack(spacing: 14) {
                    Group {
                        if student.availableCoupons.isEmpty {
                            Text("구매한 쿠폰이 없습니다.")
                                .font(.system(size: 15))
                                .foregroundColor(Color("InfoText"))
                                .frame(height: 140, alignment: .top)
                        } else {
                            ForEach(student.groupedCoupons, id: \.[0].expiredDate) { group in
                                couponView(couponGroup: group)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    func couponView(couponGroup: [Coupon]) -> some View {
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
    
    var paymentView: some View {
        VStack(spacing: 21) {
            HStack(alignment: .top) {
                Text("결제 상태")
                    .font(.montserrat(.semibold, size: 17))
                Spacer()
                Text("저장")
                    .font(.system(size: 15))
                    .frame(width: 60, height: 33)
                    .background(isChanged ? Color("Accent") : Color("InfoBox"))
                    .cornerRadius(7)
                    .foregroundColor(isChanged ? .black : Color(.label))
                    .onTapGesture {
                        if isChanged {
                            updateRefundReason()
                            DataService.shared.updateEnrollments(enrollments: student.enrollments)
                            DataService.shared.updateStudentEnrollments(student: student)
                            isChanged = false
                            isShowingSaveToast.toggle()
                            
                            if student.enrollments.isEmpty {
                                return
                            }
                            
                            for i in 0..<student.enrollments.count {
                                // 환불 처리되는 enrollments에 대해서만 coupon 정보를 수정
                                if !(student.enrollments[i].isRefunded ?? false) {
                                    continue
                                }
                                                                
                                for j in 0..<student.coupons.count {
                                    // 저장 버튼을 누른 시점에서만 쿠폰의 classID를 nil로 만들어서 회복시킴
                                    // enrollment에서 사용한 쿠폰을 찾아서 classID 값을 nil로 바꿈
                                    if student.coupons[j].classID != student.enrollments[i].classID {
                                        continue
                                    }
                                    
                                    student.coupons[j].classID = nil
                                    break
                                }
                            }
                            
                            // 저장 버튼을 누를 때에만 쿠폰 정보를 업데이트함
                            DataService.shared.updateStudentCoupons(student: student, coupons: student.coupons)
                            student.coupons = student.coupons.map { $0 }
                        }
                    }
            }
            .padding(.horizontal, 20)
            
            enrollmentListView
        }
    }
    
    var enrollmentListView: some View {
        VStack(spacing: 52) {
            ForEach(Array(student.enrollments.enumerated()), id: \.offset) { idx, enrollment in
                VStack(alignment:.leading, spacing: 15) {
                    HStack(spacing: 25) {
                        Text("클래스")
                            .frame(width: 82, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color("InfoText"))
                        Text("\((enrollment.matchedClass?.date ?? Date()).formattedString(format: "MM.dd"))  \(enrollment.matchedClass?.instructorName ?? "")  \((enrollment.matchedClass?.date ?? Date()).formattedString(format: "HH:mm"))")
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    HStack(spacing: 25) {
                        Text("결제 형태")
                            .frame(width: 82, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color("InfoText"))
                        Text("\(enrollment.paymentType ?? "")")
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    HStack(spacing: 25) {
                        Text("결제 여부")
                            .frame(width: 82, alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color("InfoText"))
                        
                        Text("\((enrollment.paid ?? false) ? "완료" : "대기")")
                        
                        Spacer()
                        
                        if enrollment.paymentType == "쿠폰 사용" {
                            boxCheckedUnabled
                        } else {
                            ZStack {
                                if enrollment.paid ?? false {
                                    boxChecked
                                } else {
                                    boxUnchecked
                                }
                            }
                            .onTapGesture {
                                enrollment.paid?.toggle()
                                student.enrollments = student.enrollments.map { $0 }
                                isChanged = true
                                if enrollment.paid == false {
                                    enrollment.isRefunded = false
                                }
                            }
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color("InfoPayBox"))
                    
                    if enrollment.paid ?? false {
                        ZStack(alignment: .leading) {
                            HStack {
                                Text("환불")
                                    .foregroundColor(Color("InfoText"))
                                    .padding(.leading, 20)
                                Spacer()
                                ZStack {
                                    if enrollment.isRefunded ?? false {
                                        boxChecked
                                    } else {
                                        boxUnchecked
                                    }
                                }
                                .padding(.trailing, 20)
                                .onTapGesture {
                                    // firebase에서도 환불 상태인 경우 환불 취소를 못하게 함
                                    if enrollment.isRefundedInServer(coupons: student.coupons) {
                                        return
                                    }
                                    
                                    isChanged = true
                                    if enrollment.isRefunded == nil {
                                        enrollment.isRefunded = false
                                    }
                                    enrollment.isRefunded!.toggle()
                                    if enrollment.isRefunded == false {
                                        enrollment.refundReason = nil
                                    }
                                    student.enrollments = student.enrollments.map { $0 }
                                }
                            }
                            .frame(height: 44)
                            .background(Rectangle().foregroundColor(Color("InfoPayBox")))
                            
                            if enrollment.isRefunded ?? false {
                                Text("완료")
                                    .foregroundColor(.white)
                                    .padding(.leading, 127)
                            }
                        }
                        .padding(.top, -15)
                    }
                    
                    if enrollment.isRefunded ?? false {
                        HStack(spacing: 80) {
                            Text("사유")
                                .foregroundColor(Color("InfoText"))
                                .padding(.leading, 20)
                            ZStack(alignment: .bottom) {
                                if focusField == idx {
                                    Rectangle()
                                        .foregroundColor(Color("DarkGray"))
                                        .frame(height: 1)
                                        .padding(.trailing, 20)
                                }
                                if reasons.count == student.enrollments.count {
                                    TextField("공백 포함 18자 이내로 입력해 주세요.", text: $reasons[idx])
                                        .focused($focusField, equals: idx)
                                        .limitText($reasons[idx], to: 18)
                                        .onChange(of: reasons[idx]) { _ in
                                            isChanged = true
                                        }
                                }
                            }
                        }
                        .frame(height: 44)
                        .background(Rectangle().foregroundColor(Color("InfoPayBox")))
                        .padding(.top, -15)
                    }
                }
                .font(.system(size: 15))
            }
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
    
    var boxCheckedUnabled: some View {
        Image(systemName: "square.fill")
            .font(.system(size: 20))
            .foregroundColor(Color("Accent"))
    }
    
    func updateRefundReason() {
        if student.enrollments.count == reasons.count {
            for idx in 0..<reasons.count {
                student.enrollments[idx].refundReason = reasons[idx]
            }
        }
    }
}

struct StudentInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StudentInfoView(student: Student(ID: "BuntStudioSample 01012340101", studioID: "BuntStudioSample", phoneNumber: "01012340101", subPhoneNumber: nil, name: "김철수", enrollments: [], coupons: []))
        }
    }
}
