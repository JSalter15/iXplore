//
//  SpotTableViewCell.swift
//  iXplore
//
//  Created by Joe Salter on 6/8/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class SpotTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func starTouched(sender: UIButton) {
        if sender == star1 {
            star1.setImage(UIImage(named: "star_pink"), forState: .Normal)
            star2.setImage(UIImage(named: "star_black"), forState: .Normal)
            star3.setImage(UIImage(named: "star_black"), forState: .Normal)
            star4.setImage(UIImage(named: "star_black"), forState: .Normal)
        }
        else if sender == star2 {
            star1.setImage(UIImage(named: "star_pink"), forState: .Normal)
            star2.setImage(UIImage(named: "star_pink"), forState: .Normal)
            star3.setImage(UIImage(named: "star_black"), forState: .Normal)
            star4.setImage(UIImage(named: "star_black"), forState: .Normal)
        }
        else if sender == star3 {
            star1.setImage(UIImage(named: "star_pink"), forState: .Normal)
            star2.setImage(UIImage(named: "star_pink"), forState: .Normal)
            star3.setImage(UIImage(named: "star_pink"), forState: .Normal)
            star4.setImage(UIImage(named: "star_black"), forState: .Normal)
        }
        else if sender == star4 {
            star1.setImage(UIImage(named: "star_pink"), forState: .Normal)
            star2.setImage(UIImage(named: "star_pink"), forState: .Normal)
            star3.setImage(UIImage(named: "star_pink"), forState: .Normal)
            star4.setImage(UIImage(named: "star_pink"), forState: .Normal)
        }
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
