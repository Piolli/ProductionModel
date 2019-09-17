//
//  ViewController.swift
//  Lab1_AI
//
//  Created by Alexandr on 15/09/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Cocoa

let terms = ["минуты", "интернет", "звонкиПоРоссии", "тв", "планшет", "смс", "клиент", "звонкиПоСтранам", "ежедневнаяОплата"]

let plans = ["Звонки По России", "Супер (для своих)", "Простой тариф", "Нормальный тариф", "Для общения"]

var rules = [
    "минуты и интернет и звонкиПоРоссии": plans[0],
    "минуты или интернет и звонкиПоРоссии": plans[0],
    "интернет и звонкиПоРоссии": plans[0],
    "минуты и звонкиПоРоссии": plans[0],
    "минуты и смс и интернет и звонкиПоРоссии": plans[0],
    "минуты и смс и звонкиПоРоссии": plans[0],
    "смс и звонкиПоРоссии": plans[0],
    "смс и звонкиПоРоссии и ежедневнаяОплата": plans[0],
    "смс и звонкиПоРоссии или ежедневнаяОплата": plans[0],
    
    "клиент или смс или интернет": plans[1],
    "клиент или смс или интернет или звонкиПоРоссии": plans[1],
    "клиент или смс и интернет": plans[1],
    "клиент и смс или интернет": plans[1],
    "клиент или звонкиПоСтранам и интернет": plans[1],
    "клиент и смс и интернет и планшет": plans[1],
    "смс и звонкиПоРоссии и интернет": "Просто Супер"
]

func generateRules() {
    for _ in 0...50 {
        var resultRule = ""
        
        let randTermsCount = Int.random(in: 0..<terms.count)
        for i in 0...randTermsCount {
            let randOperator = Bool.random() ? " и " : " или "
            resultRule.append(terms[i])
            
            if i != randTermsCount {
                resultRule.append(randOperator)
            }
        }
        
        if rules[resultRule] == nil {
            rules[resultRule] = plans.randomElement()!
        }
    }
}


enum FileName : String {
    case Terms = "terms.txt"
    case Rules = "rulse.txt"
}

class ViewController: NSViewController {

    @IBOutlet weak var searchTextField: NSTextField!
 
    @IBOutlet weak var termsTableView: NSTableView!
    @IBOutlet weak var rulesTableView: NSTableView!
    
    @IBOutlet weak var newTermTextField: NSTextField!
    
    @IBOutlet weak var newRuleConditionTextField: NSTextField!
    @IBOutlet weak var newRuleResultTextField: NSTextField!
    
    var rulesDict: [String : String] = [:]
    var termsArray: [String] = []
    
    var termsDS: TermsListDataSource!
    var rulesDS: RulesListDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//uncomment below if you haven't files with terms and rules
//        generateAndSaveToFilesTermsAndRules()
        
        loadTermsAndRulesFromFiles()
        
        termsDS = TermsListDataSource(terms: self.termsArray)
        rulesDS = RulesListDataSource(rules: self.rulesDict)
        
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
    
    func loadTermsAndRulesFromFiles() {
        self.termsArray = getTerms()
        self.rulesDict = getRules()
    }
    
    func generateAndSaveToFilesTermsAndRules() {
        generateRules()
        saveRules(rules: rules)
        saveTerms(terms: terms)
    }
    
    func updateTables() {
        termsDS.terms = termsArray
        rulesDS.rules = rulesDS.dictToArray(self.rulesDict)
        self.termsTableView.reloadData()
        self.rulesTableView.reloadData()
    }

    @IBAction func searchButtonWasTapped(_ sender: NSButton) {
        guard var searchText = searchTextField.cell?.title else {
            dialogOKCancel(message: "Error", informativeText: "search text is empty!")
            return
        }
        
        searchText = normalize(text: searchText)
        let textTerms = divideTextToPiecesAndOr(text: searchText)
        
        var suggestedPlans: [String] = []
        
        for (ruleCondition, ruleResult) in self.rulesDict {
            let normalizeRuleCondition = normalize(text: ruleCondition)
            let ruleTerms = divideTextToPiecesAndOr(text: normalizeRuleCondition)
            
            if compare(terms: textTerms, with: ruleTerms) {
                if suggestedPlans.contains(ruleResult) {
                    continue
                }
                
                suggestedPlans.append(ruleResult)
                dialogOKCancel(message: "Найден подходящий тариф!", informativeText: "Тариф для вас –  \(ruleResult)", alertStyle: .informational)
            }
        }
    }
    
