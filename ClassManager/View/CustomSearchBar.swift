//
//  CustomSearchBar.swift
//  ClassManager
//
//  Created by 김남건 on 2022/11/05.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String
    private let placeholderText = "수강생 이름을 검색하세요."
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(.systemBackground))
            ZStack {
                if searchText.isEmpty {
                    HStack {
                        Text(placeholderText)
                            .foregroundColor(Color("SearchText"))
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
                        .foregroundColor(Color.gray)
                }
                
            }
        }
        .padding(.vertical, 7)
        .padding(.horizontal, 8)
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color("SearchBox")).opacity(0.24))
    }
}

struct CustomSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomSearchBar(searchText: .constant(""))
            .padding(.horizontal, 20)
    }
}
