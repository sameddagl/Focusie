//
//  SettingsVC.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import UIKit
import SwiftUI

final class SettingsVC: UIViewController {
    private let focusTimeSlider = UISlider()
    private let breakTimeSlider = UISlider()
    
    var viewModel: SettingsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        configureView()
        layout()
    }
}

extension SettingsVC: SettingsViewModelDelegate {
    func handleWithOutput(_ output: SettingsOutput) {
        
    }
}

//MARK: - UI Related
extension SettingsVC {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    private func layout() {
        focusTimeSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(focusTimeSlider)
        
        focusTimeSlider.minimumValue = 5
        focusTimeSlider.maximumValue = 35
        focusTimeSlider.tintColor = .systemPink
        
        NSLayoutConstraint.activate([
            focusTimeSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            focusTimeSlider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            focusTimeSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
}

#if DEBUG
 import SwiftUI

 @available(iOS 13, *)
 struct ViewController_Preview: PreviewProvider {
     static var previews: some View {
         // view controller using programmatic UI
         SettingsVC().showPreview()
     }
 }
 #endif
