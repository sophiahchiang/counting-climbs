//
//  ClimbService.swift
//  CountingClimbs
//
//  Created by Sophia Chiang on 4/7/23.
//

import Foundation
import UIKit

enum ClimbCallingError: Error {
    case problemGeneratingURL
    case problemGettingDataFromAPI
    case problemDecodingData
    case emptyAPI
}

class ClimbService {
    private let urlString = "https://run.mocky.io/v3/b3849c0b-c229-497d-878c-9808b7fe695d"
    // "https://run.mocky.io/v3/babf464a-0b67-4bbe-8770-b2e69cfac3f2" <- empty climb url for testing
    // "http://www.mocky.io/v2/5e9d1faf30000022cb0a80e1" <- incorrect bird url for testing

    
    func getClimbs(completion: @escaping ([Climb]?, Error?) -> ()) {
            guard let url = URL(string: self.urlString) else {
                DispatchQueue.main.async { completion(nil, ClimbCallingError.problemGeneratingURL) }
                return
        }
                
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async { completion(nil, ClimbCallingError.problemGettingDataFromAPI) }
                    return
                }
                
                do {
                    let climbResult = try JSONDecoder().decode(ClimbResult.self, from: data)
                    
                    //A way for the app's user to know that the list is empty
                    if climbResult.climbs.isEmpty {
                        DispatchQueue.main.async {
                                                let alertController = UIAlertController(title: "Empty List", message: "The climbs list is empty.", preferredStyle: .alert)
                                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                                alertController.addAction(okAction)
                                                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                                                
                                                completion(nil, ClimbCallingError.emptyAPI)
                                            }
                        //DispatchQueue.main.async { completion(nil, ClimbCallingError.emptyAPI) }
                    } else {
                        DispatchQueue.main.async { completion(climbResult.climbs, nil) }
                    }
                } catch (let error) {
                    //#8. Implement a UIAlertController so user knows if API call failed
                    print(error)
                                    DispatchQueue.main.async {
                                        let alertController = UIAlertController(title: "Error", message: "Failed to decode data from API.", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        alertController.addAction(okAction)
                                        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
                                        
                    completion(nil, ClimbCallingError.problemDecodingData) }
                }
                
                                                        
            }
            task.resume()
        }
    
}
