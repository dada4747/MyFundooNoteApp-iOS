//
//  NoteModel.swift
//  MyFundooNote
//
//  Created by admin on 02/05/22.
//

import Foundation
import Firebase
struct NoteModel: Hashable {
    let id          : String
    let title       : String
    let desc        : String
    var isArchive   : Bool = false
    var isNote      : Bool = true
    var isReminder  : Bool = false
    var date = Date()
    
    init(dictionary : [String:Any])
    {
        self.title      = (dictionary["title"] as? String) ?? ""
        self.desc       = (dictionary["desc"] as? String) ?? ""
        self.id         = (dictionary["id"] as? String) ?? ""
        self.isArchive  = (dictionary["isArchive"] != nil)
        self.isReminder = (dictionary["isReminder"] != nil)
        self.isNote     = (dictionary["isNote"] != nil)
    }
}
