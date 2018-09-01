//
//  mainPageViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/09/01.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class mainPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "managerLoginViewController") as! managerLoginViewController
            
            let appDelegate = UIApplication.shared.delegate
            
            appDelegate?.window??.rootViewController = signInPage
        }catch {
            self.ShowMessage(messageToDisplay: "ログアウトができません。")
        }
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
