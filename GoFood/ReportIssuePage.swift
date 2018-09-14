//
//  UserNamePage.swift
//  GoFood
//
//  Created by EO on 2018/4/13.
//  Copyright © 2018 EO. All rights reserved.
//

import UIKit
import Firebase

class ReportIssuePage: UIViewController {
    var problem = ""
    var useremail = ""
    var relateduseremail = ""
    var phonenumber = ""
    @IBOutlet weak var problemText: UITextField!
    @IBOutlet weak var userEmailText: UITextField!
    @IBOutlet weak var relatedUserText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    
    @IBOutlet weak var warningText: UILabel!
    @IBAction func cancelReport(_ sender: Any) {
        performSegue(withIdentifier: "backToMyOrder", sender: self)
    }
    @IBAction func sumbitReport(_ sender: Any) {
        problem = problemText.text!
        useremail = userEmailText.text!
        relateduseremail = relatedUserText.text!
        phonenumber = phoneText.text!
        
//        var orderId: String = ""
        if problem.count == 0 {
            warningText.text = "Please describe your problem."
            return
        } else if isValidEmail(testStr: useremail) == false
        {
            warningText.text = "Please input a valid GT email."
            return
        } else if phonenumber.count != 10 {
            warningText.text = "Please provide your valid phone number."
            return
        } else {
            //TO DO
            let reportsDB = Database.database().reference().child("Reports")
            let reportDictionary = ["reporter": (Auth.auth().currentUser?.uid)!,
                                    "problemDiscription": problem,
                                    "userEmail": useremail,
                                    "relatedUserEmail": relateduseremail,
                                    "phoneNumber": phonenumber]
            reportsDB.childByAutoId().setValue(reportDictionary) {
                (error, reference) in
                if error != nil {
                    print(error)
                } else {
                    let alert = UIAlertController(title: "Report Issue", message: "Your request has been submitted.", preferredStyle: UIAlertControllerStyle.alert)
                    let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                    {   UIAlertAction in
                        self.performSegue(withIdentifier: "backToMyOrder", sender: self)
                    }
                    alert.addAction(alertAction)
                    self.present(alert, animated: true,completion: nil)
                }
            }
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@gatech.edu"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
