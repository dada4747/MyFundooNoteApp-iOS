//
//  SettingsViewController.swift
//  MyFundooNote
//
//  Created by admin on 01/05/22.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
title = "Setting"
        navigationController?.isToolbarHidden = true
        navigationController?.navigationBar.topItem?.searchController?.searchBar.isHidden = true
        
    }
    


}
