//
//  SecondViewController.swift
//  LearnRP
//
//  Created by Rohit Sharma on 23/05/23.
//

import UIKit
import RxSwift
import RxCocoa


    
class SecondViewController: UIViewController {
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: TableView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var secondLabel: UILabel!
    var thing: String
    var disposeBag = DisposeBag()
    let textValueChangedPublishedSubject = PublishSubject<String>()
    let networkRequestSubject = PublishSubject<[Int]>()
    let networkManager = NetworkManager()
    lazy var buttonTap = tapButton.rx.tap.asObservable()
    
    
    var dataSource = [Int]()
    let url = URL(string: "https://datausa.io/api/data?drilldowns=Nation&measures=Population")!
 
    init?(coder: NSCoder, thing: String) {
        self.thing = thing
        super.init(coder: coder)
        print(self.thing)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = thing
        tapButton.layer.cornerRadius = 10
        tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyTableViewCell")
        tableView.backgroundColor = .white
        // Do any additional setup after loading the view.
        _ = textValueChangedPublishedSubject.subscribe(onNext: { value in
            self.label.text = value
        })
        
        _ = textValueChangedPublishedSubject.subscribe(onNext: { value in
            self.secondLabel.text = "Hey there , \(value)"
        })
//        _ = networkManager.requestData(url: self.url).subscribe(onNext: { myData in
//            print(myData)
//        }, onError: { error in
//            print(error)
//        })
        observeUI()
        observeTableView()
        
    //    observeButton()
        self.view.backgroundColor = .systemMint
    }
    func observeUI() {
        textField.rx.controlEvent(.editingChanged)// Apply the debounce operator
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .withLatestFrom(textField.rx.text.orEmpty)
            .subscribe { [unowned textValueChangedPublishedSubject] text in
                textValueChangedPublishedSubject.onNext(text)
                EventManager.shared.triggerEvent(text)
            }.disposed(by: disposeBag)
        

        textField.rx.text.orEmpty
            .map { !$0.isEmpty}
            .bind(to: tapButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
    }
  
    func observeTableView() {
        
        
        buttonTap.flatMapLatest { _ in
            return self.networkManager.requestData(url: self.url)
        }.bind(to: tableView.rx.items(cellIdentifier: "MyTableViewCell", cellType: MyTableViewCell.self)) { index, data, cell in
            self.dataSource.append(data)
            cell.configure(data: data)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe { indexPath in
            print(self.dataSource[indexPath.row])
        }.disposed(by: disposeBag)
        
        

    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class ViewControllerFactory {
    enum ViewControllerTypes {
        case home
        case second(thing: String)
        case third
    }
    
  //  public var viewControllerType: ViewControllerTypes
    static func viewControllers(type: ViewControllerTypes) -> UIViewController {
        switch type {
        case .home:
            return UIViewController()
        case .second(let thing):
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SecondViewController") { coder -> SecondViewController? in
                SecondViewController(coder: coder,thing: thing)
            }
        case .third:
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ThirdViewController") as! ThirdViewController
        }
    }
}


@propertyWrapper class MyTable<Table: UITableView>: NSObject, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! MyTableViewCell
        cell.giveLabel.text = ""
        return cell
    }
    
    private var value: Table = Table()
    init(wrappedValue: Table){
        super.init()
        self.wrappedValue = wrappedValue
    }
    public var wrappedValue: Table {
        set {
            value = newValue
            value.delegate = self
            value.dataSource = self
            value.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "MyTableViewCell")
        }
        get {
            return value
        }
    }
}
class TableView: UITableView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .systemPurple
    }
}
