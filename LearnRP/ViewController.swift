//
//  ViewController.swift
//  LearnRP
//
//  Created by Rohit Sharma on 22/05/23.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {

    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    var disposeBag = DisposeBag()
    var myThing: String = "Swift"
    lazy var buttonTapPublisher = button.rx.tap.asObservable()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.text = "This should change"
        observeButton()
        observeLabel()
    }
    
    func observeButton() {
        buttonTapPublisher
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                let vc = ViewControllerFactory.viewControllers(type: .second(thing: self.myThing))
                self.present(vc, animated: true)
            }.disposed(by: disposeBag)
        
        
        
        secondButton.rx.tap.subscribe { _ in
            print("Clicked")
            let vc = ViewControllerFactory.viewControllers(type: .third)
            self.present(vc,animated: true)
        }.disposed(by: disposeBag)
        
    }
    func observeLabel() {
        EventManager.shared.eventSubject
                    .subscribe(onNext: { [weak self] value in
                        self?.label.text = value
                    })
                    .disposed(by: disposeBag)
    }
}

class EventManager {
    static let shared = EventManager()
    private init() {}
    
    let eventSubject = PublishSubject<String>()
    
    func triggerEvent(_ with: String) {
        eventSubject.onNext(with)
    }
}
