// Package: Letras,
// File name: UIHelper.swift,
// Created by David Herrero on 28/11/2019.

import Foundation
import UIKit

class UIHelper{
    
    static func showToast(controller: UIViewController, message: String, seconds: Double){
        let alert = UIAlertController(title: "Vaya...", message: message, preferredStyle: .alert)
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            
            alert.dismiss(animated: true)
            
        }
    }
    
}
