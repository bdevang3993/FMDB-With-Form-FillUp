//
//  MainViewModel.swift
//  FMDBDemo
//
//  Created by devang bhavsar on 20/08/20.
//  Copyright © 2020 devang bhavsar. All rights reserved.
//

import UIKit
import MessageUI

class MainViewModel: NSObject {
    
}
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
             return self.arrOptions.count
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
             let cell = tblDisplay.dequeueReusableCell(withIdentifier: "QuationTableViewCell") as! QuationTableViewCell
            let objData = self.quationList[selectedIndex]
            if let quation = objData.quation {
                cell.lblInfo.text = "\(selectedIndex + 1).  " + quation
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblDisplay.dequeueReusableCell(withIdentifier: "AnsTableViewCell") as! AnsTableViewCell
            let objdata = self.arrOptions[indexPath.row]
            if objdata.selected == 1{
                cell.imgRadio.image = UIImage(named: "radioChecked")
            } else {
                cell.imgRadio.image = UIImage(named: "radioUncheked")
            }
            if let ans = objdata.option {
                cell.lblAns.text = ans
            }
            cell.selectionStyle = .none
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for i in 0...arrOptions.count - 1 {
            arrOptions[i].selected = 0
        }
        arrOptions[indexPath.row].selected = 1
        selectedAnsIndex = indexPath.row
        tblDisplay.reloadData()
    }
}
extension ViewController {
    func checkandUpdateData() {
        let objQuation = quationList[selectedIndex]
        let allData = arrOptions.filter{$0.selected == 1}
    
        if objQuation.ans == allData[0].option {
            //update in data base 1
            DBManager.shared.updateQaution(withID: objQuation.quationId!, givenanswer: 1)
            quationList[selectedIndex].givenAns = 1
        }
        else {
            // update in database 2
            DBManager.shared.updateQaution(withID: objQuation.quationId!, givenanswer: 2)
            quationList[selectedIndex].givenAns = 2
        }
        for value in arrOptions  {
            DBManager.shared.updateloadOptions(SelectedAns: 0, optionId: value.optionId!)
        }
        
        let objSelectedAns = arrOptions![selectedAnsIndex]
       
        DBManager.shared.updateloadOptions(SelectedAns: objSelectedAns.selected!, optionId: objSelectedAns.optionId!)
        if selectedIndex < quationList.count - 1 {
            _ = self.view.exportAsPdfFromView(name: "\(selectedIndex)", isconvertPDF: false)
        } else {
             let url = self.view.exportAsPdfFromView(name: "YourAnswersSheet", isconvertPDF: true)
              self.yourTotalScore()
             print("Selected URl = \(url)")
        }
       
        self.btnNextClicked(AnyObject.self)
    }
    
    func yourTotalScore() {
        let allData = quationList.filter{$0.givenAns == 1}
        let newString = "Your total score is = \(allData.count) / \(quationList.count)"
        self.sendEmail()
        Alert().showAlert(message: newString, viewController: self)
    }
}
extension ViewController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["bdevang3993@gmail.com"])
            mail.setSubject("Your Answer Sheet")
            mail.setMessageBody("Your all out put!", isHTML: true)
            mail.mailComposeDelegate = self
            if let filePath = Bundle.main.path(forResource: "YourAnswersSheet", ofType: "pdf") {
                if let data = NSData(contentsOfFile: filePath) {
                    mail.addAttachmentData(data as Data, mimeType: "application/json" , fileName: "YourAnswersSheet.pdf")
                }
            }
            present(mail, animated: true)
        }
        else {
            print("Email cannot be sent")
        }
    }
}
