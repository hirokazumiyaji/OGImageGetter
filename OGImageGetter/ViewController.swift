//
//  ViewController.swift
//  OGImageGetter
//
//  Created by hirokazu on 10/27/16.
//  Copyright © 2016 hirokazu. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var ogImageView: UIImageView!

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.rx.tap.subscribe(onNext: { _ in
            if let url = self.text.text {
                if !url.isEmpty {
                    API.Get(url: url).subscribe { [weak self] in
                        guard let strongSelf = self else { return }
                        switch $0 {
                        case .next(let element):
                            if !(element?.isEmpty)! {
                                let ogImageURL = URL(string: element!)
                                strongSelf.ogImageView.sd_setImage(with: ogImageURL)
                            }
                        case .error(let error):
                            print(error)
                        case .completed:
                            print("completed")
                        }
                    }.addDisposableTo(self.disposeBag)
                }
            }
        }).addDisposableTo(disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
