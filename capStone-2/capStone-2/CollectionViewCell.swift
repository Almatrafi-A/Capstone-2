//
//  CollectionViewCell.swift
//  capStone-2
//
//  Created by Hessa on 14/02/1444 AH.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var cellLocation: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
