//
//  DetailsViewController.swift
//  MobileApp
//
//  Created by Tudor Stanila on 24/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var viewModel : BookDetailsViewModel! = nil
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var AuthorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        // Do any additional setup after loading the view.
        
        if viewModel != nil
        {
            TitleLabel.text = viewModel.BookTitleForDisplay()
            AuthorLabel.text = viewModel.BookAuthorForDisplay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func CancelButtonPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        guard let editBookViewController = unwindSegue.source as? EditBookViewController else{
            fatalError("Wrong source")
        }
        //let title = editBookViewController.viewModel.FindBookTitle()
        //let author = editBookViewController.viewModel.FindBookAuthor()
        //TitleLabel.text = title
        //AuthorLabel.text = author
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let controller = segue.destination as? EditBookViewController else
        {
            fatalError("Wrong destination")
        }
        controller.viewModel.SetBook(id: self.viewModel.book.Id,title:self.viewModel.book.Title,authorid:self.viewModel.book.AuthorId,bookauthor: self.viewModel.book.BookAuthor)
    }
 

}
