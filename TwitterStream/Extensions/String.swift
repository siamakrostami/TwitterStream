//
//  String.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/19/22.
//

import Foundation
import UIKit

extension String{
    //MARK: - Calculate text height
    func height(withConstrainedWidth width: CGFloat,_ size : CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let font = UIFont.systemFont(ofSize: size, weight: .regular)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
