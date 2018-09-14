//
//  MyOrder.swift
//  GoFood
//
//  Created by EO on 29/03/2018.
//  Copyright © 2018 EO. All rights reserved.
//

import UIKit
import Firebase

class MyOrder: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myOrderUIView: UIView!
    @IBOutlet weak var myPoints: UILabel!
    @IBOutlet weak var orderTableView: UITableView!
    
    
    let foodLocations = ["Panda Express","Clough","Klaus","Howey Physics Building","Subway"]
    let usersDB = Database.database().reference().child("AppUsers")
    var orderArray : [Order] = [Order]()
    let currentUserId: String = (Auth.auth().currentUser?.uid)!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myOrderCell") as! MyOrderTableCell
        let receiver: String = orderArray[indexPath.row].receiver
        let sender: String = orderArray[indexPath.row].sender
        var userId: String = ""
        if receiver == (Auth.auth().currentUser?.uid)! {
            let color =  UIColor(red:0.52, green:0.69, blue:0.98, alpha:1.0)
            cell.confirm.backgroundColor = color
            cell.status.setTitleColor(color, for: .normal)
            userId = sender
            cell.phone.text = orderArray[indexPath.row].senderPhone
        } else {
            userId = receiver
            cell.phone.text = orderArray[indexPath.row].receiverPhone
        }
        if(orderArray[indexPath.row].status == "Pending" || orderArray[indexPath.row].status == "Canceled") {
            cell.username.text = ""
            cell.orderId = self.orderArray[indexPath.row].orderId
            cell.foodLocation.text = self.orderArray[indexPath.row].foodLocation
            cell.orderLocation.text = self.orderArray[indexPath.row].orderLocation
            cell.location.text = self.orderArray[indexPath.row].position
            cell.startTime.text = self.orderArray[indexPath.row].startTime
            cell.endTime.text = self.orderArray[indexPath.row].endTime
            cell.orders.text = self.orderArray[indexPath.row].order
            cell.status.setTitle(self.orderArray[indexPath.row].status, for: .normal)
            if(self.orderArray[indexPath.row].status == "Canceled") {
                cell.confirm.isEnabled = false
                cell.confirm.alpha = 0.5
            } else {
                cell.confirm.setTitle("Cancel", for: .normal)
            }
        } else {
            cell.orderSender = sender
            cell.orderReceiver = receiver
            cell.points = orderArray[indexPath.row].points
            usersDB.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let name = value?["userName"] as? String
                //            let phone = value?["userPhone"] as? String
                cell.username.text = name
                cell.orderId = self.orderArray[indexPath.row].orderId
                cell.foodLocation.text = self.orderArray[indexPath.row].foodLocation
                cell.orderLocation.text = self.orderArray[indexPath.row].orderLocation
                cell.location.text = self.orderArray[indexPath.row].position
                cell.startTime.text = self.orderArray[indexPath.row].startTime
                cell.endTime.text = self.orderArray[indexPath.row].endTime
                cell.orders.text = self.orderArray[indexPath.row].order
                cell.status.setTitle(self.orderArray[indexPath.row].status, for: .normal)
                
                if(self.orderArray[indexPath.row].status == "Completed")  {
                    cell.confirm.isEnabled = false
                    cell.confirm.alpha = 0.5
                } else if(self.orderArray[indexPath.row].status == "Arrived" && self.orderArray[indexPath.row].receiver == Auth.auth().currentUser?.uid) {
                    cell.confirm.isEnabled = false
                    cell.confirm.alpha = 0.5
                } else if(self.orderArray[indexPath.row].status == "Taken" && self.orderArray[indexPath.row].sender == Auth.auth().currentUser?.uid) {
                    cell.confirm.isEnabled = false
                    cell.confirm.alpha = 0.5
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
//        cell.points.text = orderArray[indexPath.row].points
        return (cell)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        retrieveUserData()
        retrieveOrders()
    }
    func retrieveUserData() {
        usersDB.child(self.currentUserId).observe(.childAdded) { (snapshot) in
            let snapshotKey = snapshot.key
            let snapshotValue = snapshot.value as! String
            if(snapshotKey == "userPoint") {
                self.myPoints.text = snapshotValue
                self.myOrderUIView.setNeedsDisplay()
            }
        }
        usersDB.child(self.currentUserId).observe(.childChanged) { (snapshot) in
            let snapshotKey = snapshot.key
            let snapshotValue = snapshot.value as! String
            if(snapshotKey == "userPoint") {
                self.myPoints.text = snapshotValue
                self.myOrderUIView.setNeedsDisplay()
            }
        }
    }
    func retrieveOrders() {
        let ordersDB = Database.database().reference().child("Orders")
        ordersDB.observe(.childAdded){ (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let orderId: String = snapshot.key
            let order: String = snapshotValue["order"]!
            let foodLocation: String = snapshotValue["foodLocation"]!
            let orderLocation: String = snapshotValue["orderLocation"]!
            let position: String = snapshotValue["position"]!
            let startTime: String = snapshotValue["startTime"]!
            let endTime: String = snapshotValue["endTime"]!
            let points: String = snapshotValue["points"]!
            let sender: String = snapshotValue["sender"]!
            let receiver: String = snapshotValue["receiver"]!
            let status: String = snapshotValue["status"]!
            let receiverPhone: String = snapshotValue["receiverPhone"]!
            let senderPhone: String = snapshotValue["senderPhone"]!
            if(sender == (Auth.auth().currentUser?.uid)! || receiver == (Auth.auth().currentUser?.uid)!) {
                let newOrder = Order()
                newOrder.orderId = orderId
                newOrder.order = order
                newOrder.foodLocation = foodLocation
                newOrder.orderLocation = orderLocation
                newOrder.position = position
                newOrder.startTime = startTime
                newOrder.endTime = endTime
                newOrder.points = points
                newOrder.sender = sender
                newOrder.receiver = receiver
                newOrder.status = status
                newOrder.receiverPhone = receiverPhone
                newOrder.senderPhone = senderPhone
                self.orderArray.append(newOrder)
            }
            self.orderTableView.reloadData()
        }
        ordersDB.observe(.childChanged) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let orderId: String = snapshot.key
            let order: String = snapshotValue["order"]!
            let foodLocation: String = snapshotValue["foodLocation"]!
            let orderLocation: String = snapshotValue["orderLocation"]!
            let position: String = snapshotValue["position"]!
            let startTime: String = snapshotValue["startTime"]!
            let endTime: String = snapshotValue["endTime"]!
            let points: String = snapshotValue["points"]!
            let sender: String = snapshotValue["sender"]!
            let receiver: String = snapshotValue["receiver"]!
            let status: String = snapshotValue["status"]!
            let receiverPhone: String = snapshotValue["receiverPhone"]!
            let senderPhone: String = snapshotValue["senderPhone"]!
            var isOrderExist: Bool = false
            self.orderArray.forEach({ (orderItem) in
                if(orderItem.orderId == orderId) {
                    isOrderExist = true
                    orderItem.order = order
                    orderItem.foodLocation = foodLocation
                    orderItem.orderLocation = orderLocation
                    orderItem.position = position
                    orderItem.startTime = startTime
                    orderItem.endTime = endTime
                    orderItem.sender = sender
                    orderItem.receiver = receiver
                    orderItem.status = status
                    orderItem.receiverPhone = receiverPhone
                    orderItem.senderPhone = senderPhone
                }
            })
            
            if(isOrderExist == false) {
                if(sender == (Auth.auth().currentUser?.uid)!) {
                    let newOrder = Order()
                    newOrder.orderId = orderId
                    newOrder.order = order
                    newOrder.foodLocation = foodLocation
                    newOrder.orderLocation = orderLocation
                    newOrder.position = position
                    newOrder.startTime = startTime
                    newOrder.endTime = endTime
                    newOrder.points = points
                    newOrder.sender = sender
                    newOrder.receiver = receiver
                    newOrder.status = status
                    newOrder.receiverPhone = receiverPhone
                    newOrder.senderPhone = senderPhone
                    self.orderArray.append(newOrder)
                }
            }
            
            self.orderTableView.reloadData()
//            self.orderArray.removeAll()
//            self.retrieveOrders()
        }
    }

}
