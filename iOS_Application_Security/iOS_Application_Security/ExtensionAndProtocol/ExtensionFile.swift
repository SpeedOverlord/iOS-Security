//
//  ExtensionFile.swift
//  iOS_Application_Security
//
//  Created by ESB21632 on 2022/2/14.
//

import Foundation
import UIKit
import MachO

@objc extension NSLayoutConstraint {
    /*
     optional withConstant: [top, bottom, leading, trailing]
     */
    @objc class func addConstraints(_ view: UIView, toView parentView : UIView, withConstants: [CGFloat]?) {
        guard let constantArray = withConstants, constantArray.count == 4 else {
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor),
                view.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor)
            ])
            return
        }
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: constantArray[0]),
            view.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: constantArray[1]),
            view.leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor, constant: constantArray[2]),
            view.trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor, constant: constantArray[3])
        ])
    }
}

extension AlertPresent {
    func showAlert(value status: Bool ,title: String?, message: String?) {
        if status {
            var customMessage = ""
            guard let message = message else {
                customMessage = "Something goes wrong."
                let alertController = UIAlertController.init(title: title ?? "Warning", message: customMessage, preferredStyle: .alert)
                let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                terminateApp()
                return
            }
            terminateApp()
            customMessage = message + " App will close in 5 seconds!!!"
            let alertController = UIAlertController.init(title: title ?? "Warning", message: customMessage, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        } else {
            var customMessage = ""
            guard let message = message else {
                customMessage = "Something goes wrong."
                let alertController = UIAlertController.init(title: title ?? "Warning", message: customMessage, preferredStyle: .alert)
                let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            customMessage = message
            let alertController = UIAlertController.init(title: title ?? "Warning", message: customMessage, preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func terminateApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
            exit(0)
        })
    }
}
