//
//  LoginViewController.swift
//  Passport
//
//  Created by jackrex on 2018/10/18.
//  Copyright © 2018 Passport. All rights reserved.
//

import UIKit

public protocol LoginViewDelegate {
    func loginFinish()
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    public var delegate: LoginViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginBtn.layer.cornerRadius = 25
        loginBtn.clipsToBounds = true
        
        phoneTextField.tintColor = .white
        passwordField.tintColor = .white
        
        phoneTextField.delegate = self
        passwordField.delegate = self
        
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "输入 Keep 手机号",
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordField.attributedPlaceholder = NSAttributedString(string: "密码",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        self.hideKeyboardWhenTappedAround()
        
    }
    
    @IBAction func loginClick(_ sender: Any) {
        
        let phone = phoneTextField.text
        let pwd = passwordField.text
        if (phone?.characters.count == 0) {
            SVProgressHUD.showInfo(withStatus: "请输入账号和密码")
            return
        }
        if (pwd?.characters.count == 0) {
            SVProgressHUD.showInfo(withStatus: "请输入密码")
            return
        }
        HttpApi.login(phone!, pwd!) { (data) in
            do {
                let dataDict = try JSONDecoder().decode(Login.self, from: data)
                print(dataDict)
                if let userId = POSTSecuritySign.generateUID(dataDict.data.token) {
                    AccountManager.saveUserId(userId)
                }
                self.delegate.loginFinish()
            }catch {
                let nsError = error as NSError
                print(nsError.debugDescription)
                SVProgressHUD.showInfo(withStatus: "数据解析错误")
            }

        }
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.phoneTextField {
            self.passwordField.becomeFirstResponder()
        }else if textField == self.passwordField {
            self.view.endEditing(true)
            self.loginClick(UIButton.init())
        }
        return true
    }
}
