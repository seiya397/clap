//
//  LoginViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/25.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

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
    
    @IBAction func commonLoginButton(_ sender: Any) {//ログイン
        guard let userEmailText = commonMailaddress.text, !userEmailText.isEmpty else {
            self.ShowMessage(messageToDisplay: "メールアドレスを記入してください。")
            return
        }
        guard let userPassText = commonPassword.text, !userPassText.isEmpty else {
            self.ShowMessage(messageToDisplay: "パスワードを記入してください。")
            return
        }
        Auth.auth().signIn(withEmail: userEmailText, password: userPassText) { (user, error) in
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
    
    @IBAction func userRegisterButtonTapped(_ sender: Any) {//新規登録
        let selectPage = self.storyboard?.instantiateViewController(withIdentifier: "topSelectPageViewController") as! topSelectPageViewController
        self.present(selectPage, animated: true, completion: nil)
    }
    //segueで繋いでいる理由は、視覚的にわかりやすくするため
    
    @IBAction func resetPassButtontapped(_ sender: Any) {//パスワード忘れた人
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
