//
//  ViewController.swift
//  TestExchangeRates
//
//  Created by Ira Golubovich on 3/6/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import UIKit


class ExchangeRatesViewController: UIViewController {
    
    let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Apologies sometimes went wrong. Please try again later"
        label.textAlignment = .center
        label.textColor = .black
        label.isHidden = false
        label.numberOfLines = 0
        return label
    }()
    
    @IBOutlet weak var tableView: UITableView!
    var results = [ExchangeRate]()
    let currencyKey = "Currency"
    var dictionaryKeys = Set<String>(["NumCode", "CharCode", "Scale", "Name", "Rate"])
    var currentDictionary: [String: String]?
    var currentValue: String?
    
    @IBAction func editButtonItem(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.addSubview(errorMessageLabel)
        
        NetworkService.shared.getData(url: URL(string: "http://www.nbrb.by/Services/XmlExRates.aspx")!) { (data, error) in
            if let data = data{
                let parser = XMLParser(data: data as! Data)
                parser.delegate = self
                print(data)
                
                if parser.parse() {
                    print(self.results)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            if error != nil {
                DispatchQueue.main.async {
                    self.errorMessageLabel.isHidden = false
                }
            }
        }
    }
}


extension ExchangeRatesViewController: UITableViewDelegate {

}

extension ExchangeRatesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exchangeRatesCell", for: indexPath) as! ExchangeRatesCell
        let rate = results[indexPath.row]
        cell.configer(with: rate)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            results.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.results[sourceIndexPath.row]
        results.remove(at: sourceIndexPath.row)
        results.insert(movedObject, at: destinationIndexPath.row)
    }
}

extension ExchangeRatesViewController: XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) {
        results = []
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == currencyKey {
            currentDictionary = [:]
        } else if dictionaryKeys.contains(elementName) {
            currentValue = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue? += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == currencyKey {
            let tmpS = ExchangeRate(numCode: currentDictionary!["NumCode"]!, charCode: currentDictionary!["CharCode"]!, scale: currentDictionary!["Scale"]!, name: currentDictionary!["Name"]!, rate: currentDictionary!["Rate"]!)
            results.append(tmpS)
            currentDictionary = nil
        } else if dictionaryKeys.contains(elementName) {
            currentDictionary![elementName] = currentValue
            currentValue = nil
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        
        currentValue = nil
        currentDictionary = nil
        results = []
    }
}
