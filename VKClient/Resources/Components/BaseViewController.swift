//
//  BaseViewController.swift
//  VKClient
//
//  Created by Павел on 14.04.2024.
//

import UIKit

protocol BaseViewControllerProtocol: AnyObject {
    func showAlert(message: String)
}

class BaseViewController: UIViewController {
    //MARK: - Property
    private lazy var infoAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = UIColor.vkWhite
        return alert
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}

//MARK: - Private functions
private extension BaseViewController {
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

//MARK: - BaseViewControllerProtocol
extension BaseViewController: BaseViewControllerProtocol {
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let messageString = NSAttributedString(string: message, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.vkBlack
            ])
            self.infoAlert.setValue(messageString, forKey: "attributedMessage")
            
            UIView.animate(withDuration: 0.3) {
                self.present(self.infoAlert, animated: true) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.infoAlert.dismiss(animated: true)
                    }
                }
            }
        }
    }
}
