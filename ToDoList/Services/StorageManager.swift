//
//  StorageManager.swift
//  ToDoList
//
//  Created by Ekaterina Teliauberdina on 26.01.2024.
//

import Foundation
import RealmSwift

final class StorageManager {
    static let shared = StorageManager()
    
    private let realm = try! Realm()
    
    private init() {}
    
    func fetchToDoList() -> [TaskList] {
        []
    }
    
    func save(_ taskLists: [TaskList]) {
        try! realm.write {
            realm.add(taskLists)
        }
    }
    
    func save(_ list: String, complition: (TaskList) -> Void) {
        
    }
    
    func delete(_ tasks: TaskList) {
        
    }
    
    func edit(_ tasks: TaskList, newValue: String) {
        
    }
    
    func done(_ tasks: TaskList) {
        
    }
}
