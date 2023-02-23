//
//  UploadViewController.swift
//  InstaCLone
//
//  Created by Tatiana Bondarenko on 2/20/23.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognixer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognixer)
    }

    @objc func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            self.imageView.image = info[.originalImage] as? UIImage
        }

        self.dismiss(animated: true)
    }

    func makeAlert() {
        let alert = UIAlertController(title: "Error", message: "Could not upload photo", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }


    @IBAction func uploadButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()

        let mediaFolder = storageReference.child("media")
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let mediaReference = mediaFolder.child("\(uuid).jpeg")
            mediaReference.putData(data) { metadata, error in
                if error != nil {
                    self.makeAlert()
                } else {
                    mediaReference.downloadURL { url, error in
                        if error == nil {
                            let imageURL = url?.absoluteString

                            // DATABASE
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference: DocumentReference? = nil
                            /// TODO: handle force unwrapping
                            let firestorePost = ["imageURL": imageURL!, "postedBy": Auth.auth().currentUser!.email!, "comment": self.textField.text!, "date": FieldValue.serverTimestamp(), "likes": 0] as [String: Any]
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    self.makeAlert()
                                } else {
                                    self.imageView.image = UIImage(systemName: "person")
                                    self.textField.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })

                        }
                    }
                }
            }
        }
    }

}
