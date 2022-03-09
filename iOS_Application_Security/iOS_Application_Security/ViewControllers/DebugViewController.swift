//
//  DebugViewController.swift
//  iOS_Application_Security
//
//  Created by YenTing on 2022/2/16.
//

import UIKit

@objc(OCDebugViewController)
class DebugViewController: UIViewController {
    @objc var checker: SecurityChecker?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test Debug"
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Jailbreak Check", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.sizeToFit()
        button.addTarget(self, action: #selector(debugButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        layoutView()
    }
    
    private func configView() {
        self.view.backgroundColor = .white
        self.view.addSubview(titleLabel)
        self.view.addSubview(checkButton)
    }
    
    private func layoutView() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 140),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            checkButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            checkButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ])
    }
}

//MARK: Button Action
extension DebugViewController {
    @objc private func debugButtonTapped(_ sender: UIButton) {
        jailbreakCheck()
    }
}

//MARK: Check Function
extension DebugViewController: AlertPresent {
    private func jailbreakCheck() {
        checker?.checkProcess(completion: { isJailbroken in
            self.showAlert(value: isJailbroken, title: "Warning", message: "Debug mode Detected!!!")
        })
    }
}
