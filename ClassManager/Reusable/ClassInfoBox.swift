//
//  ClassInfoBox.swift
//  ClassManager
//
//  Created by SeongHoon Jang on 2022/10/12.
//

import SwiftUI

struct ClassInfoBox: View {
    @State var danceClass: Class
    
    @State var isSuspended = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Hall \(danceClass.hall?.name ?? "")")
                    .font(.subheadline)
                    .foregroundColor(isSuspended ? Color("DarkGray") : Color("Gray"))
                HStack(spacing: 3) {
                    Text(danceClass.instructorName ?? "")
                        .font(.montserrat(.semibold, size: 16))
                        .strikethrough(isSuspended)
                    Text("의 \(danceClass.title ?? "")")
                        .font(.callout)
                        .strikethrough(isSuspended)
                }
                .foregroundColor(isSuspended ? Color("DarkGray") : .white)
                Text(danceClass.date?.timeRangeString(interval: danceClass.durationMinute ?? 0) ?? "")
                    .font(.subheadline)
                Divider()
                    .padding(.top, 15)
            }
            
            Image(systemName: "chevron.right")
                .font(.callout)
        }
        .foregroundColor(Color("DarkGray"))
        .padding(.top, 15)
        .onAppear {
            isSuspended = Constant.shared.isSuspended(classID: danceClass.ID)
        }
    }
}

struct ClassInfoBox_Previews: PreviewProvider {
    static var previews: some View {
        ClassInfoBox(danceClass: Class(ID: "", studioID: nil, title: nil, instructorName: nil, date: Date(), durationMinute: nil, hall: nil, applicantsCount: nil, isPopUp: true))
    }
}
