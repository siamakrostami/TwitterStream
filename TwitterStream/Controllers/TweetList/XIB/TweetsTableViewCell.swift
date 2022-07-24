//
//  TweetsTableViewCell.swift
//  SRSnappAssignment
//
//  Created by Siamak Rostami on 5/20/22.
//

import UIKit
import ActiveLabel

class TweetsTableViewCell: UITableViewCell {
    
    static let identifier = "TweetsTableViewCell"
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: ActiveLabel!{
        didSet{
            tweetTextLabel.enabledTypes = [.mention,.hashtag,.url]
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    //set data from model to cell
    func setCellData(model : TweetObject){
        guard let data = model.data else {return}
        DispatchQueue.main.async {
            self.usernameLabel.text = "@\(model.includes?.users?.first?.username ?? "Username")"
            self.tweetTextLabel.text = data.text
        }
        
    }
    
}
