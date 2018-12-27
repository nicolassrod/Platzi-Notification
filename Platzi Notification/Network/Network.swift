//
//  Network.swift
//  Platzi Notification
//
//  Created by Nicolás A. Rodríguez on 12/20/18.
//  Copyright © 2018 Nicolás Rodríguez. All rights reserved.
//

import Foundation
import UIKit

struct Network {
	let getApiUrl = URL(string: "https://platzi-agenda.herokuapp.com/get-agenda-data/")!
	
	func getDataFromApi(completion: @escaping (_ dataSerialized: DataAgenda?, _ error: Error?) -> Void) {
		let config = URLSessionConfiguration.default
		config.timeoutIntervalForRequest = 20.0
		config.requestCachePolicy = .useProtocolCachePolicy
		
		let session = URLSession(configuration: config)
		
		session.dataTask(with: getApiUrl) { (data, response, error) in
			guard error == nil else {
				completion(nil, error)
				return
			}
			
			guard let data = data else {
				completion(nil, error)
				return
			}
			
			do {
				let jsonSerialized = try JSONDecoder().decode(DataAgenda.self, from: data)
				completion(jsonSerialized, nil)
			} catch let DecodingError.dataCorrupted(context) {
				print(context)
			} catch let DecodingError.keyNotFound(key, context) {
				print("Key '\(key)' not found:", context.debugDescription)
				print("codingPath:", context.codingPath)
			} catch let DecodingError.valueNotFound(value, context) {
				print("Value '\(value)' not found:", context.debugDescription)
				print("codingPath:", context.codingPath)
			} catch let DecodingError.typeMismatch(type, context)  {
				print("Type '\(type)' mismatch:", context.debugDescription)
				print("codingPath:", context.codingPath)
			} catch {
				print("error: ", error)
			}
		}.resume()
	}
}
