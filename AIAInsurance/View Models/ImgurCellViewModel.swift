//
//  ImgurCellViewModel.swift
//  VirtusaTest
//
//  Created by Wael Saad on 26/4/18.
//  Copyright © 2018 nettrinity.com.au. All rights reserved.
//

import Foundation

class ImgurCellViewModel {
    
    let imageRecord : ImageRecord
    
    let title: String
    let imageUrl: String?
    let postDate: String?
    let index: Int
    let numberOfAdditionalPosts: Int
    
    init(imageRecord: ImageRecord, index: Int) {
        
        
        self.imageRecord = imageRecord
        self.index = index
        title = imageRecord.title!
        imageUrl = imageRecord.imageURL
        postDate = imageRecord.postDate
        numberOfAdditionalPosts = imageRecord.noOfAdditionalPosts!
    }
}
