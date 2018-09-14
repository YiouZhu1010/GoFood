//
//  SignUpPage.swift
//  GoFood
//
//  Created by EO on 2018/4/15.
//  Copyright © 2018 EO. All rights reserved.
//

import UIKit
import Firebase

class SignUpPage: UIViewController {
    var email = ""
    var password = ""
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var warningText: UILabel!
    @IBAction func confirmSignUp(_ sender: Any) {
        email = emailText.text!
        password = passwordText.text!
        userName = usernameText.text!
        phoneNumber = phoneText.text!
        if isValidEmail(testStr: email) || isValidName(testStr: userName) || phoneNumber.count != 10 {
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                if error == nil && user != nil {
                    let usersDB = Database.database().reference().child("AppUsers")

                    let key: String = (user?.uid)!
                    let info = ["email": self.email, "userName": userName, "userPoint": "50", "userPhone": phoneNumber]
//                    let userInfoDictionary = ["\(key)": info]
                    // append data to database
                    usersDB.child(key).setValue(info) {
                        (error, reference) in
                        if error != nil {
                            print(error)
                        } else {
                            print("User created!")
                            self.warningText.text = ""
                            self.signup()
                        }
                    }
//                    usersDB.setValue(userInfoDictionary) {
//                        (error, reference) in
//                        if error != nil {
//                            print(error)
//                        } else {
//                            print("User created!")
//                            self.warningText.text = ""
//                            self.signup()
//                        }
//                    }
                } else {
                    self.warningText.text = error!.localizedDescription
                }
            }
        } else if !isValidEmail(testStr: email) {
            warningText.text = "Please input valid GT email."
        } else if !isValidName(testStr: userName){
            warningText.text = "Please use 2-10 letters/digits."
        } else {
            warningText.text = "Please input valid phone number."
        }
    }
    func signup() {
       // send verfication email and notify user
        Auth.auth().currentUser?.sendEmailVerification{ (error) in
            let alert = UIAlertController(title: "Confirm Sign Up", message: "Please check your email for verification", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            {   UIAlertAction in
                self.performSegue(withIdentifier: "signup", sender: self)
            }
            alert.addAction(alertAction)
            self.present(alert, animated: true,completion: nil)
            
            }
        
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@gatech.edu"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidName(testStr:String) -> Bool {
        let userRegEx = "[A-Za-z0-9.-]{2,10}"
        let userTest = NSPredicate(format:"SELF MATCHES %@",userRegEx)
        return userTest.evaluate(with: testStr)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }



}
