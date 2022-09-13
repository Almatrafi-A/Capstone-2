//
//  CustomCell.swift
//  MapAPI
//
//  Created by Faisal Almutairi on 15/02/1444 AH.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var views: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        views.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
