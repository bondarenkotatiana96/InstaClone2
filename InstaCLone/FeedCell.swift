//
//  FeedCell.swift
//  InstaCLone
//
//  Created by Tatiana Bondarenko on 2/22/23.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!

    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var comment: UILabel!

    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var instaImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeClicked(_ sender: Any) {
        print("Like button clicked")
        let firestoreDatabase = Firestore.firestore()

        if let likeCount = Int(likesCount.text!) {
            let likeStore = ["likes": likeCount+1] as [String: Any]
            firestoreDatabase.collection("posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
        }
    }
}
