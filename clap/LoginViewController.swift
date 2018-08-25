//
//  LoginViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/25.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var commonMailaddress: UITextField!
    @IBOutlet weak var commonPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func commonLoginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: commonMailaddress.text!, password: commonPassword.text!) { (user, error) in
            if let error = error {
                print("loginに失敗しました🧠")
                return
            }
            if let _ = user {
                print("loginに成功しました🧠")
            }
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
