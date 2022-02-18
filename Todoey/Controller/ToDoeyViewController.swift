//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoeyViewController: UITableViewController {
    var arr = [Item]()
//    var defaults = UserDefaults()
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//    print(filePath)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let filePath1 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        print(filePath!)
        loadData()
    }
    
    func loadData(){
        do{
            let data = try Data(contentsOf: filePath!)
            let decoder = PropertyListDecoder()
            arr = try decoder.decode([Item].self, from: data)
        }catch{
            print("Error loading data")
        }
    }
    
    func saveData(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.arr)
            try data.write(to: self.filePath!)
        }catch{
            print("Error saving data")
        }
       self.tableView.reloadData()
    }
    
    // MARK: - ADD ITEM BUTTON PRESSED
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add ToDoey Item", message: "", preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
//            print("Item added successfully")
            print(textField.text ?? "Error adding item!")
            if let text = textField.text{
                var item = Item()
                item.title = text
                self.arr.append(item)
                self.saveData()
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter New ToDoey Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
//     MARK: - TABLE VIEW DATASOURCE METHODS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoeyCell", for: indexPath)
        cell.textLabel?.text = arr[indexPath.row].title
        
        if(arr[indexPath.row].done == true){
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }

    // MARK: - TABLE VIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(arr[indexPath.row])
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        arr[indexPath.row].done = !arr[indexPath.row].done
//        print("Done-property 2: \(arr[indexPath.row].done)")
        if(arr[indexPath.row].done == false){
            arr[indexPath.row].done = true
        }
        else{
            arr[indexPath.row].done = false
        }
//        DispatchQueue.main.async {
//            tableView.reloadData()
//        }
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
}

