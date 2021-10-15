//
//  ViewControllerEbook.swift
//  Eduky
//
//  Created by Juan Pablo Enriquez  on 14/07/19.
//  Copyright © 2019 Juan Pablo Enriquez . All rights reserved.
//

import UIKit
import Firebase

class ViewControllerEbook: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var collectionViewEbook: UICollectionView!
    
    @IBOutlet weak var searchEbook: UISearchBar!
    
    var ebookList:[Ebook]  = [Ebook]()
    var actualEbookList:[Ebook]  = [Ebook]()
    
    var urlWeb: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()
        
        collectionViewEbook.dataSource = self
        collectionViewEbook.delegate = self

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Ebooks"
        
        ebookList = [Ebook]()
        
        (UIApplication.shared.delegate as! AppDelegate).fireBaseRef.child("Libros").child("Categorias").observe(.value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0 {
                
                self.ebookList.removeAll()
                
                for ebooks in snapchot.children.allObjects as! [DataSnapshot]{
                    
                    let ebookObject = ebooks.value as? [String: AnyObject]
                    let LibroImagen = ebookObject?["imagenLibro"]
                    let LibroNombre = ebookObject?["nombreLibro"]
                    let urlLibro = ebookObject?["urlLibro"]
                    
                    let ebook = Ebook(imagenLibro: LibroImagen as! String, nombreLibro: LibroNombre as! String, urlLibro: urlLibro as! String)
                    
                    self.ebookList.append(ebook)
                    
                    self.actualEbookList = self.ebookList.shuffled()
                }
            }
            
            self.collectionViewEbook.reloadData()
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actualEbookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "vistaPdf", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellEbook", for: indexPath) as! CollectionViewCellEbook
        
        let eachEbook = actualEbookList[indexPath.row]
        
        cell.ebookLabel.text = eachEbook.nombreLibro
        
            let url = NSURL(string: eachEbook.imagenLibro)
            URLSession.shared.dataTask(with: url as! URL, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error)
                    return
                }
                
                cell.ebookImage.image = UIImage(data: data!)
                
            }).resume()
        
        urlWeb = eachEbook.urlLibro
            
        return cell
        
    }
    
    private func setUpSearchBar(){
        searchEbook.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        guard !searchText.isEmpty else {
            self.actualEbookList = self.ebookList
            self.collectionViewEbook.reloadData()
            return
        }
        
        actualEbookList = ebookList.filter({ (ebook) -> Bool in
            ebook.nombreLibro.lowercased().contains(searchText.lowercased())
        })
        
        self.collectionViewEbook.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "vistaPdf"{
            let pdf = segue.destination as! ViewControllerPdf
            pdf.urlWeb = urlWeb
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



