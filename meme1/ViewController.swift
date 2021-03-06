//
//  ViewController.swift
//  meme1
//
//  Created by Hamed.Gh on 9/29/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
UITextFieldDelegate,
UIBarPositioningDelegate{
    
    @IBOutlet var topText: UITextField!
    @IBOutlet var bottomText: UITextField!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
//    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet var pickButton: UIBarButtonItem!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var imagePickerView: UIImageView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var topCaptionConstrant: NSLayoutConstraint!
    @IBOutlet var bottomCaptionConstraint: NSLayoutConstraint!
    
    var empty:Bool = true
    
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSAttributedStringKey.strokeWidth.rawValue: -4.0]
    
    //Setup Text Field Text Attributes
    func configure(textField:UITextField, withText: String){
        textField.delegate = self
        textField.text = withText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    @IBAction func saveImage(_ sender: Any) {
        let memedImage = generateMemedImage()
        self.save(memedImage: memedImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        //MARK:cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y =  -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func topTextEditingChanged(_ sender: Any) {
        
        topText.text = topText.text?.uppercased()
        
        if (bottomText.text?.characters.count)!>0 && (imagePickerView.image != nil)
        {
            shareButton.isEnabled = true
        }
        else{
            shareButton.isEnabled = false
        }
    }
    
    @IBAction func bottomTextEditingChanged(_ sender: Any) {
        
        bottomText.text = bottomText.text?.uppercased()
        
        if (bottomText.text?.characters.count)!>0 && (imagePickerView.image != nil)
        {
            shareButton.isEnabled = true
        }
        else{
            shareButton.isEnabled = false
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = image
            
            topText.isEnabled = true
            bottomText.isEnabled = true
            pickButton.isEnabled = false
            cameraButton.isEnabled  = false
            
//            cancelButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func generateMemedImage() -> UIImage {
        
        toolbar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolbar.isHidden = false
        return memedImage
    }

    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topCaption: topText.text!, bottomCaption: bottomText.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        //Appending meme to the array of meme
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        // setting up dismissal of the activity view once the meme is successfully shared:
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if (success) {
                self.save(memedImage: memedImage)
                self.dismiss(animated: true, completion: nil)
                self.clear()
            }
        }
        present(activityViewController, animated: true, completion: nil)
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
        
        clear()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func clear() {

        imagePickerView.image = nil
        
        configure(textField: bottomText, withText: "BOTTOM")
        bottomText.isEnabled = false
        
        configure(textField: topText, withText: "TOP")
        topText.isEnabled = false
        
        pickButton.isEnabled = true
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        shareButton.isEnabled = false
//        cancelButton.isEnabled = false
        
        empty = true
    }
    
}

