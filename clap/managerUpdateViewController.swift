//
//  managerUpdateViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/29.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit

class managerUpdateViewController: UIViewController {

    @IBOutlet weak var currentBrlongTo: UILabel!
    @IBOutlet weak var currentSports: UILabel!
    @IBOutlet weak var currentManagerName: UILabel!
    @IBOutlet weak var currentManagerAge: UILabel!
    
    @IBOutlet weak var updateBelongTo: UITextField!
    @IBOutlet weak var updateSports: UITextField!
    @IBOutlet weak var updateManagerName: UITextField!
    @IBOutlet weak var updateManagerAge: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateButton(_ sender: Any) {
    }
    
    //firebaseからcurrent情報を引っ張ってきて、更新
    //その後更新UNIXタイムをupdateButtonイベントと同時に発火、firebaseに投げる
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
