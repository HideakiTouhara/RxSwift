//
//  CustomPickerViewAdapterExampleViewController.swift
//  RxSample
//
//  Created by HideakiTouhara on 2017/10/05.
//  Copyright © 2017年 HideakiTouhara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CustomPickerViewAdapterExampleViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.just([[1,2,3], [4,5,6], [7,8]])
            .bind(to: pickerView.rx.items(adapter: PickerViewAdapter()))
            .disposed(by: disposeBag)
        
        pickerView.rx.modelSelected(Int.self)
            .subscribe(onNext: { model in
                print(model)
            })
            .disposed(by: disposeBag)
    }

}

final class PickerViewAdapter: NSObject, UIPickerViewDataSource, UIPickerViewDelegate, RxPickerViewDataSourceType, SectionedViewDataSourceType {
    typealias Element = [[CustomStringConvertible]]
    var items: [[CustomStringConvertible]] = []
    
    func model(at indexPath: IndexPath) throws -> Any {
        return items[indexPath.section][indexPath.row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = items[component][row].description
        label.textColor = UIColor.orange
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
        UIBindingObserver(UIElement: self) { (adapter, items) in
            adapter.items = items
            pickerView.reloadAllComponents()
        }.on(observedEvent)
    }
    
    
    
    
}
