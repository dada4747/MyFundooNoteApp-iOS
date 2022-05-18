//
//  NoteModel.swift
//  MyFundooNote
//
//  Created by admin on 02/05/22.
//

import Foundation
import Firebase
struct NoteModel: Hashable {
    var id          : String
    var title       : String
    var discription : String
    var isArchive   : Bool   = false
    var isNote      : Bool   = true
    var isReminder  : Bool   = false
    var createdDate : Date?
    
    init(id: String){
        self.id          = id
        self.discription = ""
        self.title       = ""
    }
    
    init(dictionary : [String:Any])
    {
        self.title       = (dictionary["title"] as? String) ?? ""
        self.discription = (dictionary["desc"]  as? String) ?? ""
        self.id          = (dictionary["id"]    as? String) ?? ""
        self.isArchive   = (dictionary["isArchive"]  != nil)
        self.isReminder  = (dictionary["isReminder"] != nil)
        self.isNote      = (dictionary["isNote"]     != nil)
        self.createdDate = (dictionary["createdDate"] as? Date) ?? Date()
    }
    
    func toDictionary() -> [String: Any] {
        return ["title"         : self.title ,
                "Description"   : self.discription,
                "created"       : self.createdDate ?? Date() ,
                "isRemainder"   : self.isReminder,
                "isArchieved"   : self.isArchive,
                "isNote"        : self.isNote]
    }
}
