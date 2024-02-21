//
//  ToDoListTableViewController.swift
//  ToDoList
//
//  Created by Ekaterina Teliauberdina on 26.01.2024.
//

import UIKit
import RealmSwift

class ToDoListTableViewController: UITableViewController {
    
    private var taskLists: Results<TaskList>!
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    private let storageManager = StorageManager.shared
    private var dataManager = DataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButtonItem
        
        createTempData()
        taskLists = storageManager.fetchData(TaskList.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - TableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        let taskList = taskLists[indexPath.row]
        content.text = taskList.title
        content.secondaryText = taskList.tasks.count.formatted()
        
        var completedTasks: [Task] = []
        
        taskList.tasks.forEach { completedTask in
            if completedTask.isComplete {
                completedTasks.append(completedTask)
            }
        }
        
        if completedTasks.count != taskList.tasks.count {
            content.secondaryText = "\(taskList.tasks.count - completedTasks.count)"
        } else if completedTasks.count == 0 && taskList.tasks.count == 0 {
            content.secondaryText = "0"
        }
        
        cell.accessoryType = completedTasks.count == taskList.tasks.count && taskList.tasks.count > 0
        ? .checkmark
        : .none

        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskList = taskLists[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            storageManager.delete(taskList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, isDone in
            showAlert(with: taskList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { [unowned self] _, _, isDone in
            storageManager.done(taskList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let tasksVC = segue.destination as? TasksTableViewController else { return }
        let taskList = taskLists[indexPath.row]
        tasksVC.taskList = taskList
    }
    
    // MARK: - IBActions
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
        taskLists = sender.selectedSegmentIndex == 0
        ? taskLists.sorted(byKeyPath: "date")
        : taskLists.sorted(byKeyPath: "title")
        
        tableView.reloadData()
    }
    
    // MARK: - OtherMethods
    
    @objc private func addButtonPressed() {
        showAlert()
    }
    
    private func createTempData() {
        if !UserDefaults.standard.bool(forKey: "done") {
            dataManager.createTempData { [unowned self] in
                UserDefaults.standard.setValue(true, forKey: "done")
                tableView.reloadData()
            }
        }
    }
}

// MARK: - AlertController

extension ToDoListTableViewController {
    private func showAlert(with taskList: TaskList? = nil, completion: (() -> Void)? = nil) {
        let alertBuilder = AlertControllerBuilder(
            title: taskList != nil ? "Edit List" : "New List",
            message: "Please set title for new task list"
        )
        
        alertBuilder
            .setTextField(withPlaceholder: "List Title", andText: taskList?.title)
            .addAction(title: taskList != nil ? "Update List" : "Save List", style: .default) { [weak self] newValue, _ in
                if let taskList, let completion {
                    self?.storageManager.edit(taskList, newValue: newValue)
                    completion()
                    return
                }
                
                self?.save(taskList: newValue)
            }
            .addAction(title: "Cancel", style: .destructive)
        
        let alertController = alertBuilder.build()
        present(alertController, animated: true)
    }
    
    private func save(taskList: String) {
        storageManager.save(taskList) { taskList in
            let rowIndex = IndexPath(row: taskLists.index(of: taskList) ?? 0, section: 0)
            tableView.insertRows(at: [rowIndex], with: .automatic)
        }
    }
}
