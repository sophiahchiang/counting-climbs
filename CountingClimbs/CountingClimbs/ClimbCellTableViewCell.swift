//
//  ClimbCellTableViewCell.swift
//  CountingClimbs
//
//  Created by Sophia Chiang on 3/31/23.
//

import UIKit

class ClimbCellTableViewCell: UITableViewCell {

    @IBOutlet weak var climbDescLabel: UILabel!
    @IBOutlet weak var climbNameLabel: UILabel!
    @IBOutlet weak var climbImageView: UIImageView!
    
    var climb: Climb? {
        didSet {
            self.climbNameLabel.text = climb?.name
            self.climbDescLabel.text = climb?.grade
            self.accessoryType = climb!.isFinished ? .checkmark : .none
            
            DispatchQueue.global(qos: .userInitiated).async {
                let climbImageData = NSData(contentsOf: URL(string: self.climb!.imageUrl)!)
                DispatchQueue.main.async {
                    self.climbImageView.image = UIImage(data:climbImageData as! Data)
//  Rounded image corners                  self.climbImageView.layer.cornerRadius = self.climbImageView.frame.width / 2
                }
            }
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

}
