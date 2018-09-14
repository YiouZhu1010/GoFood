//
//  AddOrderTable.swift
//  GoFood
//
//  Created by EO on 29/03/2018.
//  Copyright © 2018 EO. All rights reserved.
//

import UIKit
class AddOrderTable: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return locations.count
        } else {
            return myLocations.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return locations[row]
        } else {
            return myLocations[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            orderLocation.text = locations[row]
        } else {
            myLocation.text = myLocations[row]
        }
    }
    func createTimePicker() {
        //format the picker
        startTimePicker.datePickerMode = .time
        endTimePicker.datePickerMode = .time
        
        //toolbar
        let toolbar1 = UIToolbar()
        let toolbar2 = UIToolbar()
        toolbar1.sizeToFit()
        toolbar2.sizeToFit()
        //bar button item
        let startDoneButton = UIBarButtonItem(barButtonSystemItem:.done,target:nil,action:#selector(startTimeDone))
        let endDoneButton = UIBarButtonItem(barButtonSystemItem:.done,target:nil,action:#selector(endTimeDone))
        toolbar1.setItems([startDoneButton],animated:false)
        toolbar2.setItems([endDoneButton],animated:false)
        startTime.inputAccessoryView = toolbar1
        endTime.inputAccessoryView = toolbar2
        
        //assigning date picker to text field
        startTime.inputView = startTimePicker
        endTime.inputView = endTimePicker
    }
    func textFieldShouldReturn(_ textField:UITextField) ->Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func startTimeDone() {
        //format date
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .short
        dateFormatter1.timeStyle = .short
        
        startTime.text = dateFormatter1.string(from:startTimePicker.date)
        self.view.endEditing(true)
    }
    @objc func endTimeDone() {
        //format date
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateStyle = .short
        dateFormatter2.timeStyle = .short
        
        endTime.text = dateFormatter2.string(from:endTimePicker.date)
        self.view.endEditing(true)
    }
    @objc func locationDone() {
        if(orderLocation.text == "") {
            orderLocation.text = locations[0]
        }
        self.view.endEditing(true)
    }
    @objc func myLocationDone() {
        if(myLocation.text == "") {
            myLocation.text = myLocations[0]
        }
        self.view.endEditing(true)
    }
    
    @objc func phoneDone() {
        self.view.endEditing(true)
    }
    
    @IBAction func pointManager(_ sender: UIStepper) {
        points.text = String(Int(sender.value))
    }
    
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var orderLocation: UITextField!
    @IBOutlet weak var myLocation: UITextField!
    @IBOutlet weak var restaurant: UITextField!
    @IBOutlet weak var orders: UITextField!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var position: UITextField!
    
    @IBOutlet weak var phoneText: UITextField!
    
    @IBOutlet weak var warningText: UILabel!
    let locations = ["Student Center","Tech Square"]
    let myLocations = ["Clough","Klaus","ISyE Main Building","Howey Physics Building","Scheller College of Business"]
    
    
    let startTimePicker = UIDatePicker()
    let endTimePicker = UIDatePicker()
    var locationsPicker = UIPickerView()
    var myLocationPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pickers view tag for identification
        locationsPicker.tag = 0
        myLocationPicker.tag = 1
        //location picker
        locationsPicker.delegate = self
        locationsPicker.dataSource = self
        orderLocation.inputView = locationsPicker
        orderLocation.textAlignment = .left
        orderLocation.placeholder = "Select Location"
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let locationDoneButton = UIBarButtonItem(barButtonSystemItem:.done,target:nil,action:#selector(locationDone))
        toolbar.setItems([locationDoneButton],animated:false)
        orderLocation.inputAccessoryView = toolbar
        
        //my location picker
        myLocationPicker.delegate = self
        myLocationPicker.dataSource = self
        myLocation.inputView = myLocationPicker
        myLocation.textAlignment = .left
        myLocation.placeholder = "Select Location"
        let toolbar3 = UIToolbar()
        toolbar3.sizeToFit()
        let myLocationDoneButton = UIBarButtonItem(barButtonSystemItem:.done,target:nil,action:#selector(myLocationDone))
        toolbar3.setItems([myLocationDoneButton],animated:false)
        myLocation.inputAccessoryView = toolbar3
        
        // time picker
        createTimePicker()
        
        // phone number keyboard
        phoneText.keyboardType = UIKeyboardType.numberPad
        let phoneToolbar = UIToolbar()
        phoneToolbar.sizeToFit()
        let phoneDoneButton = UIBarButtonItem(barButtonSystemItem:.done,target:nil,action:#selector(phoneDone))
        phoneToolbar.setItems([phoneDoneButton],animated:false)
        phoneText.inputAccessoryView = phoneToolbar
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
