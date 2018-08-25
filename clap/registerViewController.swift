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
        Auth.auth().createUser(withEmail: mailAddress.text!, password: paswordRegister.text!) { (user, error) in
            if let error = error {
                print(error)
            }
            if let _ = user {
                print("登録できました")
            }
        }
    }
    
    
    
    @IBAction func loginSegueButton(_ sender: Any) {
        performSegue(withIdentifier: "goToLoginImplement", sender: nil)
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
