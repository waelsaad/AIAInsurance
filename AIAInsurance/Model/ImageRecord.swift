//
//  ImageRecord
//  AIAInsurance
//
//  Created by Wael Saad on 03/6/18.
//  Copyright © 2018 nettrinity.com.au. All rights reserved.
//

import Foundation

struct ImageRecord {
    let title: String?
    var postDate: String?
    var imageURL: String?
    let points: Int?
    let score: Int?
    var topicId: Int?
    var isEvenNumber: Bool? = false
    let totalNo: String? = ""
    let currentIndex: String? = ""
    var noOfAdditionalPosts: Int? = 0
    
    init(jsonDictionary: [String: Any]) {
        self.title = (jsonDictionary["title"] as? String)!
        self.points = (jsonDictionary["points"] as? Int) ?? nil
        self.score = (jsonDictionary["score"] as? Int) ?? nil
        self.topicId = (jsonDictionary["topic_id"] as? Int) ?? nil
        
        let sum = score! + points! + topicId!
        
        if sum % 2 == 0 {
            self.isEvenNumber = true
        }
        
        if let noOfPosts = jsonDictionary["images_count"] as? Int {
            self.noOfAdditionalPosts = (noOfPosts > 0) ? noOfPosts - 1 : 0
        }

        //Ensure there will alwayes be at least one image.
        if let images = jsonDictionary["images"] as? [[String: Any]] {
            self.imageURL = images[0]["link"] as? String
            let dateString:Double = images[0]["datetime"] as! Double
            self.postDate = dateString.getDateStringFromUTC()
        }
    }
}
