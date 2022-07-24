//
//  UIViewController.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/19/22.
//

import Foundation
import UIKit

extension UIViewController{
    //MARK: - Hide keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
