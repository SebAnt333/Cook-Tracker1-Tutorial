//
//  AddBookViewController.swift
//  Book Tracker Tutorial
//
//  Created by Sebastian Antony on 6/12/20.
//  Copyright © 2020 Sebastian Antony. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bookTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var genreTextField: UITextField!
    @IBOutlet weak var genreTableView: UITableView!
    @IBOutlet weak var statusTextField: UITextField!
    
     //MARK: All class variables
    var genreArray:[String] = ["Non Fiction", "Fiction", "Thriller", "Suspense", "Biography", "Technical", "Romance"]
    var statusArray:[String] = ["Read","Currently Reading","To Read"]
    
    var genreTempArray:[String]=["Non Fiction", "Fiction", "Thriller", "Suspense", "Biography", "Technical", "Romance"]
    var genreSearchArray:[String]=[]
    var statusTempArray:[String] = []
    var isGenre:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genreTableView.delegate = self
        genreTableView.dataSource = self
        
        statusTextField.isEnabled = false
        genreTempArray = genreArray
        genreArray = statusArray
        }
    
    override func viewDidAppear(_ animated: Bool) {
          genreTableView.frame = CGRect.init(
                  x:statusTextField.frame.origin.x,
                  y:statusTextField.frame.origin.y + statusTextField.frame.height + 1,
                  width: statusTextField.frame.width,
                  height: 300)    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        bookTextField.text = ""
        bookTextField.placeholder = "Enter Book Name"
        bookTextField.layer.borderWidth = 0
        bookTextField.layer.borderColor = UIColor.gray.cgColor
        authorTextField.text = ""
        authorTextField.placeholder = "Enter Author Name"
        authorTextField.layer.borderWidth = 0
        authorTextField.layer.borderColor = UIColor.gray.cgColor
        genreTextField.text = ""
        genreTextField.placeholder = "Enter Genre Name"
        genreTextField.layer.borderWidth = 0
        genreTextField.layer.borderColor = UIColor.gray.cgColor
        }
    
    @IBAction func saveButton(_ sender: UIButton) {
        if(bookTextField.text == ""){
            bookTextField.placeholder = "Book Cannot be blank"
            bookTextField.becomeFirstResponder()
            bookTextField.layer.borderWidth = 2
            bookTextField.layer.borderColor = UIColor.red.cgColor
            }
        if(authorTextField.text == ""){
            authorTextField.placeholder = "Author Cannot be blank"
            authorTextField.becomeFirstResponder()
            authorTextField.layer.borderWidth = 2
            authorTextField.layer.borderColor = UIColor.red.cgColor
            }
        if(genreTextField.text == ""){
            genreTextField.placeholder = "Genre Cannot be blank"
            genreTextField.becomeFirstResponder()
            genreTextField.layer.borderWidth = 2
            genreTextField.layer.borderColor = UIColor.red.cgColor
            }
        }
    
    //MARK: -
    //MARK: All text field functions
    
    @IBAction func bookEditingChanged(_ sender: Any) {
        bookTextField.layer.borderWidth = 0
        bookTextField.layer.borderColor = UIColor.gray.cgColor
        }
    @IBAction func authorEditingChanged(_ sender: Any) {
        authorTextField.layer.borderWidth = 0
        authorTextField.layer.borderColor = UIColor.gray.cgColor
        }
    @IBAction func genreEditingChanged(_ sender: Any) {
        genreTextField.layer.borderWidth = 0
        genreTextField.layer.borderColor = UIColor.gray.cgColor
        filterArray(filterText: genreTextField.text!)
        genreTableView.reloadData()
        }
    @IBAction func genreEditingDidBegin(_ sender: Any) {
        genreTableView.isHidden = false
        genreArray = genreTempArray
        isGenre = true
        
        statusTextField.isHidden = true
        genreTableView.frame = CGRect.init(
            x:genreTextField.frame.origin.x,
            y:genreTextField.frame.origin.y + genreTextField.frame.height + 1,
            width: genreTextField.frame.width,
            height: 300)
        genreTableView.reloadData()
        genreTableView.isHidden = false
        }
    
    @IBAction func genreEditingDidEnd(_ sender: Any) {
        statusTextField.isHidden = false
        genreTableView.isHidden = false
             isGenre = false
             genreTableView.frame = CGRect.init(
             x:statusTextField.frame.origin.x,
             y:statusTextField.frame.origin.y + statusTextField.frame.height + 1,
             width: statusTextField.frame.width,
             height: 300)
             genreTempArray = genreArray
             genreArray = statusArray
             genreTableView.reloadData()
        }
    
    
    func filterArray(filterText:String){
        genreArray = genreArray.filter{
            genre in return genre.lowercased().contains(filterText.lowercased())
            }
        }
    
  
    //MARK: -
    //MARK: This is all about table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreArray.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell")
        cell?.textLabel?.text = genreArray[indexPath.row]
        return cell!
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isGenre){
            genreTextField.text = genreArray[indexPath.row]
        }
        else{
            statusTextField.text = genreArray[indexPath.row]
        }
        }
    
    }
