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
                            LazyVStack(spacing: 38) {
                                HStack(spacing: 0) {
                                    Text("정윤성")
                                        .frame(width: 44)
                                        .padding(.trailing, (geometry.size.width - 247) * paddingRatio[0])
                                    Text("010 2345 6789")
                                        .font(.montserrat(.regular, size: 15))
                                        .frame(width: 112)
                                        .padding(.trailing, (geometry.size.width - 247) * paddingRatio[1])
                                    Text("완료")
                                        .frame(width: 60)
                                        .padding(.trailing, (geometry.size.width - 247) * paddingRatio[2])
                                    Image(systemName: "chevron.forward")
                                        .font(.system(size: 12))
                                }
                                .padding(EdgeInsets(top: 19, leading: 10, bottom: 19, trailing: 10))
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
        }
    }
}

struct PaymentStatusView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentStatusView()
    }
}
