//
//  ExchangeRatesViewCell.swift
//  TestExchangeRates
//
//  Created by Ira Golubovich on 3/6/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import UIKit


class ExchangeRatesCell: UITableViewCell {
    
    @IBOutlet weak var rateAndCharCode: UILabel!
    @IBOutlet weak var nameAndScale: UILabel!
    
    func configer(with rate: ExchangeRate) {
        self.rateAndCharCode.text = "\(rate.charCode) \(rate.rate) BYN"
        self.nameAndScale.text = "\(rate.name) за \(rate.scale) ед."
    }
}
