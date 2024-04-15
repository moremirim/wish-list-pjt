//
//  WishListViewController.swift
//  wish-list-draft
//
//  Created by 박미림 on 4/14/24.
//
import CoreData
import UIKit

class WishListDetailViewController: UITableViewController {
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    private var savedWishList: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        setSavedWishList()
    }
    
    private func setSavedWishList() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        let request = Product.fetchRequest()
        
        if let savedWishList = try? context.fetch(request) {
            self.savedWishList = savedWishList
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedWishList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let product = self.savedWishList[indexPath.row]
        
        let id = product.id
        let title = product.title ?? ""
        let price = product.price
        let stock = product.stock
        
        cell.textLabel?.text = "[\(id)] \(title) - \(price) - \(stock) left in stock"
        return cell
    }
}
