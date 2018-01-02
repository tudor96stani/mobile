//
//  CreateBookViewController.swift
//  MobileApp
//
//  Created by Tudor Stanila on 21/11/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import UIKit

class CreateBookViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: Outlets and fields
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorPicker: UIPickerView!
    var dataSource: [(key: UUID, value: String)] = []
    @IBOutlet var viewModel : CreateBookViewModel!
    
    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        authorPicker.dataSource=self
        authorPicker.delegate=self
        viewModel.FindAuthors(){
            self.dataSource = self.viewModel.GetAuthorDataForPicker()
            self.authorPicker.reloadAllComponents()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.FindAuthors(){
            self.dataSource = self.viewModel.GetAuthorDataForPicker()
            self.authorPicker.reloadAllComponents()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataSource[row].value
    }
    
    //MARK: Methods
    func DisplayAlert(message text: String) -> Void
    {
        let alertController = UIAlertController(title: "Create book", message:
            text, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Button actions
    @IBAction func saveButtonClick(_ sender: Any) {
        let title = self.titleField.text!
        let authorid = dataSource[authorPicker.selectedRow(inComponent: 0)].key
        viewModel.Create(title: title, authorid: authorid) { (success) in
            if success{
                self.dismiss(animated: true, completion: nil)
                //self.DisplayAlert(message: "\(title) successfully added to library")
                NotificationClient.Send(title: "Your book has been added", body: "\(title) has been successfully added to your library", badge: 1, timeInt: 5, identifier: "addBook")
            }else{
                self.DisplayAlert(message: "\(self.viewModel.message!)")
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Close", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        present(refreshAlert, animated: true, completion: nil)
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
