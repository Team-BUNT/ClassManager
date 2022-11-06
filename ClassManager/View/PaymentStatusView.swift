//
//  PaymentStatusView.swift
//  ClassManager
//
//  Created by 김남건 on 2022/11/05.
//

import SwiftUI

struct PaymentStatusView: View {
    @State private var searchText = ""
    private let paddingRatio: [CGFloat] = [41/107, 33/107, 33/107]
    @State private var groupedEnrollments = [[Enrollment]]()
    var filteredEnrollments: [[Enrollment]] {
        if searchText.isEmpty {
            return groupedEnrollments
        }
        
        return groupedEnrollments.filter {
            ( $0[0].userName ?? "" ).contains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CustomSearchBar(searchText: $searchText)
                    .padding(.vertical, 24)
                Divider()
                    .padding(.bottom, 12)
                GeometryReader { geometry in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 0) {
                            Text("성명")
                                .frame(width: 44)
                                .padding(.trailing, (geometry.size.width - 247) * paddingRatio[0])
                            Text("연락처")
                                .frame(width: 112)
                                .padding(.trailing, (geometry.size.width - 247) * paddingRatio[1])
                            Text("결제상태")
                                .frame(width: 60)
                                .padding(.trailing, (geometry.size.width - 247) * paddingRatio[2])
                        }
                        .foregroundColor(Color("DarkGray"))
                        .padding(.horizontal, 10)
                        
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(filteredEnrollments, id: \.[0].ID) { enrollment in
                                    HStack(spacing: 0) {
                                        Text(enrollment[0].userName ?? "이름")
                                            .frame(width: 44)
                                            .padding(.trailing, (geometry.size.width - 247) * paddingRatio[0])
                                        Text(enrollment[0].phoneNumber ?? "xxx xxxx xxxx")
                                            .font(.montserrat(.regular, size: 15))
                                            .frame(width: 112)
                                            .padding(.trailing, (geometry.size.width - 247) * paddingRatio[1])
                                        Text((enrollment[0].paid ?? false) ? "완료" : "대기")
                                            .frame(width: 60)
                                            .padding(.trailing, (geometry.size.width - 247) * paddingRatio[2])
                                        Image(systemName: "chevron.forward")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color("DarkGray"))
                                    }
                                    .padding(EdgeInsets(top: 19, leading: 10, bottom: 19, trailing: 10))
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("결제 현황")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 20)
            .font(.system(size: 15))
            .task {
                /*do {
                    enrollments = try await DataService.shared.requestAllEnrollments(of: "BuntStudioSample") ?? []
                } catch {
                    print(error)
                }*/
                
                groupedEnrollments = createGroupedEnrollments(from: dummyEnrollments)
            }
        }
    }
    
    private func createGroupedEnrollments(from enrollments: [Enrollment]) -> [[Enrollment]] {
        let sortedEnrollments = enrollments.sorted(by: {
            if $0.paid != $1.paid {
                let paidToInt0 = ($0.paid ?? false) ? 1 : 0
                let paidToInt1 = ($1.paid ?? false) ? 1 : 0
                
                return paidToInt0 < paidToInt1
            }
            
            if $0.userName != $1.userName {
                return $0.userName ?? "" < $1.userName ?? ""
            }
            
            if $0.phoneNumber != $1.phoneNumber {
                return $0.phoneNumber ?? "" < $1.phoneNumber ?? ""
            }
            
            if $0.enrolledDate != $1.enrolledDate {
                return $0.enrolledDate ?? Date() < $1.enrolledDate ?? Date()
            }
            
            return $0.classID ?? "" < $1.classID ?? ""
        })
        
        var groupedResult = [[Enrollment]]()
        var temp = [Enrollment]()
        for enrollment in sortedEnrollments {
            if temp.isEmpty ||
                (temp[0].phoneNumber == enrollment.phoneNumber
                    && temp[0].paid == enrollment.paid) {
                temp.append(enrollment)
            } else {
                groupedResult.append(temp)
                temp = [enrollment]
            }
        }
        
        if !temp.isEmpty {
            groupedResult.append(temp)
        }
        
        return groupedResult
    }
}

extension PaymentStatusView {
    var dummyEnrollments: [Enrollment] {
        [
            Enrollment(ID: "Bunt-Class1-Enroll1", classID: "Bunt-Class1", userName: "김철수", phoneNumber: "01012340101", enrolledDate: Date(), paid: false, paymentType: "무통장"),
            Enrollment(ID: "Bunt-Class1-Enroll2", classID: "Bunt-Class1", userName: "김영희", phoneNumber: "01012340102", enrolledDate: Date(), paid: true, paymentType: "무통장"),
            Enrollment(ID: "Bunt-Class1-Enroll3", classID: "Bunt-Class1", userName: "김지수", phoneNumber: "01012340101", enrolledDate: Date(), paid: true, paymentType: "무통장"),
            Enrollment(ID: "Bunt-Class2-Enroll1", classID: "Bunt-Class2", userName: "손흥민", phoneNumber: "01012340201", enrolledDate: Date(), paid: true, paymentType: "현장 카드"),
            Enrollment(ID: "Bunt-Class3-Enroll1", classID: "Bunt-Class3", userName: "레이븐", phoneNumber: "01012340301", enrolledDate: Date(), paid: true, paymentType: "현장 카드"),
            Enrollment(ID: "Bunt-Class4-Enroll1", classID: "Bunt-Class4", userName: "김철수", phoneNumber: "01012340101", enrolledDate: Date(), paid: false, paymentType: "현장 카드"),
            Enrollment(ID: "Bunt-Class5-Enroll1", classID: "Bunt-Class5", userName: "김철수", phoneNumber: "01012340101", enrolledDate: Date(), paid: false, paymentType: "현장 카드"),
        ]
    }
}

struct PaymentStatusView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentStatusView()
    }
}
