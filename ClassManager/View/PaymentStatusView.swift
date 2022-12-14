//
//  PaymentStatusView.swift
//  ClassManager
//
//  Created by 김남건 on 2022/11/05.
//

import SwiftUI

struct PaymentStatusView: View {
    @State private var searchText = ""
    @State private var students = [Student]()
    
    private let paddingRatio: [CGFloat] = [41/107, 33/107, 33/107]
    
    var filteredStudents: [Student] {
        if searchText.isEmpty {
            return students
        }
        
        return students.filter {
            ( $0.name ?? "" ).contains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CustomSearchBar(searchText: $searchText)
                    .padding(.top, 24)
                    .padding(.bottom, 28)
                
                Divider()
                    .padding(.bottom, 12)
                
                table
            }
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    GeometryReader { proxy in
                        Text("결제 현황")
                            .font(.system(size: 16, weight: .regular))
                            .frame(width: proxy.size.width)
                            .contentShape(Rectangle())
                            .offset(y: 12)
                            .onTapGesture {
                                hideKeyboard()
                            }
                    }
                }
            }
            .padding(.horizontal, 20)
            .font(.system(size: 15))
            .task {
                do {
                    students = try await DataService.shared.requestAllStudents(of: "BuntStudioSample") ?? []
                } catch {
                    print(error)
                }
            }
        }
        .accentColor(.white)
    }
    
    // MARK: - table view
    private var table: some View {
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
                
                if !searchText.isEmpty && filteredStudents.isEmpty {
                    VStack {
                        Spacer(minLength: geometry.size.height * (207/844))
                        HStack {
                            Spacer()
                            Text("해당 성명의 수강생이 없습니다.")
                                .font(.system(size: 17))
                                .foregroundColor(Color("DarkGray"))
                            Spacer()
                        }
                    }
                }
                tableRows(width: geometry.size.width)
            }
        }
    }
    
    private func tableRows(width: CGFloat) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(filteredStudents, id: \.ID) { student in
                    NavigationLink {
                        StudentInfoView(student: student)
                    } label: {
                        HStack(spacing: 0) {
                            Text(student.name ?? "이름")
                                .frame(width: 44)
                                .padding(.trailing, (width - 247) * paddingRatio[0])
                            Text(student.phoneNumber?.toPhoneNumberFormat() ?? "xxx xxxx xxxx")
                                .kerning(0.3)
                                .font(.montserrat(.regular, size: 15))
                                .frame(width: 112)
                                .padding(.trailing, (width - 247) * paddingRatio[1])
                                
                            Text(student.paid ? "완료" : "대기")
                                .frame(width: 60)
                                .padding(.trailing, (width - 247) * paddingRatio[2])
                                .foregroundColor(student.paid ? Color(.label) : Color("Accent"))
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 12))
                                .foregroundColor(Color("ChevronGray"))
                        }
                        .padding(EdgeInsets(top: 19, leading: 10, bottom: 19, trailing: 10))
                        .foregroundColor(Color(.label))
                    }

                }
            }
        }
    }
}

struct PaymentStatusView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentStatusView()
    }
}
