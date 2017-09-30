//
//  ViewController.swift
//  meme1
//
//  Created by Hamed.Gh on 9/29/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
UITextFieldDelegate,
UIBarPositioningDelegate{
    
    @IBOutlet var topText: UITextField!
    @IBOutlet var bottomText: UITextField!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var pickButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var imagePickerView: UIImageView!
    
    var empty:Bool = true
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = image
            topText.isEnabled = true
            bottomText.isEnabled = true
            pickButton.isEnabled = false
            cameraButton.isEnabled  = false
        }
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func share(_ sender: Any) {
        
    }
    
    @IBAction func pickImageFromPhotoLibrary(_ sender: Any) {
        pickImage(sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickImage(sourceType: UIImagePickerControllerSourceType.camera)
    }
    
    func pickImage(sourceType:UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topText.delegate = self
        bottomText.delegate = self

        clear()
    }
    
    @IBAction func cancel(_ sender: Any) {
        clear()
    }
    
    func clear() {

        imagePickerView.image = nil
        
        bottomText.text = "BOTTOM"
        bottomText.isEnabled = false
        
        topText.text = "TOP"
        topText.isEnabled = false
        
        pickButton.isEnabled = true
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        shareButton.isEnabled = false
        cancelButton.isEnabled = false
        
        empty = true
    }
    
}

