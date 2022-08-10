//
//  ViewController.swift
//  ByteCoin
//
//  Created by Sebastian Güiza 08-08-2022
//

import UIKit

class CoinViewController: UIViewController{
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}

//MARK: - UIPickerViewDataSource & UIPickerViewDelegate

extension CoinViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    //Numbers of columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    //Numbers of items
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return coinManager.currencyArray.count
    }
    
    //Call the items from the array (currencyArray)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return coinManager.currencyArray [row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

//MARK: - CoinManagerDelegate

extension CoinViewController: CoinManagerDelegate{
    
    func didUpdatePrice(price: String, currency: String) {
       
        // Accede al hilo principal y ejecuta ese bloque de codigo
        DispatchQueue.main.async {
            
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
