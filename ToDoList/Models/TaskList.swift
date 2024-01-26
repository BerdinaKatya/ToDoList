//
//  TaskList.swift
//  ToDoList
//
//  Created by Ekaterina Teliauberdina on 26.01.2024.
//

import Foundation

final class TaskList {
    var title = ""
    var date = Date()
    var tasks = [Task]()
}

final class Task {
    var title = ""
    var date = Date()
    var note = ""
    var isComplete = false
}
