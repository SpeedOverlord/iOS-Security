//
//  JailbreakChecker.swift
//  iOS_Application_Security
//
//  Created by YenTing on 2022/2/16.
//

import UIKit
import MachO

@objc (OCJailbreakFileChecker)
class JailbreakFileChecker: NSObject {
    fileprivate var checkByFileFlag = false
    fileprivate var checkByDynamicLibraryFlag = false
    fileprivate var checkByFilePointer: UnsafeMutablePointer<Bool>?
    fileprivate var checkByDynamicLibraryPointer: UnsafeMutablePointer<Bool>?
    private var checkByFilePointerHashValue: Int?
    
    fileprivate func checkByFile() -> Bool {
        var isJailbroken:Bool = false
        #if !SIMULATOR
        if FileManager.default.fileExists(atPath: "/Applications/Cydia.app") {
            isJailbroken = true
        }
        else if FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") {
            isJailbroken = true
        }
        else if FileManager.default.fileExists(atPath: "/bin/bash") {
            isJailbroken = true
        }
        else if FileManager.default.fileExists(atPath: "/usr/sbin/sshd") {
            isJailbroken = true
        }
        else if FileManager.default.fileExists(atPath: "/etc/apt") {
            isJailbroken = true
        }

        var error: Error?
        let stringToBeWritten = "Testing jailbreak."
        do {
            try stringToBeWritten.write(toFile: "/private/jailbreak.txt", atomically: true, encoding: .utf8)
        } catch let err {
            error = err
        }

        if error == nil {
            //Device is jailbroken
            isJailbroken = true
        }
        else {
            try? FileManager.default.removeItem(atPath: "/private/jailbreak.txt")
        }
        if UIApplication.shared.canOpenURL((URL(string: "cydia://package/com.example.package"))!) {
            //Device is jailbroken
            isJailbroken = true
        }
        #endif

        if isJailbroken {
            checkByFileFlag = false
           return true
        }
        else {
            checkByFileFlag = true
            return false
        }
    }
    
    fileprivate func checkByDynamicLibrary() -> Bool {
        let dynamicLibraryCount: __uint32_t = _dyld_image_count()
        for i in 0 ..< dynamicLibraryCount {
            let libraryName = String(cString: _dyld_get_image_name(i))
            if (strstr(libraryName, "MobileSubstrate") != nil || strstr(libraryName, "cycript") != nil || strstr(libraryName, "SSLKillSwitch") != nil || strstr(libraryName, "SSLKillSwitch2") != nil ) {
                checkByDynamicLibraryFlag = false
                return true
            }
            checkByDynamicLibraryFlag = true
            return false
        }
        checkByDynamicLibraryFlag = true
        return false
    }
    
    private func createFile() {
        let diretory = NSTemporaryDirectory()
        //file document
        guard let fileDocumentName = checkByFilePointer?.hashValue.description else {
            return
        }
        
        let fileUrl = NSURL.fileURL(withPathComponents: [diretory, fileDocumentName])
        guard let fileHashValue = checkByFilePointer?.hashValue else {
            return
        }
        let fileData = Data(fileHashValue.description.utf8)
        
        guard let fileUrl = fileUrl else {
            return
        }
        
        try? fileData.write(to: fileUrl, options: .withoutOverwriting)
        
        //DL document
        guard let dynamicLibraryDocumentName = checkByDynamicLibraryPointer?.hashValue.description else {
            return
        }
        
        let dynamicLibraryUrl = NSURL.fileURL(withPathComponents: [diretory, dynamicLibraryDocumentName])
        guard let dynamicLibraryHashValue = checkByDynamicLibraryPointer?.hashValue else {
            return
        }
        let dynamicLibraryData = Data(dynamicLibraryHashValue.description.utf8)
        
        guard let dynamicLibraryUrl = dynamicLibraryUrl else {
            return
        }
        
        try? dynamicLibraryData.write(to: dynamicLibraryUrl, options: .withoutOverwriting)
    }
    
    private func fileChecker(_ hashValue: String) -> String {
        let diretory = NSTemporaryDirectory()
        //file document
        let fileDocumentName = hashValue
        
        let fileUrl = NSURL.fileURL(withPathComponents: [diretory, fileDocumentName])
        guard let fileUrl = fileUrl else {
            return ""
        }
        let fileData = try? Data(contentsOf: fileUrl)
        guard let fileData = fileData else {
            return ""
        }
        let fileDataString = String(decoding: fileData, as: UTF8.self)
        return fileDataString
    }
}

extension JailbreakFileChecker: SecurityChecker {
   
    func checkProcess(completion handler: @escaping (Bool) -> Void) {
        let checkByFile = checkByFile()
        let checkByDynamicLibrary = checkByDynamicLibrary()
        let _:() = withUnsafeMutablePointer(to: &checkByFileFlag) { pointer in
            checkByFilePointer = pointer
        }
        
        let _:() = withUnsafeMutablePointer(to: &checkByDynamicLibraryFlag) { pointer in
            checkByDynamicLibraryPointer = pointer
        }
        createFile()
        switch (checkByFile, checkByDynamicLibrary) {
        case (false, false):
            if self.checkByFileFlag, self.checkByDynamicLibraryFlag {
                handler(false)
            } else {
                handler(true)
            }
        default:
            handler(true)
        }
    }
    
    func doucleCheckProcess(completion handler: @escaping (Bool) -> Void) {
        doubleCheckByFile { isTempered in
            handler(isTempered)
        }
    }
    
    private func doubleCheckByFile(successHandler handler: (Bool) -> Void ) {
        guard let fileHashValue = checkByFilePointer?.hashValue.description else {
            handler(true)
            return
        }
        
        guard let dynamicLibraryHashValue = checkByDynamicLibraryPointer?.hashValue.description else {
            handler(true)
            return
        }
       
        if fileHashValue != fileChecker(fileHashValue) || dynamicLibraryHashValue != fileChecker(dynamicLibraryHashValue) {
            handler(true)
        } else {
            handler(false)
        }
    }
}
