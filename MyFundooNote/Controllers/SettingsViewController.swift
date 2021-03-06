//
//  SettingsViewController.swift
//  MyFundooNote
//
//  Created by admin on 01/05/22.
//

import UIKit

class SettingsViewController: UIViewController {
    let label       = TitleLabel(textAlignment: .left,
                                 fontSize: ConstantFontSize.descriptionFontsize)
    let body        = TitleLabel(textAlignment: .left,
                                 fontSize: ConstantFontSize.descriptionFontsize)
    let container   = CustomContainerView()
    let defaults    = UserDefaults.standard

    let switchMode: UISwitch = {
        let switchmode = UISwitch()
        return switchmode
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        switchMode.setOn(defaults.bool(forKey: "darkModeEnabled"),
                         animated: false)
        configureUI()
        view.backgroundColor                    = .secondarySystemBackground
        title                                   = ConstantTitles.setting
        navigationController?.isToolbarHidden   = true
        navigationController?.navigationBar.topItem?.searchController?.searchBar.isHidden = true
               
    }
    func configureUI() {
        configureAppearanceLabel()
        configureAppearaceContainerView()
        configureAppearance()
        configureAppearaneSwitch()
    }
    func configureAppearanceLabel() {
        view.addSubview(label)
        label.text       = "APPEARANCE"
        label.textColor  = .secondaryLabel
        label.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 20,
                     paddingLeft: 30,
                     paddingRight: 20)
    }
    func configureAppearaceContainerView() {
        view.addSubview(container)
        container.backgroundColor       = .systemBackground
        container.layer.cornerRadius    = 10
        container.layer.borderColor     = UIColor.secondarySystemFill.cgColor
        container.anchor(top: label.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 5,
                         paddingLeft: 20,
                         paddingRight: 20,
                         height: 50)
    }
    func configureAppearance() {
        container.addSubview(body)
        body.text       = "Dark Appearance"
        body.textColor  = .label
        body.centerY(inView: container)
        body.anchor(left: container.leftAnchor,
                    paddingLeft: 10)
    }
    
    func configureAppearaneSwitch() {
        container.addSubview(switchMode)
        switchMode.addTarget(self,
                             action: #selector(switchStateDidChange(_:)),
                             for: .valueChanged)
        switchMode.centerY(inView: container)
        switchMode.anchor( right: container.rightAnchor,
                           paddingRight: 20)
    }

    @objc func switchStateDidChange(_ sender:UISwitch){
        if (sender.isOn == true){
            defaults.set(true, forKey: "darkModeEnabled")
            let window = UIApplication.shared.keyWindow
                    window?.overrideUserInterfaceStyle = .dark
        }  else{
            defaults.set(false, forKey: "darkModeEnabled")
            let window = UIApplication.shared.keyWindow
                    window?.overrideUserInterfaceStyle = .light
        }
    }
}
