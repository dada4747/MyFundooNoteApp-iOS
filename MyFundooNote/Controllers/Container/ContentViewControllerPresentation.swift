//
//  ContentViewControllerPresentation.swift
//  MyFundooNote
//
//  Created by admin on 01/05/22.
//

import UIKit

enum ContentViewControllerPresentation {
    case embed(ContentViewController)
    case push(UIViewController)
    case modal(UIViewController)
}
