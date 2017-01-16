//
//  ViewController.swift
//  IntentionTracker
//
//  Created by Dan Wiegand on 1/5/17.
//  Copyright © 2017 Stop It. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects
import SimpleAlert
import TransitionTreasury
import TransitionAnimation
import BWWalkthrough



class LoginController: UIViewController, NavgationTransitionable, BWWalkthroughViewControllerDelegate, UITextFieldDelegate {
    
    var tr_presentTransition: TRViewControllerTransitionDelegate?
    var tr_pushTransition: TRNavgationTransitionDelegate?

    @IBOutlet weak var inputsView: UIView!
    
    @IBOutlet weak var emailTextField: KaedeTextField!
    @IBOutlet weak var passwordTextField: KaedeTextField!
    @IBOutlet weak var loginButtonView: UIView!
    @IBOutlet weak var loginButton: ZFRippleButton!
    
    static var count: Int = 1
    
    public let backgroundColor = UIColor(colorLiteralRed: 245, green: 189, blue: 195, alpha: 1)
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        if LoginController.count < 2 {
            showWalkthrough()
        }
        
        setFormAttributes()
        changePlaceholderColors()
        self.hideKeyboardWhenTappedAround()
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LoginController.count += 1
    }
    
    func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "Master") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewController(withIdentifier: "page1")
        let page_two = stb.instantiateViewController(withIdentifier: "page2")
        let page_three = stb.instantiateViewController(withIdentifier: "page3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(vc: page_one)
        walkthrough.addViewController(vc: page_two)
        walkthrough.addViewController(vc: page_three)
        
        self.present(walkthrough, animated: true, completion: nil)
    }
    
    func changePlaceholderColors() {
       
        emailTextField.placeholderColor = UIColor.white
        passwordTextField.placeholderColor = UIColor.white
        
    }
    
    
    func setFormAttributes() {
        
        inputsView.layer.cornerRadius = 6
        inputsView.layer.masksToBounds = true
        inputsView.layer.borderColor = UIColor.white.cgColor
        inputsView.layer.borderWidth = 1
        
        loginButtonView.layer.cornerRadius = 6
        loginButtonView.layer.borderColor = UIColor.white.cgColor
        loginButtonView.layer.borderWidth = 1
        
        loginButton.layer.cornerRadius = 6
        
        
    }
    

    @IBAction func registerToggleButtonPressed(_ sender: UIButton) {
        
        self.navigationController?.tr_pushViewController((UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Register") as! RegisterController), method: TRPushTransitionMethod.fade)


    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                print(error!)
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        self.alertMessage(alertAction: AlertAction(title: "Email Invalid", style: .cancel) { action in
                        })
                    case .errorCodeInternalError:
                        self.alertMessage(alertAction: AlertAction(title: "Password Blank", style: .cancel) { action in
                        })
                    case .errorCodeUserNotFound:
                        self.alertMessage(alertAction: AlertAction(title: "User Not Found", style: .cancel) { action in
                        })
                    case .errorCodeWrongPassword:
                        self.alertMessage(alertAction: AlertAction(title: "Wrong Password", style: .cancel) { action in
                        })
                    case .errorCodeAccountExistsWithDifferentCredential:
                        self.alertMessage(alertAction: AlertAction(title: "User Not Found", style: .cancel) { action in
                        })
                    default:
                        print("Create User Error: \(error!)")
                        self.alertMessage(alertAction: AlertAction(title: "Error Logging In", style: .cancel) { action in
                        })
                    }
                }

                return
            }
            
            self.performSegue(withIdentifier: "LoginCorrect", sender: self)
            print("*************************")
            
        })
        
        
    }
    func alertMessage(alertAction: AlertAction) {
        let alert = AlertController(view: UIView(), style: .alert)
        let action = alertAction
        alert.addAction(action)
        action.button.frame.size.height = 300
        action.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        action.button.setTitleColor(UIColor(netHex:0xF5BDC3), for: .normal)
        alert.configContainerWidth = {
            return 300
        }
        alert.configContainerCornerRadius = {
            return 150
        }
        alert.configContentView = { view in
            view?.backgroundColor = UIColor.white
            view?.alpha = 0.7
        }
        self.present(alert, animated: true, completion: nil)
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

