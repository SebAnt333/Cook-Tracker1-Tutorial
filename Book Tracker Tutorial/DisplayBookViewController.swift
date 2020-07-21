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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            //print(books[indexPath.row].bookname!)
            deleteBook(bookLocation: indexPath.row)
            }
    }
    
    func deleteBook( bookLocation: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Book.fetchRequest() as NSFetchRequest<Book>
        let predicate = NSPredicate(format:  "bookname == %@", books[bookLocation].bookname!)
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
