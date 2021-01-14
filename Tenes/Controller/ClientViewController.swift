//
//  PeopleViewController.swift
//  Tenes
//
//  Created by Nico Cobelo on 13/01/2021.
//

import UIKit
import CoreData

class ClientViewController: UIViewController {

    @IBOutlet var owedBefore: UILabel!
    @IBOutlet var totalOwed: UILabel!
    @IBOutlet var clientName: UILabel!
    @IBOutlet var numOfBoxesDelivered: UILabel!
    @IBOutlet var numOfBoxesReturned: UILabel!
    @IBOutlet var stepperDeliver: UIStepper!
    @IBOutlet var stepperReturn: UIStepper!
    var selectedPerson: Client? {
        didSet {
            //loadGroceries()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        clientName.text = selectedPerson?.name
        stepperReturn.wraps = true
        stepperReturn.autorepeat = true
        stepperReturn.maximumValue = 99
        stepperDeliver.wraps = true
        stepperDeliver.autorepeat = true
        stepperDeliver.maximumValue = 99
        
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        if sender == stepperDeliver {
            numOfBoxesDelivered.text = Int(sender.value).description
        } else if sender == stepperReturn {
            numOfBoxesReturned.text = Int(sender.value).description
        }
    }
    

}
