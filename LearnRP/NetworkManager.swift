//
//  NetworkManager.swift
//  LearnRP
//
//  Created by Rohit Sharma on 13/06/23.
//

import Foundation
import RxSwift

class NetworkManager: ImageService{
    
    func requestData(url: URL) -> Observable<[Int]> {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                } else if let data = data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject) {
                            let decoder = JSONDecoder()
                            let apiData = try decoder.decode(APIData.self, from: jsonData)
                            let population = apiData.data.compactMap { $0.population }
                            observer.onNext(population)
                            observer.onCompleted()
                        }
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }

    func fetchImage(url: URL, completion: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { data, dataResponse, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let imageData = data, let photoGraph = UIImage(data: imageData) {
                completion(photoGraph)
            }
        }.resume()
    }
    
}



 

protocol ImageService {
    func fetchImage(url: URL, completion: @escaping (UIImage)-> Void)
}
