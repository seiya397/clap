//
//  passwordResetViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/09/01.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import FirebaseAuth

class passwordResetViewController: UIViewController {
    @IBOutlet weak var emaiAddoressText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPasswordTapped(_ sender: Any) {
        guard let emailAddress = emaiAddoressText.text, !emailAddress.isEmpty else {return}
        
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
            if error != nil {
                self.ShowMessage(messageToDisplay: (error?.localizedDescription)!)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

}
