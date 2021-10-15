//
//  TableViewController.swift
//  Pods
//
//  Created by Juan Pablo Enriquez  on 1/06/19.
//
//

import UIKit
import Firebase
import CoreLocation


class TableViewController: UITableViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var educaList:[Educador]  = [Educador]()
    var actualEducaList:[Educador]  = [Educador]()
    
    var nombre: String = ""
    var apellido: String = ""
    var asignaturas: String = ""
    var descripcion: String = ""
    var celular: String = ""
    var correo: String = ""
    var edad: String = ""
    var imagen: String = ""
    var latitud_gen: String = ""
    var longitud_gen: String = ""
    var ocupacion: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.title = "Educadores"
        
        
        educaList = [Educador]()
        
        (UIApplication.shared.delegate as! AppDelegate).fireBaseRef.child("Profesores").child("Informacion").observe(.value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0 {
                
                self.educaList.removeAll()
                
                for educadores in snapchot.children.allObjects as! [DataSnapshot] {
                    
                    let educaObject = educadores.value as? [String: AnyObject]
                    let educaApe = educaObject?["apePro"]
                    let educaaAsig = educaObject?["asigPro"]
                    let educaCel = educaObject?["celPro"]
                    let educaContra = educaObject?["contraPro"]
                    let educaCorreo = educaObject?["correoPro"]
                    let educaDescri = educaObject?["descriPro"]
                    let educaEdad = educaObject?["edadPro"]
                    let educaImagen = educaObject?["imagenPro"]
                    let educaLat = educaObject?["latitudPro"]
                    let educaLon = educaObject?["longitudPro"]
                    let educaNom = educaObject?["nomPro"]
                    let educaOcupa = educaObject?["ocupaPro"]
                    
                    let educador = Educador(apePro: educaApe as! String, asigPro: educaaAsig as! String, celPro: educaCel as! String, contraPro: educaContra as! String,correoPro: educaCorreo as! String, descriPro: educaDescri as! String, edadPro: educaEdad as! String, imagenPro: educaImagen as! String, latitudPro: educaLat as! String, longitudPro: educaLon as! String, nomPro: educaNom as! String, ocupaPro: educaOcupa as! String)

                    self.educaList.append(educador)
                    
                    self.actualEducaList = self.educaList.shuffled()
                }
            }
            self.tableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return actualEducaList.count;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueFromTable", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Trick to get static variable in Swift
        struct staticVariable { static var tableIdentifier = "TableIdentifier" }
        
        let cell = tableView.dequeueReusableCell( withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        let eachEdu = actualEducaList[indexPath.row]
        
        cell.nombre.text = eachEdu.nomPro + " " + eachEdu.apePro
        cell.profesion.text = eachEdu.ocupaPro
        cell.asignaturas.text = eachEdu.asigPro
        
        if let imagenPro = eachEdu.imagenPro {
            let url = NSURL(string: imagenPro)
            URLSession.shared.dataTask(with: url as! URL, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error)
                    return
                }
                
                cell.imagenPerfil.image = UIImage(data: data!)
                
            }).resume()

        }
        
        let latitud = (eachEdu.latitudPro as NSString).doubleValue
        let longitud = (eachEdu.longitudPro as NSString).doubleValue
        
        let location = CLLocation(latitude: latitud, longitude: longitud)
        location.geocode(completion: { placemark, error in
            if let error = error as? CLError {
                print("CLError:", error)
                return
            } else if let placemark = placemark?.first {
                // you should always update your UI in the main thread
                DispatchQueue.main.async {
                    //  update UI here
                    
                    if let lines = placemark.addressDictionary?["FormattedAddressLines"] as? [String] {
                        let placeString = lines.joined(separator: ", ")
                        cell.direccion.text = placeString
                    }
                }
            }
        })
        
        nombre = eachEdu.nomPro
        apellido = eachEdu.apePro
        asignaturas = eachEdu.asigPro
        descripcion = eachEdu.descriPro
        celular = eachEdu.celPro
        correo = eachEdu.correoPro
        edad = eachEdu.edadPro
        imagen = eachEdu.imagenPro!
        latitud_gen = eachEdu.latitudPro
        longitud_gen = eachEdu.longitudPro
        ocupacion = eachEdu.ocupaPro
        
        return cell
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemark, error in
            guard let placemark = placemark, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
    
    private func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        guard !searchText.isEmpty else {
            self.actualEducaList = self.educaList
            self.tableView.reloadData()
            return
        }
        
        actualEducaList = educaList.filter({ (educador) -> Bool in
            educador.asigPro.lowercased().contains(searchText.lowercased()) || educador.ocupaPro.lowercased().contains(searchText.lowercased()) || educador.nomPro.lowercased().contains(searchText.lowercased())
            
        }).shuffled()
        
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "SegueFromTable"{
            let perfilEducador = segue.destination as! ViewControllerPerfilEducador
            perfilEducador.nombre = nombre
            perfilEducador.apellido = apellido
            perfilEducador.asignaturas = asignaturas
            perfilEducador.descripcion = descripcion
            perfilEducador.celular = celular
            perfilEducador.correo = correo
            perfilEducador.edad = edad
            perfilEducador.imagen = imagen
            perfilEducador.latitud_gen = latitud_gen
            perfilEducador.longitud_gen = longitud_gen
            perfilEducador.ocupacion = ocupacion
        }
            
    }
    
}

extension CLLocation {
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
}

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}

extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffled() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}
