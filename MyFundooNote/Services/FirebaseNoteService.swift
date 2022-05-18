//
//  FirebaseNoteService.swift
//  MyFundooNote
//
//  Created by admin on 02/05/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseNotsService {
    var model           = [NoteModel]()
    let db              = Firestore.firestore()
    var documents       = [QueryDocumentSnapshot]()
    var lastSnapshot    : QueryDocumentSnapshot?
    static var shared   = FirebaseNotsService()
    private init(){}
    
//    func writeToFirebase(title: String,description: String,isRemainder: Bool,isArchieved:Bool, isNote:Bool) {
//        let data:[String: Any] = ["title": title , "Description": description,"created":Timestamp.init(date: Date()),"isRemainder":isRemainder,"isArchieved":isArchieved, "isNote": isNote]
//        guard let uid = Auth.auth().currentUser?.uid else { return print("Error in saving user id") }
//        Firestore.firestore().collection("Notes").document(uid).collection("note").addDocument(data: data)
//    }
    
    func fetchNotes(complition: @escaping([NoteModel])-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let query = db.collection("Notes").document(uid).collection("note").whereField("isArchieved", isEqualTo: false).order(by: "created", descending: true).limit(to: 10)
        fetchNotesService(withQuery: query, complition: complition)
    }
    
    // Fetch more notes from firebse
    func fetchMoreNotes(complition: @escaping([NoteModel])-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var query = db.collection("Notes").document(uid).collection("note").whereField("isArchieved", isEqualTo: false).order(by: "created", descending: true).limit(to: 10)
        query = query.start(afterDocument: documents.first!)
        fetchNotesService(withQuery: query, complition: complition)
        
    }
    
    func fetchArchive(complition: @escaping([NoteModel])-> Void) {
        print("this is archive fetch call ")
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let query = db.collection("Notes").document(uid).collection("note").whereField("isArchieved", isEqualTo: true).order(by: "created", descending: true).limit(to: 10)
        fetchNotesService(withQuery: query, complition: complition)
    }
    func fetchMoreArchive(complition: @escaping([NoteModel])-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var query = db.collection("Notes").document(uid).collection("note").whereField("isArchieved", isEqualTo: true).order(by: "created", descending: true).limit(to: 10)
        query = query.start(afterDocument: documents.first!)
        fetchNotesService(withQuery: query, complition: complition)
    }
    func fetchReminderNotes(complition: @escaping([NoteModel])-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let query = db.collection("Notes").document(uid).collection("note").whereField("isRemainder", isEqualTo: true).order(by: "created", descending: true).limit(to: 10)
        fetchNotesService(withQuery: query, complition: complition)
    }
    
    // Fetch more notes from firebse
    func fetchMoreReminderNotes(complition: @escaping([NoteModel])-> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var query = db.collection("Notes").document(uid).collection("note").whereField("isRemainder", isEqualTo: true).order(by: "created", descending: true).limit(to: 10)
        query = query.start(afterDocument: documents.first!)
        fetchNotesService(withQuery: query, complition: complition)
        
    }
    
    // service for fetching notes and more notes func
    func fetchNotesService(withQuery query : Query , complition: @escaping([NoteModel])-> Void) {
        var notes = [NoteModel]()
        query.getDocuments { QuerySnapshot,Error in
            if Error != nil{
                
                print("Error in fetching data")
            }
            else {
                QuerySnapshot!.documents.forEach({ (document) in
                    let data = document.data() as [String: AnyObject]
                    let id = document.documentID
                    let title = data["title"] as? String ?? ""
                    let desc = data["Description"] as? String ?? ""
                    let newNote =  NoteModel(dictionary: ["title": title ,"desc": desc,"id":id])
                    notes.append(newNote)
                    self.documents.insert(document, at: 0)
                })
                complition(notes)
            }
        }
    }
    
    //update notes to firebase database
//    public func updateDataToFirebase(note: String , title: String, desc: String, isArchive:Bool, isNote:Bool, isReminder:Bool, completed: @escaping (Error?) -> Void ) {
//        print("In update method ")
//        print(title)
//        print(note)
//        let data:[String: Any] = ["title": title , "Description": desc, "isArchieved": isArchive, "isNote":isNote, "isRemainder": isReminder]
//        guard let uid  = Auth.auth().currentUser?.uid else {
//            print("User is not vallid user")
//            return
//        }
//        Firestore.firestore().collection("Notes").document(uid).collection("note").document(note).updateData(data) { error in
//            //            if let error = error{
//            print("Update Failed.......")
//            completed(error)
//            //            }
//        }
//    }
    
    //deleting data from firebase
    func deleteDataToFirebase(noteId: String, completed: @escaping (Error?) -> Void){
        guard let uid =  Auth.auth().currentUser?.uid else{
            return
        }
        Firestore.firestore().collection("Notes").document(uid).collection("note").document(noteId).delete { error in
        completed(error)
        }
    }
    
    func fetchuser(withUid uid: String, compilation: @escaping(User) -> Void) {
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            compilation(user)
        }
    }
    func createEmptyNote(completion: (NoteModel) -> Void) {
//        var note = NoteModel()
        guard let uid = Auth.auth().currentUser?.uid else { return }
    let doc = Firestore.firestore().collection("Notes").document(uid).collection("note").document()
        
        completion(NoteModel(id: doc.documentID))
    }
    
    func updateNoteToFirebase(note: NoteModel, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let doc = Firestore.firestore().collection("Notes").document(uid).collection("note").document(note.id)
        doc.setData(note.toDictionary(), merge: true) { error in
            completion(error)
        }
    }
}
