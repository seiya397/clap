//
//  teamIdConfirmWrongViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/09/15.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

//textfieldの下線追加
extension UITextField {
    func idBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}

class teamIdConfirmWrongViewController: UIViewController {

    @IBOutlet weak var confirmTextAgain: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        guard  let confirmText = confirmTextAgain.text, !confirmText.isEmpty else {
            self.ShowMessage(messageToDisplay: "チームIDを記入してください。")
            return
        }
        
        let docRef = db.collection("teams").document(confirmTextAgain.text!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userDefaults: UserDefaults = UserDefaults.standard
                let teamIdByWritten = self.confirmTextAgain.text!
                userDefaults.set(teamIdByWritten, forKey: "teamID")
                userDefaults.synchronize()
//                let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!
//                print(teamID)
                let userInfoRegisterPage = self.storyboard?.instantiateViewController(withIdentifier: "userInfoRegisterViewController") as! userInfoRegisterViewController
                self.present(userInfoRegisterPage, animated: true, completion: nil)
            } else {
                let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginPage, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginPage, animated: true, completion: nil)
    
    }
    
    public func ShowMessage(messageToDisplay: String) { //認証用関数
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //キーボードhide処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
