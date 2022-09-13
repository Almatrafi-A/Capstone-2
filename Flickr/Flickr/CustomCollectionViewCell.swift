//
//  CustomCollectionViewCell.swift
//  Flickr
//
//  Created by NosaibahMW on 15/02/1444 AH.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var myImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myImage.layer.cornerRadius = 5
    }

}
