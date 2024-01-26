//
//  StorageManager.swift
//  ToDoList
//
//  Created by Ekaterina Teliauberdina on 26.01.2024.
//

import Foundation

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    func fetchToDoList() -> [TaskList] {
        []
    }
    
    func save(_ lists: [TaskList]) {
        
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
