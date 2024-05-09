//
//  WishListViewController.swift
//  completedWishList
//
//  Created by 박미림 on 4/30/24.
//

import UIKit
import CoreData

class WishListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    private var wishList: [Product] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var container: NSPersistentContainer {
        CoreDataManager.shared.persistentContainer
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
        
        self.fetchWishList()
    }
    
    func fetchWishList() {
        
        let request = Product.fetchRequest()
        
        do {
            let wishlist = try container.viewContext.fetch(request)
            self.wishList = wishlist
        } catch {
            // MARK: - 에러처리
        }
    }
    
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return (formatter.string(from: price as NSNumber) ?? "") + "$"
    }
}

extension WishListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WishListItemTableViewCell", for: indexPath) as? WishListItemTableViewCell
        
        let product = wishList[indexPath.row]
        cell?.idLabel.text = "\(product.id)"
        cell?.titleLabel.text = product.title
        if let price = product.price as? Int {
            cell?.priceLabel.text = self.formatPrice(price)
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let selectedProduct = self.wishList[indexPath.row]
            container.viewContext.delete(selectedProduct)
            do {
                try container.viewContext.save()
                //1.저장소에서 다시 불러와서 self.wishList에 넣어줌
                //self.fetchWishList()
                self.wishList.remove(at: indexPath.row)
                //2. self.wishList.remove
                
            } catch {
                // MARK: - 에러처리
            }
        }
    }
    
    }

