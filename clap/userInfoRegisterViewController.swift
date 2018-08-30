//
//  userInfoRegisterViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/27.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import Firebase

class userInfoRegisterViewController: UIViewController {

    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPosition: UITextField!
    @IBOutlet weak var userAge: UITextField!
    @IBOutlet weak var userJender: UITextField!
    @IBOutlet weak var userWeight: UITextField!
    @IBOutlet weak var userHeight: UITextField!
    @IBOutlet weak var teamID: UITextField!
    
    var databaseRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        databaseRef = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userInfoRegisterButton(_ sender: Any) {
//        let messageData = ["manager": managerName.text!]
//        let invidiv = 
        let userBasicInfo = ["userName": userName.text!, "userAge": userAge.text!, "userWight": userWeight.text!, "userHeight": userHeight.text!]
        
        databaseRef.child("invidiv").childByAutoId().setValue(userBasicInfo) //firebaeからindivキーを取得し、そこの階層直下に配備
        //選択式にすべき！！！！！！！
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
