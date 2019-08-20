//
//  ViewController.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        bindPresenter()
    }
    
    func prepare() {}
    
    func bindPresenter() {}

    func showAlert(title: String, message: String, buttonText: String,
                   alertAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")
                alertAction()
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func push(to viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
