//
//  chatViewController.swift
//  
//
//  Created by Seiya on 2018/09/05.
//

import UIKit
import Firebase

class chatViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    enum textFieldKind:Int {
        case name = 1
        case message = 2
    }
    
    var defaultstore:Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextField.delegate = self
        nameTextField.delegate = self
        //Firestoreへのコネクションを張る
        defaultstore = Firestore.firestore()
        
        
        //Firestoreからデータを取得し、TextViewに表示する
        defaultstore.collection("chat").addSnapshotListener { (snapShot, error) in
            guard let value = snapShot else {
                print("snapShot is nil")
                return
            }
            
            value.documentChanges.forEach{diff in
                //更新内容が追加だったときの処理
                if diff.type == .added {
                    //追加データを変数に入れる
                    let chatDataOp = diff.document.data() as? Dictionary<String, String>
                    print(diff.document.data())
                    guard let chatData = chatDataOp else {
                        return
                    }
                    guard let message = chatData["message"] else {
                        return
                    }
                    guard let name = chatData["name"] else {
                        return
                        
                        
                    }
                    //TextViewの一番下に新しいメッセージ内容を追加する
                    self.textView.text =  "\(self.textView.text!)\n\(name) : \(message)"
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

extension chatViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("returnが押されたよ")
        
        //キーボードを閉じる
        textField.resignFirstResponder()
        
        //nameTextFieldの場合は　returnを押してもFirestoreへ行く処理をしない
        if textField.tag == textFieldKind.name.rawValue {
            return true
        }
        //nameに入力されたテキストを変数に入れる。nilの場合はFirestoreへ行く処理をしない
        guard let name = nameTextField.text else {
            return true
        }
        
        //nameが空欄の場合はFirestoreへ行く処理をしない
        if nameTextField.text == "" {
            return true
        }
        
        //messageに入力されたテキストを変数に入れる。nilの場合はFirestoreへ行く処理をしない
        guard let message = messageTextField.text else {
            return true
        }
        
        //messageが空欄の場合はFirestoreへ行く処理をしない
        if messageTextField.text == "" {
            return true
        }
        
        //入力された値を配列に入れる
        let messageData: [String: String] = ["name":name, "message":message]
        
        //Firestoreに送信する
        defaultstore.collection("chat").addDocument(data: messageData)
        
        //メッセージの中身を空にする
        messageTextField.text = ""
        
        return true
    }
}
