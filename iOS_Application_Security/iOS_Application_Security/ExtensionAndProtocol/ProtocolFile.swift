//
//  ProtocolFile.swift
//  iOS_Application_Security
//
//  Created by ESB21632 on 2022/2/16.
//

import Foundation
import UIKit

@objc protocol SecurityChecker: AnyObject {
    @objc func checkProcess(completion handler: @escaping (Bool) -> Void)
    @objc func doucleCheckProcess(completion handler: @escaping (Bool) -> Void)
}

protocol AlertPresent: UIViewController {
    
}


