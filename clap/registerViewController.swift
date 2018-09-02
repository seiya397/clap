//
//  registerViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/25.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class registerViewController: UIViewController {

    @IBOutlet weak var mailAddress: UITextField!
    @IBOutlet weak var paswordRegister: UITextField!
    @IBOutlet weak var oneMorePasswordRegister: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mailAddress.layer.borderWidth = 2
        paswordRegister.layer.borderWidth = 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButton(_ sender: Any) {
        guard let userRegisterMailText = mailAddress.text, !userRegisterMailText.isEmpty else {
            self.ShowMessage(messageToDisplay: "メールアドレスを記入してください。")
            return
        }
        guard let userRegisterPassText = paswordRegister.text, !userRegisterPassText.isEmpty else {
            self.ShowMessage(messageToDisplay: "パスワードを記入してください。")
            return
        }
        guard let userRegisterResetPassText = oneMorePasswordRegister.text, !userRegisterResetPassText.isEmpty else {
            self.ShowMessage(messageToDisplay: "パスワードを記入してください。")
            return
        }
        Auth.auth().createUser(withEmail: userRegisterMailText, password: userRegisterPassText) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.ShowMessage(messageToDisplay: error.localizedDescription)
                return
            }
            if let user = user {
                var databaseReference: DatabaseReference!
                databaseReference = Database.database().reference()
                print("success")
                self.performSegue(withIdentifier: "goPlofileRegister", sender: nil)
            }
        }
    }
    
    @IBAction func userRegisterCancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //認証用関数
    public func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    

}
