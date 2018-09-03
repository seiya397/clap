//
//  chatPageViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/09/03.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import FirebaseAuth

class chatPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goScheduleButtonTappedFromCat(_ sender: Any) {
        let SchedulePage = self.storyboard?.instantiateViewController(withIdentifier: "mainPageViewController") as! mainPageViewController
        self.present(SchedulePage, animated: true, completion: nil)
    }
    
    @IBAction func goMemberEvaluateButtonTappedFromChat(_ sender: Any) {
        let evaluatePage = self.storyboard?.instantiateViewController(withIdentifier: "memberEvaluationViewController") as! memberEvaluationViewController
        self.present(evaluatePage, animated: true, completion: nil)
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            
            let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "topSelectPageViewController") as! topSelectPageViewController
            
            let appDelegate = UIApplication.shared.delegate
            
            appDelegate?.window??.rootViewController = signInPage
        } catch {
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
