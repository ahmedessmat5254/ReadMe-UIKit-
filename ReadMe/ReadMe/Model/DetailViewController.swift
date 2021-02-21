//
//  DetailViewController.swift
//  ReadMe
//
//  Created by Ahmed Essmat on 15/02/2021.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var book: Book
    
    @IBOutlet var titleLable: UILabel!
    @IBOutlet var authorLable: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var reviewTextView : UITextView!

    

    
    @IBOutlet var readMeBtn: UIButton!
    @IBAction func toggleReadMe() {
        book.readMe.toggle()
        let image = book.readMe
            ? LibrarySymbol.bookmarkFill.image
            : LibrarySymbol.bookmark.image
        readMeBtn.setImage(image, for: .normal)
    }
    
    @IBAction func saveChanges() {
        Library.update(book: book)
        navigationController?.popViewController(animated: true)
    }
    
   
    
    @IBAction func updateImgae() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate  = self
        imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        imagePicker.isEditing = true
        present(imagePicker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = book.image ?? LibrarySymbol.letterSquare(letter: book.title.first).image
        imageView.layer.cornerRadius = 16
        titleLable.text = book.title
        authorLable.text = book.author
        
        if let review = book.review {
            reviewTextView.text = review
        }
        let image = book.readMe ? LibrarySymbol.bookmarkFill.image : LibrarySymbol.bookmark.image
        readMeBtn.setImage(image, for: .focused)
        reviewTextView.addDoneButton()
    }
    
    required init?(coder: NSCoder) {fatalError("This should never be called!")}
    
    init?(coder: NSCoder, book: Book) {
        self.book = book
        super.init(coder: coder)
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectImage = info[.originalImage] as? UIImage else {return}
        imageView.image = selectImage
        book.image = selectImage
        dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        book.review = textView.text
        textView.resignFirstResponder()
    }
}

extension UITextView {
    func addDoneButton(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.resignFirstResponder))
        toolbar.items = [flexSpace, doneButton]
        self.inputAccessoryView = toolbar
    }
}
