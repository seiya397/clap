//
//  topSelectPageViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/09/02.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit

class topSelectPageViewController: UIViewController {
    
    @IBAction func teamIdRegisterButton(_ sender: Any) {
        let teamInfoRegister = self.storyboard?.instantiateViewController(withIdentifier: "teamInfoRegisterViewController") as! teamInfoRegisterViewController
        self.present(teamInfoRegister, animated: true, completion: nil)
    }
    @IBAction func userRegisterButton(_ sender: Any) {
        let teamIdConfirmation = self.storyboard?.instantiateViewController(withIdentifier: "teamIdConfirmationViewController") as! teamIdConfirmationViewController
        self.present(teamIdConfirmation, animated: true, completion: nil)
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginPage, animated: true, completion: nil)
        
    }
}
