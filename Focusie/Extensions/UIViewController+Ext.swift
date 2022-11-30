//
//  UIViewController+Ext.swift
//  Focusie
//
//  Created by Samed Dağlı on 30.11.2022.
//

import UIKit
import SwiftUI

extension UIViewController {
    
    @available(iOS 13, *)
    private struct Preview: UIViewControllerRepresentable {
        // this variable is used for injecting the current view controller
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            //
        }
    }
    
    @available(iOS 13, *)
    func showPreview() -> some View {
        Preview(viewController: self)
    }
    
    /*#if DEBUG
     import SwiftUI

     @available(iOS 13, *)
     struct ViewController_Preview: PreviewProvider {
         static var previews: some View {
             // view controller using programmatic UI
             ViewController().showPreview()
         }
     }
     #endif
     view raw*/
}
