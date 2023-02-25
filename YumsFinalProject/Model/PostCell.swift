//
//  PostCell.swift
//  YumsFinalProject
//
//  Created by Bereket Kibret on 12/5/22.
//

import Foundation
import UIKit

// Cell for each food spot object
class PostCell: UICollectionViewCell{
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pTitle: UILabel!
    @IBOutlet weak var pAuthor: UILabel!
    
    override func awakeFromNib() {
        background.layer.cornerRadius = 12
        image.layer.cornerRadius = 12

    }
}

