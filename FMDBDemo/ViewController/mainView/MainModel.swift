//
//  MainModel.swift
//  FMDBDemo
//
//  Created by devang bhavsar on 20/08/20.
//  Copyright © 2020 devang bhavsar. All rights reserved.
//

import Foundation
struct quationsInfo {
    var quationId:Int?
    var quation:String?
    var ans:String?
    var givenAns:Int?
}

struct AnswerOption {
    var optionId:Int?
    var quationId:Int?
    var option:String?
    var selected:Int?
}
