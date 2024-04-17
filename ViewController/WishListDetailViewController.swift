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
    @IBOutlet weak var deleteAllButton: UIBarButtonItem!
    
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
    //코어 데이터 자체에서 삭제해주어야 함!!!!!!!
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //var productArray = [savedWishList]
        var selectedProduct = savedWishList[indexPath.row]
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            //코어데이터 자체에서 삭제해준 뒤에 배열에서 삭제. 인덱스의 꼬임 방지!
            persistentContainer?.viewContext.delete(selectedProduct)
            savedWishList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            //tableView.reloadData() - 지우기
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            appDelegate.saveContext()
            
        }
    }
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //      if editingStyle == .delete {
    //        savedWishList.remove(at: indexPath.row)
    //        do {
    //            try persistentContainer?.viewContext.save()
    //          tableView.reloadData()
    //        } catch let error as NSError {
    //          print("Could not save. \(error), \(error.userInfo)")
    //        }
    //      }
    //    }
    
    
    //   //전체 삭제 버튼에 대한 함수 만들기.....!
    //    @IBAction func tappedDeleteAllButton(_ sender: Any) {
    //        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
    //        let batchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    //
    //        do {
    //            try
    //            persistentContainer?.viewContext.execute(NSBatchDeleteResult)
    //            print("Deleted All")
    //        } catch {
    //            print("Failed to delete detail of the wishlist.")
    //        }
    //    }
    //
}
