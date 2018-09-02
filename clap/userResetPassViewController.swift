//
//  userResetPassViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/09/02.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import FirebaseAuth

class userResetPassViewController: UIViewController {

    @IBOutlet weak var userEmailForResetPass: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPassButtonTapped(_ sender: Any) {//resetButton
        guard let userEmailAddress = userEmailForResetPass.text, !userEmailAddress.isEmpty else {return}
        
        Auth.auth().sendPasswordReset(withEmail: userEmailAddress) { (error) in
            if error != nil {
                self.ShowMessage(messageToDisplay: (error?.localizedDescription)!)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func usercancelButtonTapped(_ sender: Any) {//cancelButton
        self.dismiss(animated: true, completion: nil)
    }
    
    public func ShowMessage(messageToDisplay: String) {//確認用
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
