//
//  BrowseOrderTableCell.swift
//  GoFood
//
//  Created by EO on 30/03/2018.
//  Copyright © 2018 EO. All rights reserved.
//

import UIKit
import Firebase

class BrowseOrderTableCell: UITableViewCell {

    @IBOutlet weak var foodLocation: UILabel!
    @IBOutlet weak var orderLocation: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var order: UILabel!
    @IBOutlet weak var takeButton: UIButton!
    
    
    // order id number to be set from parent view
    var orderId: String = ""

    @IBAction func takeOrder(_: UIButton) {
        let key = self.orderId
        let userId: String = (Auth.auth().currentUser?.uid)!
        let ordersDB = Database.database().reference().child("Orders")
        let usersDB = Database.database().reference().child("AppUsers")
        let sender: String = (Auth.auth().currentUser?.uid)!
        usersDB.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let senderPhone: String = (value?["userPhone"] as? String)!
            let childUpdates = ["/\(key)/status": "Taken", "/\(key)/sender": sender, "/\(key)/senderPhone": senderPhone]
            ordersDB.updateChildValues(childUpdates)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        takeButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        takeButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        takeButton.layer.shadowOpacity = 0.25
        takeButton.layer.shadowRadius = 1.0
        takeButton.layer.cornerRadius = 4.0
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
