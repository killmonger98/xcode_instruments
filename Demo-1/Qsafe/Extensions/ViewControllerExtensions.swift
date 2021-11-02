//
//  KeyboardExtensions.swift
//  Qsafe
//
//  Created by Qburst on 11/02/21.
//

import Foundation
import UIKit

extension UIViewController {

    func btnStatus(_ sender: UIButton, _ status: Int) {

        if status == 0 {
            sender.isEnabled = false
            sender.backgroundColor = UIColor(red: 0.996, green: 0.792, blue: 0.501, alpha: 1.0)
        } else {
            sender.isEnabled = true
            sender.backgroundColor = UIColor(red: 0.960, green: 0.517, blue: 0.184, alpha: 1)

        }
    }

    enum ErrorMessages: String {

        case invalidName = "Please enter a valid name"
        case invalidEmail = "The entered email is invalid"
        case invalidLocation = "Please enter a valid location"

    }

    func setupHideKeyboardOnTap() {

            self.view.addGestureRecognizer(self.endEditingRecognizer())
            self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())

        }

        private func endEditingRecognizer() -> UIGestureRecognizer {

            let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
            tap.cancelsTouchesInView = false
            return tap

        }

    func getWindow() -> UIWindow? {

        if #available(iOS 13.0, *) {
            return SceneDelegate.shared.window
        }
//        return AppDelegate.shared.window
        return (UIApplication.shared.delegate?.window) as? UIWindow

    }

}
