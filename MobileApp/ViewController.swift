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
import KeychainSwift
class ViewController: UIViewController,UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet var viewModel : LoginViewModel!
    @IBOutlet weak var LoginButtonOutlet: UIButton!
    @IBOutlet weak var RegisterButtonOutlet: UIButton!
    
    //MARK: Fields
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let defaultValues = UserDefaults.standard
    let keychain = KeychainSwift()
    
    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Some design things
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent=true;
        self.navigationController?.view.backgroundColor = .clear
        LoginButtonOutlet.backgroundColor = .clear
        LoginButtonOutlet.layer.cornerRadius = 5
        LoginButtonOutlet.layer.borderWidth = 1
        LoginButtonOutlet.layer.borderColor = UIColor.clear.cgColor
        
        PasswordField.text=""
        
        //UsernameField.setBottomBorder()
        //PasswordField.setBottomBorder()
        UsernameField.backgroundColor = .clear
        PasswordField.backgroundColor = .clear
        
        //Preparing textfields to respond to the "Return" button
        UsernameField.delegate=self
        PasswordField.delegate=self
        UsernameField.tag=0
        PasswordField.tag=1
        
        //Hide the back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        PasswordField.text=""
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Methods
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
    
    func DisplayAlert(message text: String) -> Void
    {
        let alertController = UIAlertController(title: "Login", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func Login(username: String,password: String){
        self.view.endEditing(true)
        self.viewModel.Login(username: username, password: password) { (success) in
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if success{
                
                switch self.viewModel.user!.Role{
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
                    self.DisplayAlert(message: "There was an error!")
                }
            } else {
                self.DisplayAlert(message: self.viewModel.errorMessage!)
            }
        }
    }
    
    //MARK: Actions
    
    @IBAction func RegisterBtnPress(_ sender: Any) {
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerViewController, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func LoginBtnPress(_ sender: Any) {
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        if let username = UsernameField.text{
            if let password = PasswordField.text{
                Login(username:username,password:password)
            }else{
                DisplayAlert(message: "Please enter a password!")
            }
        }else{
            DisplayAlert(message: "Please enter a username!")
        }
        //Login(username:UsernameField.text!,password:PasswordField.text!)
    }
}
