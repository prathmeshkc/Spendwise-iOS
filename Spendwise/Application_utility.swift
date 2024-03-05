//
//  Application_Utility.swift
//  Spendwise
//
//  Created by Prathmesh Chaudhari on 1/3/24.
//

import Foundation
import UIKit

@MainActor
final class Application_utility {
    static var rootViewController: UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

