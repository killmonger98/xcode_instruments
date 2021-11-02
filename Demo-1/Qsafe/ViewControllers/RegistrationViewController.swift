//
//  RegistrationViewController.swift
//  Qsafe
//
//  Created by Qburst on 10/02/21.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var phoneNumberLabel: UILabel!

    var activeTextField: UITextField?
    var userPhoneNumber: String?

    override func viewDidLoad() {

        super.viewDidLoad()
        setupHideKeyboardOnTap()
        phoneNumberLabel.text = userPhoneNumber
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        [fullNameTextField, locationTextField].forEach({$0.addTarget(self,
                                                                     action: #selector(editingChanged),
                                                                     for: .editingChanged) })

        fullNameTextField.delegate = self
        locationTextField.delegate = self
        emailTextField.delegate = self

        btnStatus(submitButton, 0)

    }

    @objc func editingChanged(_ textField: UITextField) {

        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let name = fullNameTextField.text, !name.isEmpty,
            let location = locationTextField.text, !location.isEmpty
        else {
            btnStatus(submitButton, 0)
            return
        }
        btnStatus(submitButton, 1)

    }

    @objc func keyboardWillShow(notification: NSNotification) {

        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                    as? NSValue)?.cgRectValue else {

            // if keyboard size is not available for some reason, dont do anything
            return
        }

        var shouldMoveViewUp = false

        // if active text field is not nil
        if let activeTextField = activeTextField {

            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keyboardSize.height

            // if the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }

        if shouldMoveViewUp {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0

    }

    @IBAction func submitBtnClick(_ sender: UIButton) {

        if let fullName = fullNameTextField.text, !(fullName.isValidName()) {
            alertMessage(ErrorMessages.invalidName.rawValue)
            return
        }
        if let location = locationTextField.text, !(location.isValidAddress()) {
            alertMessage(ErrorMessages.invalidLocation.rawValue)
            return
        }
        if let email = emailTextField.text, email.count != 0 && !email.isValidEmail() {
            alertMessage(ErrorMessages.invalidEmail.rawValue)
            return
        }

        // change root
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }

        let isLoggedIn = true
        UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")

        sceneDelegate.changeRootViewController(viewControllerIdentifier:
                                                ViewControllerIDs.qRCodeNavigationController.rawValue)

    }

    func alertMessage(_ message: String) {
        let dialogMessage = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okk = UIAlertAction(title: "OK", style: .default, handler: { (_) -> Void in})
        dialogMessage.addAction(okk)

        self.present(dialogMessage, animated: true, completion: nil)
    }

}

extension RegistrationViewController: UITextFieldDelegate {
    // when user select a textfield, this method will be called
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        self.activeTextField = textField
    }

    // when user click 'done' or dismiss the keyboard
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
}
