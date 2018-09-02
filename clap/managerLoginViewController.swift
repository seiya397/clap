//
//  managerLoginViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/26.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import FirebaseAuth

class managerLoginViewController: UIViewController {
    
    @IBOutlet weak var managerMailaddress: UITextField!
    @IBOutlet weak var managerPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func managerNextButton(_ sender: Any) { //ログイン
        guard let emailText = managerMailaddress.text, !emailText.isEmpty else {
            self.ShowMessage(messageToDisplay: "メールアドレスを記入してください。")
            return
        }
        guard let passText = managerPassword.text, !passText.isEmpty else {
            self.ShowMessage(messageToDisplay: "パスワードを記入してください。")
            return
        }
        
        Auth.auth().signIn(withEmail: emailText, password: passText) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.ShowMessage(messageToDisplay: error.localizedDescription)
                return
            }
            
            if user != nil {
                let mainPage = self.storyboard?.instantiateViewController(withIdentifier: "mainPageViewController") as! mainPageViewController
                self.present(mainPage, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func managerRegisterButton(_ sender: Any) { //新規登録がまだな方へ
        let managerRegisterPage = self.storyboard?.instantiateViewController(withIdentifier: "managerRegisterViewController") as! managerRegisterViewController
        self.present(managerRegisterPage, animated: true, completion: nil)
    }
    
    
    @IBAction func updateRegisterInfoButton(_ sender: Any) { //情報更新
       
    }
    
    
    
    public func ShowMessage(messageToDisplay: String) { //確認用
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
