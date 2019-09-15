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
    
    let terms = ["term1", "term2", "term3"]
    let rules = [("condition1", "result1"), ("condition2", "result2"), ("condition3", "result3")]
    let termsDS = TermsListDataSource(terms: ["term1", "term2", "term3"])
    let rulesDS = RulesListDataSource(rules: [("condition1 & condition1 & condition1 & condition1 & condition1 & condition1", "result1"), ("condition2", "result2"), ("condition3", "result3")])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rulesTableView.dataSource = rulesDS
        rulesTableView.delegate = rulesDS
        
        termsTableView.dataSource = termsDS
        termsTableView.delegate = termsDS
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

//MARK: Rules
class RulesListDataSource : NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    let rules: [(String, String)]
    
    init(rules: [(String, String)]) {
        self.rules = rules
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return rules.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let cell = NSTableCellView()
        cell.textField?.cell?.title = rules[row].0
        return cell
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: .init("cell"), owner: nil) as? NSTableCellView {
            let cellText = tableColumn!.identifier.rawValue == "condition" ? rules[row].0 : rules[row].1
            cell.textField?.cell?.title = cellText
            return cell
        }
        
        return nil
    }
}

//MARK: Terms
class TermsListDataSource : NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    let terms: [String]
    
    init(terms: [String]) {
        self.terms = terms
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return terms.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let cell = NSTableCellView()
        cell.textField?.cell?.title = terms[row]
        return cell
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: .init("cell"), owner: nil) as? NSTableCellView {
            cell.textField?.cell?.title = terms[row]
            return cell
        }
        
        return nil
    }
}
