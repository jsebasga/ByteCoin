//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Sebastian Güiza 08-08-2022
//

import Foundation

protocol CoinManagerDelegate{
    
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "47BCAE77-3BDA-4B62-A145-0A183E69FD64"
    
    let currencyArray = ["AUD","BRL","CAD","COP","CLP","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
//MARK: - Llamado del servicio
    
    func getCoinPrice(for currency: String){
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        
        if let url = URL(string: urlString){
            
            // Configura la URL
            let session = URLSession(configuration: .default)
            
            // Define una tarea - Ejecutar una peticion a URL
            let task = session.dataTask(with: url) { (data, response, error) in
                
                // Unwrap data - Valida si error es nulo, sino, se ejecuta la accion
                if let safeError = error{
                    
                    print(safeError)
                    return
                }
                
                // Unwrap data - Valida si data es nulo, sino, se ejecuta la accion
                if let safeData = data {
                    
                    if let bitcoinPrice = self.parseJSON(safeData){
                        
                        let priceString = String(format:"%2.f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            
            // Ejecuta la tarea del DATA TASK
            task.resume()
        }
    }
    
//MARK: - Transformacion del JSON a Swift
    
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        do {
            
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice
            
        } catch {
            
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
