//
//  ViewControllerTableViewCell.swift
//  Eduky
//
//  Created by Juan Pablo Enriquez  on 22/06/19.
//  Copyright © 2019 Juan Pablo Enriquez . All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var imagenPerfil: UIImageView!
    @IBOutlet weak var profesion: UILabel!
    @IBOutlet weak var asignaturas: UILabel!
    @IBOutlet weak var direccion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
