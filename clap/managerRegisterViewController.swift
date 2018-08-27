//
//  managerRegisterViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/26.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class managerRegisterViewController: UIViewController {
    
    @IBOutlet weak var managerRegisterMailaddress: UITextField!
    @IBOutlet weak var managerRegisterPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func managerRegisterNextButton(_ sender: Any) {
        Auth.auth().createUser(withEmail: managerRegisterMailaddress.text!, password: managerRegisterMailaddress.text!) { (user, error) in
            if let error = error {
                print("エラーが発生したぜ")
            }
            if let user = user {
                print("成功したぜ")
                self.performSegue(withIdentifier: "goTeamRegister", sender: nil)
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
