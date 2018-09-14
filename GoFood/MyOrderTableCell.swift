//
//  MyOrderTableCell.swift
//  GoFood
//
//  Created by EO on 30/03/2018.
//  Copyright © 2018 EO. All rights reserved.
//

import UIKit
import Firebase

class MyOrderTableCell: UITableViewCell {

    @IBOutlet weak var foodLocation: UILabel!
    @IBOutlet weak var orderLocation: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var orders: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var status: UIButton!
    @IBOutlet weak var confirm: UIButton!
    var orderId: String = ""
    var orderSender: String = ""
    var orderReceiver: String = ""
    var points: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        confirm.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        confirm.layer.shadowOffset = CGSize(width: 2, height: 2)
        confirm.layer.shadowOpacity = 0.25
        confirm.layer.shadowRadius = 1.0
        confirm.layer.cornerRadius = 4.0
    }

    @IBAction func confirmPushed(_ sender: Any) {
        let key = self.orderId
        let ordersDB = Database.database().reference().child("Orders")
        if(self.status.currentTitle == "Taken") {
            let childUpdates = ["/\(key)/status": "Arrived"]
            ordersDB.updateChildValues(childUpdates)
        } else if(self.status.currentTitle == "Arrived") {
            let childUpdates = ["/\(key)/status": "Completed"]
            ordersDB.updateChildValues(childUpdates)
            
            // now taking the user points
            let usersDB = Database.database().reference().child("AppUsers")
            usersDB.child(orderSender).observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Get order information
                let userKey = snapshot.key
                let value = snapshot.value as? NSDictionary
                let senderPoint = value?["userPoint"] as? String
                
                // Calculate the updated points
                let oldPoint: Int? = Int(senderPoint!)
                let amount: Int? = Int(self.points)
                let newPoint: Int? = oldPoint! + amount!
                let newPointString: String = String(newPoint!)
                let userUpdates = ["/\(userKey)/userPoint": newPointString]
                usersDB.updateChildValues(userUpdates)
            }) { (error) in
                print(error.localizedDescription)
            }
            
            usersDB.child(orderReceiver).observeSingleEvent(of: .value, with: { (snapshot) in

                // Get order information
                let userKey = snapshot.key
                let value = snapshot.value as? NSDictionary
                let receiverPoint = value?["userPoint"] as? String

                // Calculate the updated points
                let oldPoint: Int? = Int(receiverPoint!)
                let amount: Int? = Int(self.points)
                let newPoint: Int? = oldPoint! - amount!
                let newPointString: String = String(newPoint!)
                let userUpdates = ["/\(userKey)/userPoint": newPointString]
                usersDB.updateChildValues(userUpdates)
            }) { (error) in
                print(error.localizedDescription)
            }
            
        } else if(self.status.currentTitle == "Pending") {
            let childUpdates = ["/\(key)/status": "Canceled"]
            ordersDB.updateChildValues(childUpdates)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
