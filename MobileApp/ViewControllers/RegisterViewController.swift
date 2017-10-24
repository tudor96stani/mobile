//
//  RegisterViewController.swift
//  MobileApp
//
//  Created by Tudor Stanila on 24/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    //MARK: Outlets
    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var RolePicker: UIPickerView!
    @IBOutlet weak var RoleLabel: UILabel!
    
    
    @IBOutlet var viewModel: RegisterViewModel!
    let pickerData = ["Viewer","Owner"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RolePicker.dataSource=self
        RolePicker.delegate=self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_
        pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int
        ) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
  
    func LoginAfterSuccessfulRegistration(user: User)-> Void{
        switch user.Role{
            //                    case 1:
            //                        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewerViewController") as! ViewerViewController
            //                        self.navigationController?.pushViewController(profileViewController, animated: true)
        //                        self.dismiss(animated: false, completion: nil)
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
    }
  
    
    func DisplayAlert(message text: String) -> Void
    {
        let alertController = UIAlertController(title: "Register", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Actions
    
    @IBAction func RegisterPress(_ sender: Any) {
        if let username = UsernameField.text{
            if let password = PasswordField.text{
                let selectedRole = RolePicker.selectedRow(inComponent: 0) + 1
                viewModel.RegisterUser(username: username, password: password, role: selectedRole, completion: { (success) in
                    if success{
                        //Registration successful
                        self.LoginAfterSuccessfulRegistration(user: self.viewModel.user!)
                    }else{
                        self.DisplayAlert(message: self.viewModel.errorMessage!)
                    }
                })
                
            }else{
                DisplayAlert(message: "Password cannot be empty!")
            }
        }
        else{
            DisplayAlert(message: "Username cannot be empty!")
        }
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
