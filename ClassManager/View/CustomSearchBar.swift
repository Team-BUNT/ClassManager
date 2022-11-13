//
//  CustomSearchBar.swift
//  ClassManager
//
//  Created by 김남건 on 2022/11/05.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String
    private let placeholderText = "수강생의 이름을 검색하세요."
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
            ZStack {
                if searchText.isEmpty {
                    HStack {
                        Text(placeholderText)
                            .font(.system(size: 15))
                        Spacer()
                    }
                }
                TextField("", text: $searchText)
            }
            Spacer(minLength: 0)
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
                
            }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 8)
        .foregroundColor(Color("DarkGray"))
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("SearchBox")).opacity(0.24).frame(height: 48))
    }
}

struct CustomSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomSearchBar(searchText: .constant(""))
            .padding(.horizontal, 20)
    }
}
