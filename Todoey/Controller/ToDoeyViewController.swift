//
//  ViewController.swift
//  Todoey/Users/rhythmsingla
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoeyViewController: UITableViewController {
    
    var arr = [Item]()
    @IBOutlet weak var navbar: UINavigationItem!
    
    var selectedCategoryy: Categoryy?{
        didSet{
//            print("Category set successfully!\(String(describing: selectedCategoryy?.name))")
            loadData()
            navbar.title = selectedCategoryy?.name
        }
    }
    
    let context1 = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//    print(filePath)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
//        let request: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
        let categoryPredicate = NSPredicate(format: "categoryyName.name MATCHES %@", selectedCategoryy!.name!)
        var compoundPredicate = categoryPredicate
        if (predicate != nil){
            compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
        }
    
        request.predicate = compoundPredicate
        
        do{
            arr = try context1.fetch(request)
        }catch{
            print("Error loading data: \(error)")
        }
        tableView.reloadData()
    }
    
    func saveData(){
        do{
            try context1.save()
        }catch{
            print("Error saving context: \(error)")
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
                let item = Item(context: self.context1)
                item.title = text
                item.categoryyName = self.selectedCategoryy
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
        arr[indexPath.row].done = !arr[indexPath.row].done
//        DELETING DATA
//        context1.delete(arr[indexPath.row])
//        arr.remove(at: indexPath.row)
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - SEARCH FIELD DELEGATE EXTENSION
extension ToDoeyViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
        let orderDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [orderDescriptor]
        
        loadData(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text == ""){
            loadData()
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        }
        else{
            searchBarSearchButtonClicked(searchBar)
        }
    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        loadData()
//    }
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        loadData()
//    }
}


