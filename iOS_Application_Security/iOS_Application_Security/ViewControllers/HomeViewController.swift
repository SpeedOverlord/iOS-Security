//
//  HomeViewController.swift
//  iOS_Application_Security
//
//  Created by YenTing on 2022/2/16.
//

import UIKit

@objc (OCHomeViewController)
class HomeViewController: UIViewController {
    @objc static let shared = HomeViewController()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Use Menu to choose which function you want to use"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        layoutView()
    }
    
    private func configView() {
        self.view.addSubview(titleLabel)
       
    }
    
    private func layoutView() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 120),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
}
