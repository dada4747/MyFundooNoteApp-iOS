//
//  DataPersistenceManager.swift
//  MyFundooNote
//
//  Created by admin on 16/05/22.
//

import Foundation
import UIKit
import CoreData

class DataPersistanceManager {
    enum DatabasError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistanceManager()
//    
//    func insertNote(note: NoteItem) {
//        
//        let email = UserDefaults.standard.string(forKey: "uid")
//        do{
//            let user = try getUser(email: email!)
//            user.addToNotes(note)
//            try context.save()
//        }
//        catch{
//            let nserror = error as NSError
//            fatalError(" \(nserror), \(nserror.description)")
//        }
//    }
    
    
    
//    func createNotes(with model: NoteModel, completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let context = appDelegate.persistentContainer.viewContext
//        let item = NoteItem(context: context)
//        item.id = model.id
//        item.title = model.title
//        item.desc = model.desc
//        item.isArchive = model.isArchive
//        item.isNote = model.isNote
//        item.isReminder = model.isReminder
//        item.date = model.date
//
//        do {
//            try context.save()
//            completion(.success(()))
//        }catch {
//            completion(.failure(error))
//        }
//    }
    
    
//    func fetchNotesFromCoreData(completion: @escaping (Result<[NoteItem], Error>) -> Void) {
//
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//
//        let context = appDelegate.persistentContainer.viewContext
//
//        let request: NSFetchRequest<NoteItem>
//
//        request = NoteItem.fetchRequest()
//
//        do {
//
//            let titles = try context.fetch(request)
//            completion(.success(titles))
//            print("____________________________________________________")
//            print(titles)
//            print("____________________________________________________")
//
//        } catch {
//            completion(.failure(DatabasError.failedToFetchData))
//        }
//    }
}
