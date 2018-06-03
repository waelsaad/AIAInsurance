//
//  ImgurWebservice.swift
//  AIAInsurance
//
//  Created by Wael Saad on 03/6/18.
//  Copyright © 2018 nettrinity.com.au. All rights reserved.
//

import Foundation
import Alamofire

enum Result<T>{
    case response(T)
    case error(error: Error)
}

// Fetch the Images and Parse Them into the Model
class ImgurWebservice {
    typealias T = [ImageRecord]
    
    // Parse the object and return an array of models
    internal func parseFeed(jsonData: [String : Any]) -> [ImageRecord] {
        var dataArray: [ImageRecord] = []
        let data: NSDictionary = jsonData["data"] as! NSDictionary
        
        if let items = data["items"]   {
            let itemsData = items as! NSArray
            for item in itemsData {
                dataArray.append(ImageRecord(jsonDictionary: item as! [String : Any]))
            }
        }
        return dataArray
    }

    public func fetchFeed(searchText: String, completionHandler: @escaping (Result<T>) -> Void) {
        
        let header : HTTPHeaders = [
            "Authorization" : "Client-ID 6223a780505aafb"
        ]
        
        // Handle space character in search text while making the request.
        Alamofire.request(
            API.startURL + searchText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)! + API.endURL,
            method: .get,
            parameters: nil,
            headers: header)
            .responseString(completionHandler: { (response) in
                
            if let error = response.result.error {
                completionHandler(Result.error(error: error))
                return
            }
            
            if let data = response.result.value?.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                var jsonResult:Any
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                }
                catch {
                    completionHandler(Result.error(error: NSError(domain:"JSON Not Proper", code:1101, userInfo:nil)))
                    return
                }
                
                guard let jsonData = jsonResult as? [String: Any] else {
                    completionHandler(Result.error(error: NSError(domain:"JSON Not Proper", code:1101, userInfo:nil)))
                    return
                }
                
                let feedReceived = self.parseFeed(jsonData: jsonData)
                completionHandler(Result.response(feedReceived))
            }
        })
    }
}
