//
//  HookChecker.swift
//  iOS_Application_Security
//
//  Created by YenTing on 2022/2/16.
//

import Foundation
import MachO

@objc (OCHookChecker)
class HookChecker: NSObject {
    fileprivate func checkMethodSwizzling(className: String, selectorName: String) -> Bool{
        var info = dl_info()
        let selector: Selector = sel_registerName(selectorName)
        let cls: NSObject.Type = objc_getClass(className) as! NSObject.Type
        var method = class_getInstanceMethod(cls, selector)
        if (method == nil) {
            method = class_getClassMethod(cls, selector)
        }
        let imp = method_getImplementation(method!)
        let impUnsafePointer = UnsafeRawPointer.init(imp)
        if (dladdr(impUnsafePointer, &info) != 0) {
            print("lib is %s", info.dli_fname as Any)
            return false
        }
        
        if (strncmp(info.dli_fname, "System/Library/Frameworks", 26) != 0) {
            return false
        }
        
        if ((strcmp(info.dli_fname, _dyld_get_image_name(0)) == 0)) {
            return false
        }
        
        return true
    }
}

extension HookChecker: SecurityChecker {
    func checkProcess(completion handler: @escaping (Bool) -> Void) {
        handler(checkMethodSwizzling(className: "OCJailbreakViewController", selectorName: "OCjailbreakCheck"))
    }
    
    func doucleCheckProcess(completion handler: @escaping (Bool) -> Void) {
        return
    }
}
