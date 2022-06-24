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
    
    
    func updateWith(model: NoteModel, completion: @escaping (Result<Void, Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let noteItem = NoteItem(context: context)

        noteItem.title = model.title
        noteItem.discription = model.discription
        noteItem.id = model.id
        noteItem.isNote = model.isNote
        noteItem.isArchive = model.isArchive
        noteItem.isReminder = model.isReminder
        noteItem.createdDate = model.createdDate

        do {
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabasError.failedToSaveData))
        }
    }
    func fetchFromDB(completion: @escaping (Result<[NoteItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<NoteItem>
        request = NoteItem.fetchRequest()
        
        do
        {
            let notes = try context.fetch(request)

            completion(.success(notes))
        }catch {
            completion(.failure(DatabasError.failedToFetchData))
        }
    }
    func deleteNoteFromDB(id: String, completion: @escaping (Result<Void, Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<NoteItem>
        request = NoteItem.fetchRequest()
     
        request.predicate = NSPredicate.init(format: "id = %@", id)
    
        let objects = try! context.fetch(request)
        for object in objects {
            context.delete(object)
        
        }
        do {
            try context.save()
            completion(.success(())) // <- remember to put this :)
        } catch {
            completion(.failure(DatabasError.failedToDeleteData))
            // Do something... fatalerror
        }//        context.delete(<#T##object: NSManagedObject##NSManagedObject#>)
    }

}
