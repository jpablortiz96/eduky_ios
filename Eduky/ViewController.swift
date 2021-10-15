//
//  ViewController.swift
//  Eduky
//
//  Created by Juan Pablo Enriquez  on 25/05/19.
//  Copyright © 2019 Juan Pablo Enriquez . All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var siginSelector: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var paswordTextField: UITextField!
    
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var btnInstagram: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailTextField.becomeFirstResponder()
        
        signButton.layer.cornerRadius = 5
        btnInstagram.addTarget(self, action: Selector(("urlInstagram")), for: .touchUpInside)
        btnFacebook.addTarget(self, action: Selector(("urlFacebook")), for: .touchUpInside)
        
        //Codigo del gradiente en el login
        let newLayer = CAGradientLayer()
        newLayer.colors = [UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
        newLayer.frame = view.frame
        view.layer.addSublayer(newLayer)
        view.layer.insertSublayer(newLayer, at: 0)
    }

    @IBAction func urlInstagram(_ sender: AnyObject) {
        
        if let url = NSURL(string: "https://www.instagram.com/edukyapp/") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(url as URL)
            }
        }

    }
    
    @IBAction func urlFacebook(_ sender: AnyObject) {
        
        if let url = NSURL(string: "https://es-la.facebook.com/edukyapps/") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(url as URL)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func signSelectionChanged(_ sender: UISegmentedControl) {
        
        isSignIn = !isSignIn
        
        if isSignIn {
            signButton.setTitle("Iniciar sesión", for: .normal)
        }else{
            signButton.setTitle("Registrarse", for: .normal)
        }
        
    }

    @IBAction func signButtonTapped(_ sender: UIButton) {
        
        //Hacer algunas validaciones en el email y la contraseña
        
        if let email = emailTextField.text, let pass = paswordTextField.text {
            
            if isSignIn{
                //Valida los campos que no esten vacios
                if(email != "" && pass != ""){
                    //Valida que el email tenga dicho formato
                    if isValidEmail(testStr: email) {
                        //Iniciar sesión con el usuario Firebase
                        Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                            //Verificar que el usuario no es nil
                            if user != nil {
                                //Usuario encontrado, ir a la pantalla principal
                                self.performSegue(withIdentifier: "goToHome", sender: self)
                            }else{
                                self.showToast(message: "El usuario no se encuentra registrado, por favor registrate")
                            }
                        })
                    }else{
                        self.showToast(message: "Por favor ingresa un email valido")
                    }
                }else{
                    self.showToast(message: "Por favor completa todos los campos")
                }
                
            }
            else{
                //Valida los campos que no esten vacios
                if (email != "" && pass != "") {
                    //Valida que el email tenga dicho formato
                    if(isValidEmail(testStr: email)){
                        //Valida que la contraseña tenga mas de 6 caracteres para la creación
                        if(longitud(str: pass)>=6) {
                            //Registrar el usuario con Firebase
                            Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                                if user != nil {
                                    //Usuario encontrado, ir a la pantalla principal
                                    self.performSegue(withIdentifier: "goToHome", sender: self)
                                }else{
                                    //Error, analizar error
                                }
                            })
                        }else{
                            self.showToast(message: "La contraseña debe tener minimo 6 caracteres")
                        }
                        
                    }else{
                        self.showToast(message: "Por favor ingresa un email valido")
                    }
                
                }else{
                    self.showToast(message: "Por favor completa todos los campos")
                }
            }
            
        }
    
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        paswordTextField.resignFirstResponder()
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func longitud (str: String) -> Int {
        var numero = 0;
        for _ in str.characters {
            numero += 1
        }
        return numero
    }
    
}

extension ViewController  {
    func showToast(message: String){
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.width-325, y: self.view.frame.height-100, width: 280, height: 70))
            toastLabel.textAlignment = .center
            toastLabel.backgroundColor = UIColor.yellow.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.black
            toastLabel.numberOfLines = 2
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 5
            toastLabel.clipsToBounds = true
            toastLabel.text = message
            self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }){(isCompleted) in
            toastLabel.removeFromSuperview()
        }
    }
    
}

