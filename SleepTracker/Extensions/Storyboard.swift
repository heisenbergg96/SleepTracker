//
//  Storyboard.swift
//  SleepTracker
//
//  Created by Vikhyath on 06/03/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension UIViewController: StoryboardIdentifiable {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

/// This extensions provide all stroyboard instances in mainbunbler by passing enum type along with that it will give all View Controller Instantiation from Generics
extension UIStoryboard {
    /// The uniform place where we state all the storyboard we have in our application
    enum Storyboard: String {
        case main = "Main"
    }
    
    /// Convenience Initializers
    convenience init(storyboard: Storyboard, bundle: Bundle? = Bundle.main) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    /// Class Functions
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = Bundle.main) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    /// View Controller Instantiation from Generics
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
}

