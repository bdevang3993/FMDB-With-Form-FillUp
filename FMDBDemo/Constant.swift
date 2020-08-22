//
//  Constant.swift
//  FMDBDemo
//
//  Created by devang bhavsar on 20/08/20.
//  Copyright © 2020 devang bhavsar. All rights reserved.
//

import UIKit
let kAppName = "FMDBDemo"
var allPdfObject = NSMutableData()
var arrAllPdfData = [NSMutableData]()
struct Alert {
    func showAlert(message:String,viewController:UIViewController) {
        let alert = UIAlertController(title:kAppName, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
extension UIView {

  // Export pdf from Save pdf in drectory and return pdf file path
    func exportAsPdfFromView(name:String,isconvertPDF:Bool) -> String {

      let pdfPageFrame = self.bounds
      let pdfData = NSMutableData()
      UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
      UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
      guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
      self.layer.render(in: pdfContext)
      UIGraphicsEndPDFContext()
        //allPdfObject.append(pdfData as Data)
        arrAllPdfData.append(pdfData)
        if isconvertPDF {
              //
            allPdfObject = merge(pdfs: arrAllPdfData)
            return self.saveViewPdf(data: allPdfObject, name: name)
        }
        else {
            return ""
        }

  }

  // Save pdf file in document directory
    func saveViewPdf(data: NSMutableData,name:String) -> String {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docDirectoryPath = paths[0]
    let pdfPath = docDirectoryPath.appendingPathComponent("\(name).pdf")
    if data.write(to: pdfPath, atomically: true) {
        return pdfPath.path
    } else {
        return ""
    }
  }
    
    //MARK:- Merge all the quation
    func merge(pdfs:[NSMutableData]) -> NSMutableData
    {
        let out = NSMutableData()
        UIGraphicsBeginPDFContextToData(out, .zero, nil)

        guard let context = UIGraphicsGetCurrentContext() else {
            return out as NSMutableData
        }

        for pdf in pdfs {
            guard let dataProvider = CGDataProvider(data: pdf as CFData), let document = CGPDFDocument(dataProvider) else { continue }

            for pageNumber in 1...document.numberOfPages {
                guard let page = document.page(at: pageNumber) else { continue }
                var mediaBox = page.getBoxRect(.mediaBox)
                context.beginPage(mediaBox: &mediaBox)
                context.drawPDFPage(page)
                context.endPage()
            }
        }

        context.closePDF()
        UIGraphicsEndPDFContext()

        return out as NSMutableData
    }
}
