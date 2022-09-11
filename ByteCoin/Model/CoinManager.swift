//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didUpdateRate(rate: Double)
}


struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "ED6D0B9A-BDDD-43B9-8726-869E896680D3"
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency : String){
        let newURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: newURL)
    }
    func performRequest(with urlString: String){
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    let bitcoinPrice = parseJSON(safeData)
                    print(bitcoinPrice!)
                    delegate?.didUpdateRate(rate: bitcoinPrice!)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data)->Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decodedData.rate
            return lastPrice
        }catch{
            print(error)
            return nil
        }
    }
}

