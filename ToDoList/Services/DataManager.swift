//
//  DataManager.swift
//  ToDoList
//
//  Created by Ekaterina Teliauberdina on 26.01.2024.
//

import Foundation

final class DataManager {
    static let shared = DataManager()
    
    private let storageManager = StorageManager.shared
    
    private init() {}
    
    func createTempData(complition: @escaping() -> Void) {
        let shoppingList = TaskList()
        shoppingList.title = "Shopping List"
        let milk = Task()
        milk.title = "Milk"
        milk.note = "2L"
        let apples = Task(value: ["Apples", "2kg"])
        let bread = Task(value: ["title": "Bread", "isComplete": true])
        
        let moviesList = TaskList()
        moviesList.title = "Movies List"
        let filmOne = Task()
        filmOne.title = "Titanic"
        let filmTwo = Task()
        filmTwo.title = "Harry Potter"
        filmTwo.note = "All parts"
        
        
        shoppingList.tasks.insert(contentsOf: [milk, apples, bread], at: 1)
        moviesList.tasks.insert(contentsOf: [filmOne, filmTwo], at: 0)
        
        DispatchQueue.main.async{ [unowned self] in
            storageManager.save([shoppingList, moviesList])
            complition()
        }
    }
}

