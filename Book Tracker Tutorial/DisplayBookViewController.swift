//
//  DisplayBookViewController.swift
//  Cook Tracker1 Tutorial
//
//  Created by Sebastian Antony on 7/20/20.
//  Copyright © 2020 Sebastian Antony. All rights reserved.
//

import UIKit
import CoreData

class DisplayBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var bookTableView: UITableView!
    var books:[Book]=[]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        bookTableView.delegate = self
        bookTableView.dataSource = self
        loadRecords(status: "Currently Reading")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadRecords(status: "Currently Reading")
        bookTableView.reloadData()
    }
    
    func loadRecords(status: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = Book.fetchRequest() as NSFetchRequest<Book>
        let predicate = NSPredicate(format: "status == %@", status)
        fetchRequest.predicate = predicate
        
        do {
            try books = myContext.fetch(fetchRequest)
        }catch{
            print(error)
        }
    }
   
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        var status:String = "Currently Reading"
        switch sender.selectedSegmentIndex {
        case 0:
            status = "Currently Reading"
        case 1:
            status = "To Read"
        default:
            status = "Read"
        }
        loadRecords(status: status)
        bookTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookcell", for: indexPath)
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 204/255, alpha: 1)
        }else{
            cell.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 153/255, alpha: 1)
        }
        
        cell.textLabel?.text = books[indexPath.row].bookname
        return cell
     }

    /* func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            //print(books[indexPath.row].bookname!)
            deleteBook(bookLocation: indexPath.row)
            books.remove(at: indexPath.row)
            tableView.reloadData()
            }
    }*/
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, success) in
            self.deleteBook(bookLocation: indexPath.row)
            self.books.remove(at: indexPath.row)
            tableView.reloadData()
        })
        let updateAction = UIContextualAction(style: .normal, title: "Update", handler: { (action, view, success) in
        //print(self.books[indexPath.row].bookname!)
            let navController = self.tabBarController?.viewControllers?[1] as! UINavigationController
            let viewController = navController.viewControllers[0] as! AddBookViewController
            navController.navigationBar.topItem?.title = "Edit Book"
            self.tabBarController?.tabBar.items?[1].title = "Edit Book"
            
            viewController.book.bookname = self.books[indexPath.row].bookname
            viewController.book.authorname = self.books[indexPath.row].authorname
            viewController.book.genre = self.books[indexPath.row].genre
            viewController.book.status = self.books[indexPath.row].status
            self.tabBarController?.selectedIndex = 1
    })
        
        updateAction.backgroundColor = .gray
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [updateAction,deleteAction])
    }
    
    func deleteBook( bookLocation: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Book.fetchRequest() as NSFetchRequest<Book>
        let predicate = NSPredicate(format:  "bookid == %@", books[bookLocation].bookid!)
        fetchRequest.predicate = predicate
        
        var booksToDelete = [Book]()
        do {
            booksToDelete = try context.fetch(fetchRequest)
        }catch let error {
            print(error)
        }
        for book in booksToDelete{
            context.delete(book)
            do{
                try context.save()
            } catch let error{
                print(error)
            }
        }
    }
}
