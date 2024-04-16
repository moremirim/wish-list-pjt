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
    
    //editingStyleForRowAt -> .delete / .insert
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
    
    
    //canEditRowAt을 통해서도 구현 가능 -> editable할 때, cell은 EditingStyle.delete를 세팅받음
    //52-54 지우고 적음
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //commit editingStyle
    //삭제한 뒤에 삭제한 내역을 다시 저장해주는 로직 필요
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            savedWishList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}
