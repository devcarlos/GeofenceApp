//
//  ViewController+Extension.swift
//  GeofenceApp
//
//  Created by Admin on 6/9/21.
//

import UIKit

extension BaseViewController {
    func showAlertWithAutoDismiss(title: String, message: String, time: TimeInterval) {
        if self.alert?.isBeingPresented != nil {
            return
        }

        self.alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        guard let alert = alert else {
            return
        }

        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + time , execute: {
            alert.dismiss(animated: true, completion: nil)
            self.alert = nil
        })
    }
}

class BaseViewController: UIViewController {
    var alert: UIAlertController?

}
