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

        let userDefaults:UserDefaults = UserDefaults.standard
        let teamID: String = userDefaults.string(forKey: "teamID")!
        print("これはチームIDの\(teamID)")
        let userID: String = userDefaults.string(forKey: "userID")!
        print("これはuserの\(userID)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "topSelectPageViewController") as! topSelectPageViewController
            
            let appDelegate = UIApplication.shared.delegate
            
            appDelegate?.window??.rootViewController = signInPage
        }catch {
            self.ShowMessage(messageToDisplay: "ログアウトができません。")
        }
    }
    
    @IBAction func goMemberEvaluationButtonTapped(_ sender: Any) {
        let evaluatePage = self.storyboard?.instantiateViewController(withIdentifier: "memberEvaluationViewController") as! memberEvaluationViewController
        self.present(evaluatePage, animated: true, completion: nil)
    }
    
    @IBAction func goChatButtonTapped(_ sender: Any) {
        let cahtPage = self.storyboard?.instantiateViewController(withIdentifier: "chatPageViewController") as! chatPageViewController
        self.present(cahtPage, animated: true, completion: nil)
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
