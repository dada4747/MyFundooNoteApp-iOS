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
            SideMenuItem(icon: UIImage(systemName: "house.fill"),
                         name: "Home",
                         viewController: .embed(homeViewController)),
            SideMenuItem(icon: UIImage(systemName: "person"),
                         name: "Reminders",
                         viewController: .embed(remindersViewController)),
            SideMenuItem(icon: UIImage(systemName: "trash.fill"),
                         name: "Archive",
                         viewController: .embed(archiveViewController)),
            SideMenuItem(icon: UIImage(systemName: "gear"),
                         name: "Settings",
                         viewController: .push(settingsViewController)),
            SideMenuItem(icon: UIImage(systemName: "info.circle"),
                         name: "About",
                         viewController: .modal(aboutViewController)),
        ]
        let sideMenuViewController = SideMenuViewController(sideMenuItems: sideMenuItems)
        let container = ContainerViewController(sideMenuViewController: sideMenuViewController,
                                                rootViewController: homeViewController)

        return container
    }
}
