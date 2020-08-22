//
//  ViewController.swift
//  FMDBDemo
//
//  Created by devang bhavsar on 20/08/20.
//  Copyright © 2020 devang bhavsar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tblDisplay: UITableView!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    var quationList: [quationsInfo]!
    var arrOptions:[AnswerOption]!
    var selectedIndex:Int = 0
    var selectedAnsIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
        self.tblDisplay.delegate = self
        self.tblDisplay.dataSource = self
        self.tblDisplay.separatorStyle = .none
        quationList = DBManager.shared.loadQuation()
        arrOptions = DBManager.shared.loadOptions(quationId: (selectedIndex + 1))
        tblDisplay.reloadData()
    }
    @IBAction func btnPreviousClicked(_ sender: Any) {
        if selectedIndex > 0 {
            selectedIndex = selectedIndex - 1
            arrOptions = DBManager.shared.loadOptions(quationId: (selectedIndex + 1))
            tblDisplay.reloadData()
        }
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        
        
        if quationList.count - 1 > selectedIndex {
            selectedIndex = selectedIndex + 1
                   arrOptions = DBManager.shared.loadOptions(quationId: (selectedIndex + 1))
                   tblDisplay.reloadData()
        } else if  quationList.count - 1 == selectedIndex {
//            let allData = quationList.filter{$0.givenAns == 1}
//            var newString = "Your total score is = \(allData.count) / \(quationList.count)"
//            Alert().showAlert(message: newString, viewController: self)
        }
       
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
        let allData = arrOptions.filter{$0.selected == 1}
        if allData.count > 0 {
            self.checkandUpdateData()
        }
        else {
            Alert().showAlert(message: "Please select any one option", viewController: self)
        }
    }
}

