//
//  ContainerViewComposer.swift
//  MyFundooNote
//
//  Created by admin on 01/05/22.
//

import UIKit

final class ContainerViewComposer {
    static func makeContainer() -> ContainerViewController {
        let homeViewController = HomeViewController()
        let settingsViewController = SettingsViewController()
        let aboutViewController = AboutViewController()
        let remindersViewController = RemindersViewController()
        let archiveViewController = ArchiveViewController()
        let sideMenuItems = [
            SideMenuItem(icon: ConstantImages.house,
                         name: ConstantTitles.homepage,
                         viewController: .embed(homeViewController)),
            SideMenuItem(icon: ConstantImages.reminder,
                         name: ConstantTitles.reminder,
                         viewController: .embed(remindersViewController)),
            SideMenuItem(icon: ConstantImages.archive,
                         name: ConstantTitles.archive,
                         viewController: .embed(archiveViewController)),
            SideMenuItem(icon:ConstantImages.setting,
                         name: ConstantTitles.setting,
                         viewController: .push(settingsViewController)),
            SideMenuItem(icon: ConstantImages.about,
                         name: ConstantTitles.about,
                         viewController: .modal(aboutViewController)),
        ]
        let sideMenuViewController = SideMenuViewController(sideMenuItems: sideMenuItems)
        let container = ContainerViewController(sideMenuViewController: sideMenuViewController,
                                                rootViewController: homeViewController)

        return container
    }
}
