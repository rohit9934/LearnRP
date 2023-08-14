//
//  ThirdViewController.swift
//  LearnRP
//
//  Created by Rohit Sharma on 13/08/23.
//

import UIKit
import RxSwift
import RxRelay
class ThirdViewController: UIViewController {

    
    @IBOutlet weak var apiImageView: UIImageView!
    let dogsURL = "https://images.dog.ceo/breeds/spaniel-cocker/n02102318_12877.jpg"
    let imageService: ImageService = NetworkManager()
    let userBalanceRelay = BehaviorRelay<Int>(value: 5)
    let productPriceRelay = BehaviorRelay<Int>(value: 10)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        makeRequest()
     //   let canMakePurchase = Observable
      //      .combineLatest(userBalanceRelay, productPriceRelay).map{$0 < $1}
        // Do any additional setup after loading the view.
    }
    
    func makeRequest() {
        guard let url = URL(string: dogsURL) else {return}
        imageService.fetchImage(url: url) { [unowned apiImageView] image in
            DispatchQueue.main.async {
                apiImageView?.image = image
            }
        }
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