    func normalize(text: String) -> String {
        return text.lowercased()
    }
    
    func compare(terms terms1: [[String]], with terms2: [[String]]) -> Bool {
        var isEquals = false
        for termSplittedOr in terms1 {
            for ruleTermSplittedOr in terms2 {
                if ruleTermSplittedOr.count > termSplittedOr.count {
                    continue
                }
                isEquals = true
                
                for termSplittedAnd in termSplittedOr {
                    if !ruleTermSplittedOr.contains(termSplittedAnd) {
                        isEquals = false
                        break
                    }
                }
            }
        }
        
        return isEquals
    }
    
    func divideTextToPiecesAndOr(text: String) -> [[String]] {
        var termsDividedByOrOperator: [[String]] = []
        
        let termsSplittedOr = text.components(separatedBy: " или ")
        
        for termSplittedOr in termsSplittedOr {
            let termsSplittedAnd = termSplittedOr.components(separatedBy: " и ")
            termsDividedByOrOperator.append(termsSplittedAnd)
        }
        
        return termsDividedByOrOperator
    }
    
    @IBAction func appendNewTermButtonWasTapped(_ sender: Any) {
        guard let newTerm = newTermTextField.cell?.title else {
            dialogOKCancel(message: "Error", informativeText: "new Term cannot be added to file!")
            return
        }
        
        self.termsArray.append(newTerm)
        saveTerms(terms: self.termsArray)
        updateTables()
    }
    
    @IBAction func appendNewRuleButtonWasTapped(_ sender: Any) {
        guard let newRuleCondition = newRuleConditionTextField.cell?.title, let newRuleResult = newRuleResultTextField.cell?.title  else {
            dialogOKCancel(message: "Error", informativeText: "new Rule cannot be added to file!")
            return
        }
        
        self.rulesDict[newRuleCondition] = newRuleResult
        saveRules(rules: self.rulesDict)
        updateTables()
    }

    func dialogOKCancel(message: String, informativeText: String, alertStyle: NSAlert.Style = .critical) {
        let alert: NSAlert = NSAlert()
        alert.messageText = message
        alert.informativeText = informativeText
        alert.alertStyle = alertStyle
        alert.addButton(withTitle: "Ok")
        alert.runModal()
    }
}

//MARK: Rules
class RulesListDataSource : NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    var rules: [(String, String)]
    
    init(rules: [String: String]) {
        var array: [(String, String)] = []
        
        for (key, value) in rules {
            array.append((key, value))
        }
        self.rules = array
    }
    
    func dictToArray(_ dict: [String : String]) -> [(String, String)] {
        var array: [(String, String)] = []
        
        for (key, value) in dict {
            array.append((key, value))
        }
        
        return array
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
    
    var terms: [String]
    
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


//MARK: Work with files
extension ViewController {
    func saveTerms(terms: [String]) {
        let fileUrl = getFileUrl(fileName: FileName.Terms.rawValue)
        try! (terms as NSArray).write(to: fileUrl, atomically: true)
    }
    
    func getTerms() -> [String] {
        let url = getFileUrl(fileName: FileName.Terms.rawValue)
        return NSArray(contentsOf: url)! as! [String]
    }
    
    func getRules() -> [String : String] {
        let url = getFileUrl(fileName: FileName.Rules.rawValue)
        return NSDictionary(contentsOf: url)! as! [String : String]
    }
    
    func saveRules(rules: [String : String]) {
        let fileUrl = getFileUrl(fileName: FileName.Rules.rawValue)
        try! (rules as NSDictionary).write(to: fileUrl, atomically: true)
    }
    
    func getFileUrl(fileName: String) -> URL {
        // get URL to the the documents directory in the sandbox
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        // add a filename
        let fileUrl = documentsUrl.appendingPathComponent(fileName)!
        return fileUrl
    }
}
