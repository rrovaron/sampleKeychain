//
//  ViewController.swift
//  SimpleKeychain
//
//  Created by Rodrigo Rovaron on 06/04/21.
//

import UIKit
import Security

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        createKeychainItem()

//        retriveKeychainItem()

//        updateKeychainItem()

//        deleteKeychainItem()

//        retriveKeychainItem()
    }

    func createKeychainItem() {

        let keychainItem = [kSecValueData: "RovaronToken".data(using: .utf8)!,
                            kSecAttrAccount: "rrovaron",
                            kSecAttrServer: "rovaron.com",
                            kSecClass: kSecClassInternetPassword,
                            kSecReturnAttributes: true] as CFDictionary

        var ref: AnyObject?
        let status = SecItemAdd(keychainItem, &ref)
        guard
            let result = ref as? NSDictionary
        else {
            print("Failure")
            return
        }

        print("Operation finished with status: \(status)")
        print("Returned attributes:")

        result.forEach { key, value in
          print("\(key): \(value)")
        }

        if status == 0 {
            print("Success")
        } else {
            print("Failure")
        }
    }

    func retriveKeychainItem() {

        let query = [kSecClass: kSecClassInternetPassword,
                     kSecAttrServer: "rovaron.com",
                     kSecReturnAttributes: true,
                     kSecReturnData: true] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        print("Operation finished with status: \(status)")
        guard
            let dic = result as? NSDictionary
        else {
            print("Failure")
            return
        }

        let username = dic[kSecAttrAccount] ?? ""
        let passwordData = dic[kSecValueData] as! Data
        let password = String(data: passwordData, encoding: .utf8)!
        print("Username: \(username)")
        print("Password: \(password)")
    }

    func updateKeychainItem() {

        let query = [kSecClass: kSecClassInternetPassword,
                     kSecAttrServer: "rovaron.com"] as CFDictionary

        let updateFields = [kSecValueData: "newToken".data(using: .utf8)!] as CFDictionary

        let status = SecItemUpdate(query, updateFields)
        print("Operation finished with status: \(status)")
    }

    func deleteKeychainItem() {

        let query = [kSecClass: kSecClassInternetPassword,
                     kSecAttrServer: "rovaron.com"] as CFDictionary

        let status = SecItemDelete(query)
        print("Operation finished with status: \(status)")
    }

}

