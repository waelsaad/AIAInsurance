//
//  ViewExtensions.swift
//  AIAInsurance
//
//  Created by Wael Saad on 03/6/18.
//  Copyright © 2018 nettrinity.com.au. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    // Extension on View Controller so that Alert can be used in any controller
    func displayAlert(_ title: String, message: String, okBlock :(() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            guard let okBlck = okBlock else
            {
                return
            }
            okBlck()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
