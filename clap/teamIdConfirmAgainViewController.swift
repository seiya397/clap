//
//  teamIdConfirmAgainViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/09/15.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import FirebaseFirestore

class teamIdConfirmAgainViewController: UIViewController {

    @IBOutlet weak var displayTeamName: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults: UserDefaults = UserDefaults.standard
        let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!
        
        db.collection("team").document(teamID).addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                print("error \(error)")
                return
            }
            let data = document.data()
            print("this data \(data!["belong"])")
            self.displayTeamName.text = data!["belong"] as? String
        }
        //userDefaultsからひっぱてきてpathに通して、チームめいをひっぱてくる
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        let userInfoRegisterPage2 = self.storyboard?.instantiateViewController(withIdentifier: "userInfoRegisterViewController") as! userInfoRegisterViewController
        self.present(userInfoRegisterPage2, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let loginPage2 = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginPage2, animated: true, completion: nil)
    }
    //所属をfirestoreから引っ張る、表示
    //チームIDも表示
    //キャンセルを押したらログイン画面
    //はいを押したら登録画面
}
