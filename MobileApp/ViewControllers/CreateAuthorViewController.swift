//
//  CreateAuthorViewController.swift
//  MobileApp
//
//  Created by Tudor Stanila on 29/12/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import UIKit

class CreateAuthorViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet var viewModel:CreateAuthorViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelButtonPress(_ sender: Any) {
        self.dismiss(animated: true,completion:nil)
    }
    
    
    @IBAction func saveButtonPress(_ sender: Any) {
        let fname = firstNameTextField.text!
        let lname = lastNameTextField.text!
        
        viewModel.CreateAuthor(firstName: fname, lastName: lname) { (ok) in
            /*
            if ok{
                self.dismiss(animated: true, completion: nil)
                self.DisplayAlert(message: "\(fname) \(lname) successfully added to library.")
            }else{
                self.DisplayAlert(message: "\(self.viewModel.message!).")
                self.dismiss(animated: true, completion: nil)
            }
            */
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func DisplayAlert(message text: String) -> Void
    {
        let alertController = UIAlertController(title: "Create author", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
