//
//  AddOrderController.swift
//  GoFood
//
//  Created by EO on 29/03/2018.
//  Copyright © 2018 EO. All rights reserved.
//

import UIKit
import Firebase

class AddOrderController: UIViewController {

    // outlet variables
    var startTime: String = ""
    var endTime: String = ""
    var orderLocation: String = ""
    var myLocation: String = ""
    var restaurant: String = ""
    var orders: String = ""
    var points: String = ""
    var position: String = ""
    var phoneNumber: String = ""

    @IBAction func createOrder(_ sender: UIButton) {
        // TODO: sumbit the form
        
        // send the order information to the backend database
        let ordersDB = Database.database().reference().child("Orders")
        
        //    var orderId: String = ""
        // get the data
        let dest : AddOrderTable = (self.childViewControllers.last as! AddOrderTable?)!
        self.startTime = dest.startTime.text!
        self.endTime = dest.endTime.text!
        self.myLocation = dest.myLocation.text!
        self.orderLocation = dest.orderLocation.text!
        self.orders = dest.orders.text!
        self.points = dest.points.text!
        self.phoneNumber = dest.phoneText.text!
        self.position = dest.position.text!
        self.restaurant = dest.restaurant.text!
        if startTime == "" || endTime == "" {
            let alert = UIAlertController(title: "Add Order", message: "Please select a valid start/end time.", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            {   UIAlertAction in}
            alert.addAction(alertAction)
            self.present(alert, animated: true,completion: nil)
            return
        } else if myLocation == "" || orderLocation == "" {
            let alert = UIAlertController(title: "Add Order", message: "Please choose the location.", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            {   UIAlertAction in}
            alert.addAction(alertAction)
            self.present(alert, animated: true,completion: nil)
            return
        } else if position == "" || restaurant == "" {
            let alert = UIAlertController(title: "Add Order", message: "Please input the corresponding location.", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            {   UIAlertAction in}
            alert.addAction(alertAction)
            self.present(alert, animated: true,completion: nil)
            return
        } else if orders == "" {
            let alert = UIAlertController(title: "Add Order", message: "Order details are required.", preferredStyle: UIAlertControllerStyle.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            {   UIAlertAction in}
            alert.addAction(alertAction)
            self.present(alert, animated: true,completion: nil)
            return
        }
        let orderDictionary = ["receiver": (Auth.auth().currentUser?.uid)!,
                               "sender": "",
                               "order": self.orders,
                               "foodLocation": self.orderLocation,
                               "restaurant": self.restaurant,
                               "orderLocation": self.myLocation,
                               "position": self.position,
                               "startTime": self.startTime,
                               "endTime": self.endTime,
                               "points": self.points,
                               "senderPhone": "",
                               "receiverPhone": self.phoneNumber,
                               "status": "Pending"]
        ordersDB.childByAutoId().setValue(orderDictionary) {
            (error, reference) in
            
            if error != nil {
                print(error)
            } else {
                self.performSegue(withIdentifier: "confirmOrder", sender: self);
                print("success!")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
