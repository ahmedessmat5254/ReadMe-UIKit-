//
//  NewBookViewController.swift
//  ReadMe
//
//  Created by Ahmed Essmat on 21/02/2021.
//

import UIKit

class NewBookViewController: UITableViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var authorTextField: UITextField!
    @IBOutlet var bookImageView: UIImageView!
    
    var newBookImage: UIImage?
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func saveNewBook() {
        guard let title = titleTextField.text, let author = authorTextField.text , !title.isEmpty, !author.isEmpty else { return }
        Library.addNew(book: Book(title: title, author: author, readMe: false, image: newBookImage))
        navigationController?.popViewController(animated: true)
    }
    
 
    @IBAction func updateImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera)
            ?.camera : .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        bookImageView.layer.cornerRadius = 16
    }
}
extension NewBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectImage = info[.originalImage] as? UIImage else {return}
        bookImageView.image = selectImage
        newBookImage = selectImage
        dismiss(animated: true, completion: nil)
    }
}

extension NewBookViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            return authorTextField.becomeFirstResponder()
        }
        return textField.resignFirstResponder()
    }
}
