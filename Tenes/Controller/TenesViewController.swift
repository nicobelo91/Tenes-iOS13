//
//  TenesViewController.swift
//  Tenes
//
//  Created by Nicolas Cobelo on 21/03/2021.
//

import UIKit
import CoreData
import ChameleonFramework

class TenesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var boxesInVivero: UILabel!
    @IBOutlet weak var totalBoxes: UILabel!
    
    var clients = [Client]()
    let tenesBrain = TenesBrain()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        loadClients()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ClientCell", bundle: nil), forCellReuseIdentifier: "ClientCell")
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadClients()
    }
    

    func saveClients() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.reloadAll()
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
        reloadAll()
        tableView.reloadData()
    }
    
    func reloadAll() {
        tableView.reloadData()
        let totalAmount = clients.map{(Int($0.boxes!) ?? 0)}.reduce(0, +)
        let totalBoxesDouble = Int(totalBoxes.text ?? "")!
        boxesInVivero.text = "\(totalBoxesDouble - totalAmount)"
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var clientName = UITextField()
        var boxes = UITextField()
        
        
        let alert = UIAlertController(title: "Agregar Cliente", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        let addAction = UIAlertAction(title: "Agregar", style: .default) { (action) in
            
            if clientName.text?.isEmpty ?? true || boxes.text?.isEmpty ?? true {
                
                let errorAlert = UIAlertController(title: "Agus, te faltó agregar uno de los campos", message: "", preferredStyle: .alert)
                self.present(errorAlert, animated: true, completion: nil)
                
                let understandAction = UIAlertAction(title: "Entendido", style: .cancel, handler: {(alert: UIAlertAction!) in print("understood")})
                errorAlert.addAction(understandAction)
            } else {
                
                let newClient = Client(context: self.context)
                newClient.name = clientName.text
                newClient.boxes = boxes.text
                
                self.clients.append(newClient)
                self.saveClients()
                self.loadClients()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Agregar cliente"
            clientName = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Agregar cajas"
            boxes = alertTextField
        }
    
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension TenesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as! ClientCell
        
        let client = clients[indexPath.row]
        cell.clientName.text = client.name
        cell.boxesOwed.text = client.boxes
        
        if let color = HexColor("#604020")?.lighten(byPercentage: CGFloat(indexPath.row) / CGFloat(clients.count)) {
            cell.backgroundColor = color
            cell.clientName.textColor = ContrastColorOf(color, returnFlat: true)
            cell.boxesOwed.textColor = ContrastColorOf(color, returnFlat: true)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.context.delete(self.clients[indexPath.row])
            clients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveClients()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Borrar") { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = UIColor.black
        return [deleteButton]
    }
}

extension TenesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
