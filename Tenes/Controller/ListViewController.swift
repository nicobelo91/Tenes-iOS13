//
//  ListViewController.swift
//  Tenes
//
//  Created by Nico Cobelo on 13/01/2021.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    var clients = [Client]()
    let tenesBrain = TenesBrain()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        loadClients()
        //tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.register(UINib(nibName: "ClientCell", bundle: nil), forCellReuseIdentifier: "ClientCell")
        loadClients()
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as! ClientCell
        
        let client = clients[indexPath.row]
        cell.clientName.text = client.name
        cell.boxesOwed.text = client.boxes
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.context.delete(self.clients[indexPath.row])
            clients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveClients()
        }
        
    }
    // MARK: - Data MAnipulation
    
    func saveClients() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadClients(with request: NSFetchRequest<Client> = Client.fetchRequest()) {
        do {
            clients = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        self.clients.sort {
            $0.boxes! > $1.boxes!
        }
        tableView.reloadData()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Agregar Cliente", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Agregar", style: .default) { (action) in
            let newClient = Client(context: self.context)
            newClient.name = textField.text
            
            self.clients.append(newClient)
            self.saveClients()
            self.loadClients()
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
        let destinationVC = segue.destination as! ClientViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedPerson = clients[indexPath.row]
            destinationVC.displayTotal = { [weak self](boxes) in
                self!.clients[indexPath.row].boxes = boxes
                self!.tenesBrain.getNumOfBoxes(boxes)
            }

        }
    }
}
