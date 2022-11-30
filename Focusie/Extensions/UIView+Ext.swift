//
//  UIView+Ext.swift
//  Focusie
//
//  Created by Samed Dağlı on 30.11.2022.
//

import UIKit
import SwiftUI

extension UIView {
    func pinToEdges(of view: UIView) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @available(iOS 13, *)
    private struct Preview: UIViewRepresentable {
        typealias UIViewType = UIView
        let view: UIView
        func makeUIView(context: Context) -> UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            //
        }
    }
    
    @available(iOS 13, *)
    func showPreview() -> some View {
        // inject self (the current UIView) for the preview
        Preview(view: self)
    }
    
    /*#if DEBUG
     import SwiftUI

     @available(iOS 13, *)
     struct HeaderView_Preview: PreviewProvider {
         static var previews: some View {
             // view controller using programmatic UI
             FCStateView().showPreview()
         }
     }
     #endif*/

}

