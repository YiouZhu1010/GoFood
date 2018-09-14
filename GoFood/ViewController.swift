//
//  ViewController.swift
//  GoFood
//
//  Created by EO on 22/03/2018.
//  Copyright © 2018 EO. All rights reserved.
//

import UIKit
import FirebaseAuth

var userName = ""
var phoneNumber = ""
class ViewController: UIViewController {
 
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        signupButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        signupButton.layer.shadowOpacity = 0.25
        signupButton.layer.shadowRadius = 20.0
        signupButton.layer.cornerRadius = 4.0
        loginButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        loginButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        loginButton.layer.shadowOpacity = 0.25
        loginButton.layer.shadowRadius = 20.0
        loginButton.layer.cornerRadius = 4.0
    }


}

