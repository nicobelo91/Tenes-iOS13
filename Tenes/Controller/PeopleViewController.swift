//
//  PeopleViewController.swift
//  Tenes
//
//  Created by Nico Cobelo on 13/01/2021.
//

import UIKit
import CoreData

class PeopleViewController: UIViewController {

    @IBOutlet var personName: UILabel!
    @IBOutlet var numOfBoxesDelivered: UILabel!
    @IBOutlet var numOfBoxesReturned: UILabel!
    @IBOutlet var stepperDeliver: UIStepper!
    @IBOutlet var stepperReturn: UIStepper!
    var selectedPerson: Person? {
        didSet {
            //loadGroceries()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        personName.text = selectedPerson?.name
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
