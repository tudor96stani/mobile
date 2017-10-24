//
//  EditBookViewController.swift
//  MobileApp
//
//  Created by Tudor Stanila on 24/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import UIKit

class EditBookViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
   

    //MARK: Outlets
    @IBOutlet weak var TitleField: UITextField!
    @IBOutlet weak var AuthorPicker: UIPickerView!
    @IBOutlet var viewModel: BookEditViewModel!
    var dataSource: [(key: UUID, value: String)] = []
      
    override  func viewDidLoad() {
        super.viewDidLoad()
        AuthorPicker.dataSource=self
        AuthorPicker.delegate=self
        
        
            viewModel.FindAuthors(){
                self.dataSource = self.viewModel.GetAuthorDataForPicker()
                self.AuthorPicker.reloadAllComponents()
            }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func SaveBtnPress(_ sender: Any) {
        //Try to save the data here
        viewModel.UpdateBook(title: TitleField.text!, authorId: dataSource[AuthorPicker.selectedRow(inComponent: 0)].key) {
            if !self.viewModel.BookIsDefined(){
                let alertController = UIAlertController(title: "Edit", message:
                    "There was an error!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        viewModel.UpdateBook(title: TitleField.text!, authorId: dataSource[AuthorPicker.selectedRow(inComponent: 0)].key) {
            if !self.viewModel.BookIsDefined(){
                let alertController = UIAlertController(title: "Edit", message:
                    "There was an error!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            guard let controller = segue.destination as? DetailsViewController else
            {
                fatalError("Wrong destination")
                
            }
            controller.TitleLabel.text=self.TitleField.text!
            controller.AuthorLabel.text = self.dataSource[self.AuthorPicker.selectedRow(inComponent: 0)].value
            
        }
    }
    

}
