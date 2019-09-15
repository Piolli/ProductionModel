//
//  ViewController.swift
//  Lab1_AI
//
//  Created by Alexandr on 15/09/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var searchTextField: NSTextField!
 
    @IBOutlet weak var termsTableView: NSTableView!
    @IBOutlet weak var rulesTableView: NSTableView!
    
    @IBOutlet weak var newTermTextField: NSTextField!
    
    @IBOutlet weak var newRuleConditionTextField: NSTextField!
    @IBOutlet weak var newRuleResultTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func searchButtonWasTapped(_ sender: NSButton) {
        print(searchTextField.cell?.title)
    }
    
    @IBAction func appendNewTermButtonWasTapped(_ sender: Any) {
        print(newTermTextField.cell?.title)
    }
    
    @IBAction func appendNewRuleButtonWasTapped(_ sender: Any) {
        print(newRuleConditionTextField.cell?.title)
        print(newRuleResultTextField.cell?.title)
    }
}

