//
//  ImgurViewModel.swift
//  AIAInsurance
//
//  Created by Wael Saad on 03/6/18.
//  Copyright © 2018 nettrinity.com.au. All rights reserved.
//

import Foundation

protocol NetworkResponse {
    func stateChanged(success : Bool, error: String)
}

class ImgurViewModel {
    
    var isFiltered: Bool! = false
    var numberOfCells : Int { return imageList.count }
    //var numberOfCells : Int { return isFiltered ? imageList.filter{ $0.isEvenNumber == true }.count : imageList.count }
    private let webservice :ImgurWebservice
    var imageList  = Array<ImageRecord>.init()
    private var selectedCell : Int?
    private let delegate: NetworkResponse
    
    func viewModelForCell(at index: Int) -> ImgurCellViewModel {
        return ImgurCellViewModel(imageRecord: imageList[index], index: index)
    }
    
    func cellSelected(index: Int) {
        selectedCell = index
    }
    
    func selectedViewModel() -> ImgurCellViewModel {
        return viewModelForCell(at: selectedCell!)
    }
    
    init(delegate : NetworkResponse) {
        self.delegate = delegate
        webservice = ImgurWebservice.init()
    }
    
    // Fetch the images data and display it
    func refreshData(searchText: String) {
        webservice.fetchFeed(searchText: searchText) { (result) in
            switch result{
            case .response(let data):
                //print(data.count)
                //print(data.filter{ $0.isEvenNumber == true }.count)
                //Filter based on if even number or not
                self.imageList = (self.isFiltered) ? data.filter{ $0.isEvenNumber == true } : data
                self.delegate.stateChanged(success: true, error: "")
                break
            case .error(error: let error):
                self.imageList.removeAll()
                self.delegate.stateChanged(success: false, error: error.localizedDescription)
                break
            }
        }
    }
}
