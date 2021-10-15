//
//  Educador.swift
//  Eduky
//
//  Created by Juan Pablo Enriquez  on 15/06/19.
//  Copyright © 2019 Juan Pablo Enriquez . All rights reserved.
//

import Foundation

class Educador {
    
    var correoPro: String
    var imagenPro: String?
    var nomPro: String
    var celPro: String
    var asigPro: String
    var contraPro: String
    var ocupaPro: String
    var edadPro: String
    var apePro: String
    var latitudPro: String
    var longitudPro: String
    var descriPro: String
    
    init(apePro:String, asigPro:String, celPro:String, contraPro:String, correoPro:String, descriPro:String, edadPro:String, imagenPro:String, latitudPro:String, longitudPro:String, nomPro:String, ocupaPro:String) {
        
        self.apePro = apePro
        self.asigPro = asigPro
        self.celPro = celPro
        self.contraPro = contraPro
        self.correoPro = correoPro
        self.descriPro = descriPro
        self.edadPro = edadPro
        self.imagenPro = imagenPro
        self.latitudPro = latitudPro
        self.longitudPro = longitudPro
        self.nomPro = nomPro
        self.ocupaPro = ocupaPro
        
    }
    
    
}
