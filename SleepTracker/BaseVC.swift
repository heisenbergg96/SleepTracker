//
//  BaseVC.swift
//  Sensors
//
//  Created by Vikhyath on 13/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func presentAlert(_ title: String, body: String, animated: Bool = true, completion: (() -> Void)? = nil) {
        
        DispatchQueue.main.async(execute: { [weak self] in
            guard let strongSelf = self else { return }
            
            let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
            
            if let completion = completion {
                func proxy(_ action: UIAlertAction) {
                    completion()
                }
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: proxy))
            } else {
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
            strongSelf.present(alert, animated: animated, completion: nil)
        })
    }
    
    func presentAlert(title: String, body: String, animated: Bool = true, alertActions: [AlertAction]) {
        
        DispatchQueue.main.async(execute: { [weak self] in
            
            guard let strongself = self else { return }
            
            let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
            
            for alertAction in alertActions {
                alert.addAction(UIAlertAction(title: alertAction.title, style: .default, handler: alertAction.action))
            }
            strongself.present(alert, animated: animated, completion: nil)
        })
    }
}
