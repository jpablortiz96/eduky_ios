//
//  CollectionViewCellEbook.swift
//  Eduky
//
//  Created by Juan Pablo Enriquez  on 14/07/19.
//  Copyright © 2019 Juan Pablo Enriquez . All rights reserved.
//

import UIKit

class CollectionViewCellEbook: UICollectionViewCell {
    
    @IBOutlet weak var ebookImage: UIImageView!
    @IBOutlet weak var ebookLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ebookImage.image = nil
    }

}
