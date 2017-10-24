//
//  ViewController.swift
//  MobileApp
//
//  Created by Tudor Stanila on 22/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    
    //MARK: Fields
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let defaultValues = UserDefaults.standard
    
    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UsernameField.delegate=self
        PasswordField.delegate=self
        UsernameField.tag=0
        PasswordField.tag=1
        
        //Hide the back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        PasswordField.text=""

    }
    
    override func viewDidAppear(_ animated: Bool) {
        PasswordField.text=""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    //MARK: Actions
    
    @IBAction func RegisterBtnPress(_ sender: Any) {
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func LoginBtnPress(_ sender: Any) {
        let parameters: Parameters = [
            "Username":UsernameField.text!,
            "Password":PasswordField.text!
        ]
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        Alamofire.request(Constants.LoginURL,method:.post,parameters:parameters)
            .validate()
            .responseJSON { response in
                
                switch response.result
                {
                case .success(let value):
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    let json = JSON(value)
                    let user = User(Id: UUID(uuidString:json["Id"].stringValue)!,Username:json["Username"].stringValue,Role:json["Role"].int!)
                    self.defaultValues.set(user.Id.uuidString,forKey:"userid")
                    self.defaultValues.set(user.Username,forKey:"username")
                    self.defaultValues.set(user.Role,forKey:"userrole")
                    switch user.Role{
                    case 1:
                        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "BooksTableViewController") as! BooksTableViewController
                        self.navigationController?.pushViewController(profileViewController, animated: true)
                        self.dismiss(animated: false, completion: nil)
                    case 2:
                        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "BooksTableViewController") as! BooksTableViewController
                        self.navigationController?.pushViewController(profileViewController, animated: true)
                        self.dismiss(animated: false, completion: nil)
                    default:
                        //Undefined role -> not acceptable
                        let alertController = UIAlertController(title: "Login", message:
                            "There was an error!", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                case .failure( _):
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if let httpStatusCode = response.response?.statusCode {
                        switch (httpStatusCode){
                        case 401:
                            let alertController = UIAlertController(title: "Login", message:
                                "Wrong username or password!", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        default:
                            let alertController = UIAlertController(title: "Login", message:
                                "There was an error!", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }else{
                        let alertController = UIAlertController(title: "Login", message:
                            "Could not connect!", preferredStyle: UIAlertControllerStyle.alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                }
        }
        
        
        
    }
}
