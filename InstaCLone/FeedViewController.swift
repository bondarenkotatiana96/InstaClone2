//
//  FeedViewController.swift
//  InstaCLone
//
//  Created by Tatiana Bondarenko on 2/20/23.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIds = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirestore()
    }

    func getDataFromFirestore() {
        let firestoreDatabase = Firestore.firestore()
//        let settings = firestoreDatabase.settings

        firestoreDatabase.collection("posts")
            .order(by: "date", descending: true)
            .addSnapshotListener { snapshot, error in
            if error != nil {
                print(error ?? "Error")
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userEmailArray.removeAll()
                    self.userCommentArray.removeAll()
                    self.likeArray.removeAll()
                    self.userImageArray.removeAll()
                    self.documentIds.removeAll()
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIds.append(documentID)
                        print(documentID)
                        
                        if let userName = document.get("postedBy") as? String {
                            self.userEmailArray.append(userName)
                        }

                        if let comment = document.get("comment") as? String {
                            self.userCommentArray.append(comment)
                        }

                        if let like = document.get("likes") as? Int {
                            self.likeArray.append(like)
                        }

                        if let imageURL = document.get("image") as? String {
                            self.userImageArray.append(imageURL)
                        }
                    }

                    self.tableView.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        cell.userLabel.text = userEmailArray[indexPath.row]
        cell.likesCount.text = "\(likeArray[indexPath.row])"
        cell.comment.text = userCommentArray[indexPath.row]
        // TODO: download image from the image URL and then set image to image view
//        cell.instaImage.image = UIImage(name: userImageArray[indexPath.row])
        cell.documentIdLabel.text = documentIds[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }

}
