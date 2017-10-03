//
//  NumbersViewController.swift
//  RxSample
//
//  Created by HideakiTouhara on 2017/10/03.
//  Copyright © 2017年 HideakiTouhara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NumbersViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var number1: UITextField!
    @IBOutlet weak var number2: UITextField!
    @IBOutlet weak var number3: UITextField!
    
    @IBOutlet weak var result: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) {
            textValue1, textValue2, textValue3 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description }
            .bind(to: result.rx.text)
            .disposed(by: disposeBag)
    }
}
