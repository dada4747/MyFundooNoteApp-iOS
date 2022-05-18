//
//  Constants.swift
//  MyFundooNote
//
//  Created by admin on 16/05/22.
//

import Foundation
import UIKit
enum ConstantFontSize {
    static let titleFontSize        : CGFloat = 23
    static let descriptionFontsize  : CGFloat = 17
}
enum ConstantPlaceholders {
    static let searchNotes       = "Search for Notes"
    static let searchArchives    = "Search for Archives"
    static let searchReminders   = "Search for Reminders"
    static let password          = "Password"
    static let email             = "Email"
    static let fullname          = "Full Name"
    static let username          = "User Name"
    static let title             = "Title"
    static let disc              = "Description"
}
enum ConstantImages {
    static var barButtonImage      : UIImage?  = UIImage(systemName: "line.horizontal.3")
    static var profileButtonImage  : UIImage?  = UIImage(systemName: "person.circle")
    static var gridViewButtonImage : UIImage?  = UIImage(systemName: "square.grid.2x2")
    static var listViewButtonImage : UIImage?  = UIImage(systemName: "rectangle.grid.1x2")
    static let noteImage           : UIImage?  = UIImage(named: "note.text.png")
    static let addImage            : UIImage?  = UIImage(systemName: "plus.app.fill")
    
    static let pine                : UIImage?  = UIImage(systemName: "pin.circle")
    static let reminder            : UIImage?  = UIImage(systemName: "bell.circle")
    static let archive             : UIImage?  = UIImage(systemName: "archivebox.circle")
    static let delete              : UIImage?  = UIImage(systemName: "trash.circle")
    static let backImage           : UIImage?  = UIImage(systemName: "arrow.backward.circle")
    static let unarchiveImage      : UIImage?  = UIImage(systemName: "archivebox.circle.fill")
    static let multiplyCircle      : UIImage?  = UIImage(systemName: "multiply.circle")
    
    static let placeholderImage    : UIImage?  = UIImage(systemName: "person.crop.circle")
    static let house               : UIImage?  = UIImage(systemName: "house.circle")
    static let person              : UIImage?  = UIImage(systemName: "person")
    static let setting             : UIImage?  = UIImage(systemName: "gear")
    static let about               : UIImage?  = UIImage(systemName: "info.circle")
}
enum ConstantTitles {
    static let homepage = "Home"
    static let archive  = "Archives"
    static let reminder = "Reminders"
    static let setting  = "Settings"
    static let about    = "About"
    static let addNote  = "Add Note"
    static let login    = "Log In"
    static let signup   = "Sign UP"
    static let logout   = "Logout"
    static let cancle   = "Cancel"
    static let save     = "Save"
    static let version  = "Version.1.0.1"
}
enum ConstatResourceName {
    static let mail       : String = "ic_mail_outline_white_2x"
    static let lock       : String = "ic_lock_outline_white_2x"
    static let profile    : String = "pro"
    static let person     : String = "ic_person_outline_white_2x"
    
}
enum ConstantHeader {
    static let mainheader : String = "Firebase Keep"
    static let addreminder: String = "Add Reminder"

}
//    static let
//    static let
//    static let
//    static let
//    static let
//    static let
//    static let
//    static let
//    static let
//    static let
//    static let
//    static let
//    static let

import SystemConfiguration

public class Reachability {
    static let shared = Reachability()
    init() {}
    public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }

        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }

        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)

        return (isReachable && !needsConnection)
    }
}
