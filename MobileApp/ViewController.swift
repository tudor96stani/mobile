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

class ViewController: UIViewController {

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
        
        //Hide the back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    @IBAction func LoginBtnPress(_ sender: Any) {
        let parameters: Parameters = [
            "Username":UsernameField.text!,
            "Password":PasswordField.text!
        ]
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        Alamofire.request(Constans.LoginURL,method:.post,parameters:parameters)
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
//                    case 1:
//                        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewerViewController") as! ViewerViewController
//                        self.navigationController?.pushViewController(profileViewController, animated: true)
//                        self.dismiss(animated: false, completion: nil)
                    case 2:
                        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "OwnerListViewController") as! OwnerListViewController
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
