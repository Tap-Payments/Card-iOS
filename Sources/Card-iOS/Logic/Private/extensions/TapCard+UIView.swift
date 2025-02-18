//
//  File.swift
//  
//
//  Created by Osama Rabie on 07/10/2023.
//

import Foundation
import UIKit

extension UIView {
    /// Fetch the parent uiviewcontroller for the provided view
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
