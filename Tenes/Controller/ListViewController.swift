//
//  ListViewController.swift
//  Tenes
//
//  Created by Nico Cobelo on 13/01/2021.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {

    var people = [Person]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return people.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath)
        
        let person = people[indexPath.row]
        
        cell.textLabel?.text = person.name
        
        return cell
    }
    
    // MARK: - Data MAnipulation
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Person> = Person.fetchRequest()) {
        do {
            people = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Agregar Cliente", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Agregar", style: .default) { (action) in
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            
            self.people.append(newPerson)
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Agregar cliente"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToPerson", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PeopleViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPerson = people[indexPath.row]
        }
    }
}
