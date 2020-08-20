//
//  MainViewModel.swift
//  FMDBDemo
//
//  Created by devang bhavsar on 20/08/20.
//  Copyright © 2020 devang bhavsar. All rights reserved.
//

import UIKit

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
            if objdata.isSelected == true {
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
            arrOptions[i].isSelected = false
        }
        arrOptions[indexPath.row].isSelected = true
        tblDisplay.reloadData()
    }
}
extension ViewController {
    func checkandUpdateData() {
        let objQuation = quationList[selectedIndex]
        let allData = arrOptions.filter{$0.isSelected == true}
    
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
        self.btnNextClicked(AnyObject.self)
    }
}
