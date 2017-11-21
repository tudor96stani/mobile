//
//  RegisterViewController.swift
//  MobileApp
//
//  Created by Tudor Stanila on 24/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import UIKit
import MessageUI
class RegisterViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate {

    //MARK: Outlets
    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var RolePicker: UIPickerView!
    @IBOutlet weak var RoleLabel: UILabel!
    @IBOutlet weak var SuccessfullLabel: UILabel!
    
    
    @IBOutlet var viewModel: RegisterViewModel!
    let pickerData = ["Viewer","Owner"]
    let defaultValues = UserDefaults.standard
    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        RolePicker.dataSource=self
        RolePicker.delegate=self
        
        UsernameField.delegate=self
        EmailField.delegate=self
        PasswordField.delegate=self
        UsernameField.tag=0
        EmailField.tag=1
        PasswordField.tag=2
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
    
  
    //MARK: Methods
    func LoginAfterSuccessfulRegistration(user: User)-> Void{
        self.dismiss(animated: true, completion: nil)
        
        switch user.Role{
            //                    case 1:
            //                        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewerViewController") as! ViewerViewController
            //                        self.navigationController?.pushViewController(profileViewController, animated: true)
        //                        self.dismiss(animated: false, completion: nil)
        case 2:
            self.defaultValues.set(user.Id.uuidString,forKey:"userid")
            self.defaultValues.set(user.Username,forKey:"username")
            self.defaultValues.set(user.Role,forKey:"userrole")
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
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["tudor96stani@gmail.com"])
        mailComposerVC.setSubject("Registration for your application")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendEmail(to dest : String,role: Int, username: String) {
        self.dismiss(animated: true, completion: nil)
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([dest])
            let roleName = role == 1 ? "viewer" : "owner"
            mail.setSubject("Welcome to the BookManagement Society")
            mail.setMessageBody("<p>Welcome to the Book Management society! Your username is \(username) .You are now a \(roleName)</p>", isHTML: true)
            self.dismiss(animated: true, completion: nil)
            present(mail, animated: true)
        } else {
            self.DisplayAlert(message: "Could not create email!")
        }
    }
    
    //MARK: Actions
    
    @IBAction func RegisterPress(_ sender: Any) {
        if let username = UsernameField.text{
            if let password = PasswordField.text{
                let selectedRole = RolePicker.selectedRow(inComponent: 0) + 1
                viewModel.RegisterUser(username: username, password: password, role: selectedRole, completion: { (success) in
                    if success{
                        //Registration successful
                        self.UsernameField.isUserInteractionEnabled=false;
                        self.PasswordField.isUserInteractionEnabled = false;
                        self.EmailField.isUserInteractionEnabled=false;
                        self.RolePicker.isUserInteractionEnabled=false;
                        self.SuccessfullLabel.isHidden=false;
                        self.sendEmail(to: self.EmailField.text!, role: selectedRole,username: self.UsernameField.text!)
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
