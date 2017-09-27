//
//  ViewController.swift
//  RxSample
//
//  Created by HideakiTouhara on 2017/09/27.
//  Copyright © 2017年 HideakiTouhara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let minimalUsernameLength = 5
let minimalPasswordLength = 5

class SimpleValidationViewController: UIViewController {

    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!
    
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { $0.characters.count >= minimalUsernameLength }
            .shareReplay(1)
        
        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map { $0.characters.count >= minimalPasswordLength }
            .shareReplay(1)
        
        let everthingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .shareReplay(1)
        
        usernameValid.bind(to: passwordOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameValid.bind(to: usernameValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
        passwordValid.bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)
        
        everthingValid.bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doSomethingOutlet.rx.tap
            .subscribe(onNext: { [weak self] in self?.showAlert() })
            .disposed(by: disposeBag)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert() {
        let alertView = UIAlertView(title: "RxSample", message: "This is wonderful", delegate: nil, cancelButtonTitle: "OK")
        
        alertView.show()
    }


}

