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
        loadRecords()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadRecords()
        bookTableView.reloadData()
    }
    
    func loadRecords(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let myContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = Book.fetchRequest() as NSFetchRequest<Book>
        
        
        do {
            try books = myContext.fetch(fetchRequest)
        }catch{
            print(error)
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookcell", for: indexPath)
        cell.backgroundColor = UIColor.init(red: 50/255, green: 111/255, blue: 168/255, alpha: 0.5)
        
        cell.textLabel?.text = books[indexPath.row].bookname
        return cell
     }

}
