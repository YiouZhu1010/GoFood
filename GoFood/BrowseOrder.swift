//
//  BrowseOrder.swift
//  GoFood
//
//  Created by EO on 29/03/2018.
//  Copyright © 2018 EO. All rights reserved.
//

import UIKit
import Firebase

class BrowseOrder: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITableViewDelegate,UITableViewDataSource{
    let departLocation = ["All","Student Center", "Tech Square"]
    let number = 3
    
    // data source
    var orderArray : [Order] = [Order]()
    
    @IBAction func orderLocationEdited(_ sender: Any) {
        print("orderLocationEdited")
        print(orderLocation.text!)
//        self.orderTableView.reloadData()
        self.orderArray.removeAll()
        retrieveOrders()
//        self.orderTableView.reloadData()
//        if(newOrderLocation != "") {
//            print("orderLocationEdited_2")
//            self.orderArray = orderArray.filter({ (orderItem) -> Bool in
//                return orderItem.orderLocation == newOrderLocation
//            })
//            print(orderArray.count)
//            print("orderLocationEdited_3")
//            self.orderTableView.reloadData()
////            self.viewDidLoad()
//            print("orderLocationEdited_4")
//        }
    }
    @IBAction func foodLocationEdited(_ sender: Any) {
        print("foodLocationEdited")
        print(foodLocation.text!)
        self.orderArray.removeAll()
//        self.orderTableView.reloadData()
        retrieveOrders()
//        self.orderTableView.reloadData()
//        if(newFoodLocation != "") {
//            orderArray = orderArray.filter({ (orderItem) -> Bool in
//                return orderItem.foodLocation == newFoodLocation
//            })
//            self.orderTableView.reloadData()
//        }
    }

    // outlet variables
    @IBOutlet var orderTableView: UITableView!
    

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "browseOrderCell") as! BrowseOrderTableCell
        cell.orderId = orderArray[indexPath.row].orderId
        cell.foodLocation.text = orderArray[indexPath.row].foodLocation
        cell.orderLocation.text = orderArray[indexPath.row].orderLocation
        cell.startTime.text = orderArray[indexPath.row].startTime
        cell.endTime.text = orderArray[indexPath.row].endTime
        cell.order.text = orderArray[indexPath.row].order
        cell.points.text = orderArray[indexPath.row].points
        if orderArray[indexPath.row].receiver == Auth.auth().currentUser?.uid {
            cell.takeButton.isEnabled = false
        }
        return (cell)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return locations.count
        } else {
            return orderlocations.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return locations[row]
        } else {
            return orderlocations[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            foodLocation.text = locations[row]
        } else {
            orderLocation.text = orderlocations[row]
        }
    }
    @objc func locationDone() {
        if(foodLocation.text == "") {
            foodLocation.text = locations[0]
        }
        self.view.endEditing(true)
    }
    @objc func orderLocationDone() {
        if(orderLocation.text == "") {
            orderLocation.text = orderlocations[0]
        }
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var foodLocation: UITextField!
    @IBOutlet weak var orderLocation: UITextField!
    let locations = ["All","Student Center", "Tech Square"]
    let orderlocations = ["All","Clough","Klaus","ISyE Main Building","Howey Physics Building","Scheller College of Business"]
    var locationPicker = UIPickerView()
    var orderlocationPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationPicker.tag = 0
        orderlocationPicker.tag = 1
        // food location picker
        locationPicker.delegate = self
        locationPicker.dataSource = self
        foodLocation.inputView = locationPicker
        foodLocation.textAlignment = .left
        foodLocation.placeholder = "Food Location"
        let toolbar1 = UIToolbar()
        toolbar1.sizeToFit()
        let locationDoneButton = UIBarButtonItem(barButtonSystemItem:.done,target:nil,action:#selector(locationDone))
        toolbar1.setItems([locationDoneButton],animated:false)
        foodLocation.inputAccessoryView = toolbar1
        // order location picker
        orderlocationPicker.delegate = self
        orderlocationPicker.dataSource = self
        orderLocation.inputView = orderlocationPicker
        orderLocation.textAlignment = .left
        orderLocation.placeholder = "Order Location"
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        let orderlocationDoneButton = UIBarButtonItem(barButtonSystemItem:.done,target:nil,action:#selector(orderLocationDone))
        toolbar2.setItems([orderlocationDoneButton],animated:false)
        orderLocation.inputAccessoryView = toolbar2
        retrieveOrders()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc func loadList(){
        //load data here
        self.orderArray.removeAll()
        retrieveOrders()
    }

    func retrieveOrders() {
        let ordersDB = Database.database().reference().child("Orders")
        ordersDB.observe(.childAdded){ (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let orderId: String = snapshot.key
            let order: String = snapshotValue["order"]!
            let orderFoodLocation: String = snapshotValue["foodLocation"]!
            let orderOrderLocation: String = snapshotValue["orderLocation"]!
            let startTime: String = snapshotValue["startTime"]!
            let endTime: String = snapshotValue["endTime"]!
            let points: String = snapshotValue["points"]!
            let sender: String = snapshotValue["sender"]!
            let receiver: String = snapshotValue["receiver"]!
            let status: String = snapshotValue["status"]!
            if(status == "Pending" && (self.foodLocation.text == "" || self.foodLocation.text == "All" || self.foodLocation.text == orderFoodLocation) && (self.orderLocation.text == "" || self.orderLocation.text == "All" || self.orderLocation.text == orderOrderLocation)) {
                let newOrder = Order()
                newOrder.orderId = orderId
                newOrder.order = order
                newOrder.foodLocation = orderFoodLocation
                newOrder.orderLocation = orderOrderLocation
                newOrder.startTime = startTime
                newOrder.endTime = endTime
                newOrder.points = points
                newOrder.sender = sender
                newOrder.receiver = receiver
                newOrder.status = status
                self.orderArray.append(newOrder)
            }
            self.orderTableView.reloadData()
        }
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
