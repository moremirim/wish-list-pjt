//
//  ViewController.swift
//  wish-list-draft
//
//  Created by 박미림 on 4/14/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    //랜덤 상품의 상품 정보 가져오기
    private var randomProduct: RemoteProduct? = nil {
        didSet {
            guard let randomProduct = self.randomProduct else {
                return
            }
            DispatchQueue.main.async {
                self.thumbnailImageView.image = nil
                self.titleLabel.text = randomProduct.title
                self.descriptionLabel.text = randomProduct.description
                self.priceLabel.text = "\(randomProduct.price)"
                self.stockLabel.text = "\(randomProduct.stock)"
            }
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: randomProduct.thumbnail), let image = UIImage(data: data) {
                    DispatchQueue.main.async { self?.thumbnailImageView.image = image }
                }
            }
        }
    }
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRemoteProduct()
    }
    
    //다른 상품 보기 버튼
    @IBAction func tappedAnotherItemButton(_ sender: UIButton) {
        self.fetchRemoteProduct()
    }
    
    //위시리스트 담기 버튼
    @IBAction func tappedAddToWishlistButton(_ sender: UIButton) {
        self.addToWishlist()
    }
    
    //나의 위시리스트 보기 버튼
    @IBAction func tappedMyWishlistButton(_ sender: UIButton) {
        //WishListDetailViewController 보여주기
        guard let wishListVC = self.storyboard?.instantiateViewController(identifier: "WishListDetailViewController") as? WishListDetailViewController else { return }
        self.present(wishListVC, animated: true)
    }
    
    private func fetchRemoteProduct() {
        let productID = Int.random(in: 1...100)
        //URLSession을 통해 RemoteProduct 가져오기
        if let url = URL(string:  "https://dummyjson.com/products/\(productID)") {
            let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                        self.randomProduct = product
                    } catch {
                        print("Decode Error: \(error)")
                    }
                }   
            }
            
            session.resume()
        }
    }
    
    private func addToWishlist() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        guard let randomProduct = self.randomProduct else { return }
        
        let wishProduct = Product(context: context)
        
        wishProduct.id = randomProduct.id
        wishProduct.title = randomProduct.title
        wishProduct.price = randomProduct.price
        wishProduct.stock = randomProduct.stock
        
        try? context.save()
    }
}
