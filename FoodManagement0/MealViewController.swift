//
//  ViewController.swift
//  FoodManagement
//
//  Created by Cuong Tieu-Kim on 8/30/18.
//  Copyright © 2018 TDC. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Properties
    @IBOutlet weak var edtName: UITextField!
    @IBOutlet weak var mealPhoto: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    //var addmealMode = true
    
    var meal: Meal? // either new meal or meal to view detail
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        edtName.delegate = self
        // Update whether a meal is edited
        if let meal = self.meal {
            navigationItem.title = meal.name
            edtName.text = meal.name
            mealPhoto.image = meal.photo
            ratingControl.ratingValue = meal.rating
        }
        // Update save button's state
        updateSaveButtonState()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("Save is not pressed, Cancel is pressed", log: OSLog.default, type: .debug)
            return
        }
        let name = edtName.text ?? ""
        let photo = mealPhoto.image
        let rating = ratingControl.ratingValue
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    @IBAction func cancelNewMeal(_ sender: UIBarButtonItem) {
        // Check the mode of screen presenting
        let modeOfAddMealPresenting = presentingViewController is UINavigationController
        if modeOfAddMealPresenting {
            dismiss(animated: true, completion: nil)
        }
        else if let unWindController = navigationController {
            unWindController.popViewController(animated: true)
        }
        else {
            fatalError("This controller is not inside a Navigation controller")
        }
    }
    
    //MARK: Definition of my Actions
    @IBAction func tapRecognizerForImage(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard
        edtName.resignFirstResponder()
        // Using ImagePickerController
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Definition of TextFieldDelegete
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Hide the keyboard
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //lblName.text = textField.text
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    //MARK: Definition of Actions from Image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //print("Cancel called")
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print("Picked image called")
        guard let imageChosen = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Do not get the Image in \(info)")
        }
        // Set the Image picked to the ImageView
        mealPhoto.image = imageChosen
        // Hide the Picker
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Private methods
    private func updateSaveButtonState(){
        let edtName = self.edtName.text ?? ""
        saveButton.isEnabled = !edtName.isEmpty
    }
}

