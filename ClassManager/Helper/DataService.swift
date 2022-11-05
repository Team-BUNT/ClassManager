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
    let enrollmentRef = Firestore.firestore().collection("enrollment")
    let suspendedRef = Firestore.firestore().collection("suspended")
    
    func createStudio(ID: String, name: String, location: String?, notice: Notice?, halls: [Hall]) {
        let studio = Studio(ID: ID, name: name, location: location, notice: notice, halls: halls)
        do {
            try studioRef.document("\(ID)").setData(from: studio)
        } catch let error {
            print("Error writing studio to Firestore: \(error)")
        }
    }
    
    func createClass(studioID: String, title: String, instructorName: String, date: Date, durationMinute: Int, repetition: Int, hall: Hall?, isPopUP: Bool) {
        do {
            for idx in 0..<repetition {
                let classDate = Calendar.current.date(byAdding: .day, value: idx * 7, to: date)
                let classID = instructorName + dateIdString(from: classDate) // UUID().uuidString
                let danceClass = Class(ID: classID, studioID: studioID, title: title, instructorName: instructorName, date: classDate, durationMinute: durationMinute, hall: hall, applicantsCount: 0, isPopUp: isPopUP)
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
    
    func requestEnrollmentsBy(classID: String) async throws -> [Enrollment]? {
        let snapshot = try await enrollmentRef.whereField("classID", isEqualTo: classID).getDocuments()
        
        return snapshot.documents.compactMap { document in
            try? document.data(as: Enrollment.self)
        }
    }
    
    func requestSuspendedClassesBy(studioID: String) async throws -> SuspendedClasses? {
        let document = try await suspendedRef.document(studioID).getDocument()
        
        return try? document.data(as: SuspendedClasses.self)
    }
    
    func updateAttendance(enrollments: [Enrollment]) {
        enrollments.forEach { enrollment in
            enrollmentRef.document("\(enrollment.ID)").updateData([
                "attendance": enrollment.attendance ?? false
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                }
            }
        }
    }
    
    func updateSuspendedClasses(classID: String, studioID: String) async {
        do {
            let suspendedClasses = try await requestSuspendedClassesBy(studioID: studioID)
            var ids = [String]()
            if suspendedClasses != nil {
                ids = suspendedClasses!.IDs ?? []
            }
            ids.append(classID)
            let newSuspendedClasses = SuspendedClasses(studioID: studioID, IDs: ids)
            try suspendedRef.document(studioID).setData(from: newSuspendedClasses)
            Constant.shared.suspendedClasses = newSuspendedClasses
        } catch {
            print(error)
        }
    }
    
    func deleteClass(classID: String) {
        classRef.document(classID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    private func dateIdString(from date: Date?) -> String {
        if let date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-HH:mm"
            
            return dateFormatter.string(from: date)
        } else {
            return "xx:xx"
        }
    }
}

extension DataService {
    struct DummyData {
        static let notice = Notice(imageURL: "dummyimageURL", description: "sampledescription", bankAccount: nil)
        static let halls = [Hall(name: "hall A", capacity: 20), Hall(name: "hall B", capacity: 40)]
        static let hall = Hall(name: "hall A", capacity: 20)
    }
}
