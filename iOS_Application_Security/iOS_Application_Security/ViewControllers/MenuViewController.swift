//
//  MenuViewController.swift
//  iOS_Application_Security
//
//  Created by YenTing on 2022/2/16.
//

import UIKit

@objc enum MenuItem: Int {
    case home
    case jailbreak
    case hook
    case debugMode
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .jailbreak:
            return "Jailbreak"
        case .hook:
            return "Hook"
        case .debugMode:
            return "Debug Mode"
        }
    }
}

@objc protocol menuDelegate: AnyObject {
    @objc func optionTapped(_ menuItem: MenuItem)
}

@objc (OCMenuViewController)
class MenuViewController: UIViewController {
    var menuItems: [MenuItem] = []
    @objc weak var delegate: menuDelegate?
    private lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 50
        tableview.separatorStyle = .none
        return tableview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        layoutView()
        addBackButton()
        setTableview()
        regisCell()
    }
    
    private func configView() {
        self.view.backgroundColor = .white
        self.view.addSubview(tableview)
    }
    
    private func layoutView() {
        NSLayoutConstraint.addConstraints(tableview, toView: self.view, withConstants: nil)
    }
    
    private func setTableview() {
        let items: [MenuItem] = [
                               .jailbreak,
                               .hook,
                               .debugMode]
        menuItems = items
    }
    
    private func regisCell() {
        tableview.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuCell")
    }
    
    private func addBackButton() {
        let button = UIButton(type: .custom)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(customView: button)
    }
}

// MARK: Button Action
extension MenuViewController {
    @objc private func backButtonTapped(_ sender: UIButton) {
        popView()
    }
    
    private func popView() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Tableview delegate & cell action
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = menuItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        cell.configure(with: cellModel.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        popView()
        delegate?.optionTapped(menuItems[indexPath.row])
    }
}
