//
//  DataService.swift
//  ClassManager
//
//  Created by Jiyoung Park on 2022/10/12.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DataService {
    static let shared = DataService()
    
    let studioRef = Firestore.firestore().collection("studios")
    let classRef = Firestore.firestore().collection("classes")
    let linkRef = Firestore.firestore().collection("link")
    
    func createStudio(ID: String, name: String, location: String?, notice: Notice?, halls: [Hall]) {
        let studio = Studio(ID: ID, name: name, location: location, notice: notice, halls: halls)
        do {
            try studioRef.document("\(ID)").setData(from: studio)
        } catch let error {
            print("Error writing studio to Firestore: \(error)")
        }
    }
    
    func createClass(studioID: String, title: String, instructorName: String, date: Date, durationMinute: Int, repetition: Int, hall: Hall?) {
        do {
            for idx in 0..<repetition {
                let classDate = Calendar.current.date(byAdding: .day, value: idx * 7, to: date)
                let classID = UUID().uuidString
                let danceClass = Class(ID: classID, studioID: studioID, title: title, instructorName: instructorName, date: classDate, durationMinute: durationMinute, hall: hall, applicantsCount: 0)
                if Constant.shared.classes == nil {
                    Constant.shared.classes = [Class]()
                    
                }
                Constant.shared.classes!.append(danceClass)
                try classRef.document("\(classID)").setData(from: danceClass)
            }
        } catch let error {
            print("Error writing class to Firestore: \(error)")
        }
    }
    
    func requestStudioBy(studioID: String) async throws -> Studio? {
        let document = try await studioRef.document(studioID).getDocument()
        
        return try? document.data(as: Studio.self)
    }
    
    func requestAllClasses() async throws -> [Class]? {
        let snapshot = try await classRef.getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: Class.self)
        }
    }
    
    func requestAllClassesBy(studioID: String) async throws -> [Class]? {
        let snapshot = try await classRef.whereField("studioID", isEqualTo: studioID).getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: Class.self)
        }
    }
    
    func requestLink() async throws -> Link? {
        let document = try await linkRef.document("sampleLink").getDocument()
        
        return try? document.data(as: Link.self)
    }
}

extension DataService {
    struct DummyData {
        static let notice = Notice(imageURL: "dummyimageURL", description: "sampledescription")
        static let halls = [Hall(name: "hall A", capacity: 20), Hall(name: "hall B", capacity: 40)]
        static let hall = Hall(name: "hall A", capacity: 20)
    }
}
