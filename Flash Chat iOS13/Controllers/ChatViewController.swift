//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    var Messages:[Message] = [];
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true;
        tableView.dataSource = self;
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        LoadMessages()
    }
    
    func LoadMessages(){
        var NewMessages:[Message] = [];
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                let message = Message(Sender: document.data()[K.FStore.senderField] as! String, Message:                            document.data()[K.FStore.bodyField] as! String);
                    //print(message)
                     NewMessages.append(message);
                }
                 self.Messages = NewMessages;
                NewMessages=[]
                 DispatchQueue.main.async {
                 self.tableView.reloadData()
                    let Index = IndexPath(row: (self.Messages.count-1), section: 0)
                    self.tableView.scrollToRow(at: Index, at: .top, animated: true)
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let message = messageTextfield.text,let sender = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.bodyField : message,
                K.FStore.senderField : sender,
                K.FStore.dateField :Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error{
                    print(e)
                }else{
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    print("Successful")
                }
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print(error)
        }
    }
}




//MARK: -DATA SOURCE

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return Messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = Messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.textView.text = Messages[indexPath.row].Message;
        print(message.Sender == Auth.auth().currentUser?.email)
        if message.Sender == Auth.auth().currentUser?.email{
            cell.youAvatarImage.isHidden = false;
            cell.meAvatorImage.isHidden = true;
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple);
        }else{
            cell.youAvatarImage.isHidden = true;
            cell.meAvatorImage.isHidden = false;
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.blue);
        }
        return cell;
    }
    
    
}
