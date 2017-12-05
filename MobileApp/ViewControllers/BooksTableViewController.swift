//
//  BooksTableViewController.swift
//  MobileApp
//
//  Created by Tudor Stanila on 22/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import UIKit
import KeychainSwift
class BooksTableViewController: UITableViewController {

    @IBOutlet var viewModel: BookListViewModel!
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Design
        let backgroundImage = UIImage(named: "table_background.png")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        tableView.tableFooterView = UIView()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        
        //Refresh data setup
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        //hide back button
        let backButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(Logout(sender:)))
        navigationItem.leftBarButtonItem = backButton
        
        //Call the GetBooks method of the viewmodel with the completionHandler that reloads the table data
        viewModel.GetBooks(UserId: UUID(uuidString:UserDefaults.standard.string(forKey:"userid")!)!) {
            self.tableView.reloadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ReloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.NumberOfItemsToDisplay(in: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTableViewCell

        // Configure the cell...
        cell.TitleLabel?.text=viewModel.BookTitleToDisplay(for: indexPath)
        cell.AuthorLabel?.text=viewModel.BookAuthorIdToDisplay(for: indexPath)
        cell.backgroundColor = .clear
        return cell
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.viewModel.DeleteBook(for: indexPath){ok in
                print(ok)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    //MARK: Methods
    @objc func Logout(sender: UIBarButtonItem) {
        self.keychain.delete("token")
        self.keychain.delete("username")
        self.keychain.delete("password")
        UserDefaults.standard.removeObject(forKey:"userid")
        UserDefaults.standard.removeObject(forKey:"Role")
        if (self.navigationController?.popViewController(animated: true)) != nil{
            
        }
        else{
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let ViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let nav = UINavigationController(rootViewController: ViewController)
            appdelegate.window!.rootViewController = nav
        }
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl){
        ReloadData()
        refreshControl.endRefreshing()
    }
    
    func ReloadData(){
        viewModel.GetBooks(UserId: UUID(uuidString:UserDefaults.standard.string(forKey:UserDefaults.Keys.UserId)!)!) {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for:segue,sender:sender)
        
        guard let navigationViewController = segue.destination as? UINavigationController
            else{
                fatalError("Unexpected destination")
            }
        if let detailViewController = navigationViewController.topViewController as? DetailsViewController {
            guard let selectedBook = sender as? BookTableViewCell
                else{
                fatalError("Unexpected sender")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedBook) else{
                fatalError("The selected cell is not displayed by the table")
            }
            
            if let selectedBookViewModel = viewModel.FindBookDetailsViewModel(for: indexPath){
                detailViewController.viewModel = selectedBookViewModel
            }
            else{
                fatalError("Could not create view model for selected item")
            }
        }
    }
}
 


