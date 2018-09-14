//
//  LogInPage.swift
//  GoFood
//
//  Created by EO on 2018/4/15.
//  Copyright © 2018 EO. All rights reserved.
//

import UIKit
import Firebase

class LogInPage: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var warningText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func verifyEmail(user: User) {
        if(user.isEmailVerified) {
            performSegue(withIdentifier: "toMainPage", sender: self)
        } else {
            warningText.text = "Email Address is not verified.\nPlease check your email."
        }
    }
    @IBAction func confirmLogIn(_ sender: Any) {
        let email = emailText.text
        let password = passwordText.text
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            if error == nil && user != nil {
                self.verifyEmail(user: user!)
            } else {
                self.warningText.text = error!.localizedDescription
            }
        }
    }
}
