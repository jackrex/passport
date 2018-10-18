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

class LoginViewController: UIViewController {

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
        
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "输入 Keep 手机号",
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordField.attributedPlaceholder = NSAttributedString(string: "密码",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])

        self.hideKeyboardWhenTappedAround()
        
    }
    
    @IBAction func loginClick(_ sender: Any) {
        
        let phone = phoneTextField.text
        let pwd = passwordField.text
        HttpApi.login(phone!, pwd!) { (data) in
            do {
                let dataDict = try JSONDecoder().decode(Login.self, from: data)
                print(dataDict)
                self.delegate.loginFinish()
            }catch {
                let nsError = error as NSError
                print(nsError.debugDescription)
            }

        }
    }


}
