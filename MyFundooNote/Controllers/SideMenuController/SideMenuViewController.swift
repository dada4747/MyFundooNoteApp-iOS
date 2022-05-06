//
//  SideMenuViewController.swift
//  MyFundooNote
//
//  Created by admin on 01/05/22.
//

import UIKit

class SideMenuViewController: UIViewController {
    private var headerView: UILabel = {
        let view = UILabel()
        view.text = "Google Keeps"
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        view.shadowColor = .white
//        view.backgroundColor = .systemBackground
//        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .white
        return view
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        return tableView
    }()

    private var sideMenuView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var screenWidth: CGFloat {
        view.frame.size.width
    }

    private var leadingConstraint: NSLayoutConstraint!
    private var shadowColor: UIColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.5)
    private var sideMenuItems: [SideMenuItem] = []
    weak var delegate: SideMenuDelegate?

    convenience init(sideMenuItems: [SideMenuItem]) {
        self.init()
        self.sideMenuItems = sideMenuItems
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        view.backgroundColor = .systemBackground
        view.frame.origin.x = -screenWidth

        addSubviews()
        configureTableView()
        configureTapGesture()
    }

    private func addSubviews() {
        view.addSubview(sideMenuView)
//        sideMenuView.layer.cornerRadius = 40
        sideMenuView.backgroundColor = .systemBackground
        sideMenuView.addSubview(headerView)
        sideMenuView.addSubview(tableView)
        configureConstraints()
    }

    private func configureConstraints() {
        sideMenuView.topAnchor.constraint(equalTo:  view.topAnchor).isActive = true
        leadingConstraint = sideMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -view.frame.size.width)
        leadingConstraint.isActive = true
        sideMenuView.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.7).isActive = true
        sideMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        headerView.topAnchor.constraint(equalTo: sideMenuView.topAnchor,constant: 40).isActive = true
        headerView.leadingAnchor.constraint(equalTo: sideMenuView.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: sideMenuView.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: sideMenuView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: sideMenuView.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: sideMenuView.bottomAnchor).isActive = true
    }

    private func configureTableView() {
        tableView.backgroundColor = .systemBackground
        tableView.register(SideMenuItemCell.self, forCellReuseIdentifier: SideMenuItemCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
    }

    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func tapped() {
        hide()
    }

    func show() {
        self.view.frame.origin.x = 0
        self.view.backgroundColor = self.shadowColor
        UIView.animate(withDuration: 0.5) {
            self.leadingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    func hide() {
        self.view.backgroundColor = .clear
        UIView.animate(withDuration: 0.5) {
            self.leadingConstraint.constant = -self.screenWidth
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.view.frame.origin.x = -self.screenWidth
        }
    }
}

extension SideMenuViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return false }
        if view === headerView || view.isDescendant(of: tableView) {
            return false
        }
        return true
    }
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sideMenuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuItemCell.identifier, for: indexPath) as? SideMenuItemCell else {
            fatalError("Could not dequeue cell")
        }
        let item = sideMenuItems[indexPath.row]
        cell.configureCell(icon: item.icon, text: item.name)
//        cell.layer.cornerRadius = 20
//        cell.backgroundColor = .systemGray
//        cell.colo
//        let backgroundColorView = UIView()
//        backgroundColorView.backgroundColor = UIColor.red
//        cell.selectionStyle = UITableViewCell.SelectionStyle.blue
//        cell.selectedBackgroundView = backgroundColorView
        cell.layer.masksToBounds = true

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = sideMenuItems[indexPath.row]

        delegate?.itemSelected(item: item.viewController)
    }

}
