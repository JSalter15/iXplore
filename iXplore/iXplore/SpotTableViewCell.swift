//
//  SpotTableViewCell.swift
//  iXplore
//
//  Created by Joe Salter on 6/8/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class SpotTableViewCell: UITableViewCell {
  
    var cellImage: UIImageView!
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        cellImage = UIImageView(frame: CGRectMake(0, 0, 88, 88))
        titleLabel = UILabel(frame: CGRectMake(96, 18, 221, 27))
        dateLabel = UILabel(frame: CGRectMake(96, 46, 221, 27))
        
        super.init(style: .Default, reuseIdentifier: "spotTableViewCell")
        
        self.addSubview(cellImage)
        self.addSubview(titleLabel)
        self.addSubview(dateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
