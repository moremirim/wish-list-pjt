//
//  ViewController.swift
//  completedWishList
//
//  Created by 박미림 on 4/19/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    private var randomNumber: Int? {
        (1...100).randomElement()
    }
    
    private var container: NSPersistentContainer {
        CoreDataManager.shared.persistentContainer
    }
    
    private var currentProduct: RemoteProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.fetchRemoteProduct ???? self.이 꼭 필요한지
        fetchRemoteProduct()
        
        self.scrollView.refreshControl = UIRefreshControl()
        self.scrollView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    @objc func refresh() {
        self.fetchRemoteProduct()
    }
    
    @IBAction func didTapAnotherItem(_ sender: Any) {
        fetchRemoteProduct()
    }
    
    @IBAction func didTapAddItem(_ sender: Any) {
        // MARK: - 코어데이터에 저장하기
     
        guard let currentProduct = self.currentProduct else { return }

        
        let product = Product(context: container.viewContext)
        
        product.id = Int16(currentProduct.id)
        product.title = currentProduct.title
        product.price = Int32(currentProduct.price)
        
        do {
            try container.viewContext.save()
        } catch {
            // MARK: - 에러처리
        }
    }
    private func fetchRemoteProduct() {
            
    //        var config = URLSessionConfiguration.ephemeral -> 캐시, 쿠키를 남기지 않는 설정 값
    //
    //        config.httpAdditionalHeaders = []
    //
    //        let sesssion = URLSession(configuration: config)
    //       session.dataTask(with: <#T##URLRequest#>)
            
            if let id = randomNumber,
               let url = URL(string: "https://dummyjson.com/products/\(id)") {
             
                let request = URLRequest(url: url)
                
                let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                    if let error {
                        //에러 처리
                    }
                    
                    guard let response = response as? HTTPURLResponse,
                          (200...299).contains(response.statusCode)
                    else {
                        return //에러처리
                    }
                    
                    if let data = data, //타입 자체를 전달할 때에는 타입에 .self를 붙여서 타입을 전달
                       let product = try? JSONDecoder().decode(RemoteProduct.self, from: data){
                        
                        DispatchQueue.main.async {
                            self?.scrollView.refreshControl?.endRefreshing()
                        }
                        
                        self?.currentProduct = product
                        
                        let priceText = self?.formatPrice(product.price)
                        
                        DispatchQueue.main.async {
                            
                            self?.titleLabel.text = product.title
                            self?.descriptionLabel.text = product.description
                            self?.priceLabel.text = "\(product.price) $"
                        }
                        
                        let imageRequest = URLRequest(url: product.thumbnail)
                        
                        let imageDataTask = URLSession.shared.dataTask(with: imageRequest) { [weak self] data, response, error in
                            
                            if let error {
                                //에러처리
                            }
                            
                            guard let response = response as? HTTPURLResponse,
                                  (200...299).contains(response.statusCode)
                            else {
                                return //에러처리
                            }
                            
                            if let data = data {
                                DispatchQueue.main.async {
                                    let image = UIImage(data: data)
                                    self?.imageView.image = image
                                }
                            }
                        }
                        imageDataTask.resume()
                    }
                }
                task.resume()
            }
        
    }
    
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return (formatter.string(from: price as NSNumber) ?? "") + "$"
    }
}

