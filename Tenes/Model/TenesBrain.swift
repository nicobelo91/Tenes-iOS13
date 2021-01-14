//
//  tenesBrain.swift
//  Tenes
//
//  Created by Nico Cobelo on 14/01/2021.
//

import Foundation

class TenesBrain {
    
    var boxes = "0"
    func getNumOfBoxes(_ numOfBoxes: String) {
        boxes = numOfBoxes
    }
    
    func updateNumOfBoxes() -> String {
        return boxes
    }
}
