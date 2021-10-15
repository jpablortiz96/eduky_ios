//
//  ViewControllerPerfilEducador.swift
//  Eduky
//
//  Created by Juan Pablo Enriquez  on 30/06/19.
//  Copyright © 2019 Juan Pablo Enriquez . All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import MessageUI

class ViewControllerPerfilEducador: UIViewController, CLLocationManagerDelegate, MFMailComposeViewControllerDelegate {
    
     var nombre = ""
     var apellido = ""
     var asignaturas = ""
     var descripcion = ""
     var celular = ""
     var correo = ""
     var edad = ""
     var imagen = ""
     var latitud_gen = ""
     var longitud_gen = ""
     var ocupacion = ""

    @IBOutlet weak var nombreEducador: UILabel!
    @IBOutlet weak var imagenEducador: UIImageView!
    @IBOutlet weak var ocupaEducador: UILabel!
    @IBOutlet weak var edadEducador: UILabel!
    @IBOutlet weak var asigEducador: UILabel!
    @IBOutlet weak var descriEducador: UILabel!
    @IBOutlet weak var emailEducador: UILabel!
    @IBOutlet weak var celEducador: UILabel!
    @IBOutlet weak var direcEducador: UILabel!
    
    @IBAction func btn_enviarCorreo(_ sender: AnyObject) {
        
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            showMailError()
        }
        
    }
    @IBAction func btn_llamar(_ sender: AnyObject) {
        
        if let url = NSURL(string: "tel://\(celular)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
            else {
                 UIApplication.shared.openURL(url as URL)
            }
        }
        
    }
    @IBAction func btn_chat(_ sender: AnyObject) {
        
        let appURL = NSURL(string: "https://api.whatsapp.com/send?phone=\(celular)")!
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL as URL)
            }
        }
        else {
            // Whatsapp is not installed
        }
        
    }
    
    func configureMailController() -> MFMailComposeViewController{
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([correo])
        mailComposerVC.setSubject("Eduky - Inquietud de Usuario")
        mailComposerVC.setMessageBody("Escribe aquí lo que quieras preguntarle al educador "+"\(nombre)"+" "+"\(apellido)", isHTML: false)
        
        return mailComposerVC
    
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showMailError(){
    
        let sendMailAlertError = UIAlertController(title: "No se puede enviar correo", message: "Verifica tu cuenta de usuario, esto es necesario para enviar correos", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailAlertError.addAction(dismiss)
        self.present(sendMailAlertError, animated: true, completion: nil)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombreEducador.text = nombre+" "+apellido
        ocupaEducador.text = ocupacion
        edadEducador.text = edad
        asigEducador.text = asignaturas
        descriEducador.text = descripcion
        emailEducador.text = correo
        celEducador.text = celular
        
        let font = UIFont.systemFont(ofSize: 15.0)
        descriEducador.sizeThatFits(rectForText(text: descripcion, font: UIFont.systemFont(ofSize: 15.0), maxSize: descripcion.size(attributes: [NSFontAttributeName:font])))
        
        self.title = "Educador"+" "+nombre

        // Do any additional setup after loading the view.
        
        
        if let url = NSURL(string: imagen){
            URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) in
                if error != nil{
                    print(error)
                    return
                }
                self.imagenEducador.image = UIImage(data: data!)
            }
        ).resume()
        }
 
            
            let latitud = (self.latitud_gen as NSString).doubleValue
            let longitud = (self.longitud_gen as NSString).doubleValue
            
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
                            self.direcEducador.text = placeString
                        }
                    }
                }
            })

            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.width, height: rect.height)
        return size
    }
    
    
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



