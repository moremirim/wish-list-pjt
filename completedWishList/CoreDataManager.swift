//
//  CoreDataManager.swift
//  completedWishList
//
//  Created by 박미림 on 4/22/24.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared: CoreDataManager = .init() //shared는 이제 타입 이름을 통해서 접근 가능
    //lazy puts off its instantiation until its first use.
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Product")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
       return container
    }()
    
    private init() { } //private 단 하나의 인스턴스 생성!!
}
