//
//  HomeVC.swift
//  Focusie
//
//  Created by Samed Dağlı on 29.11.2022.
//

import UIKit

final class HomeVC: UIViewController {
    private let timeLabel = FCTimeLabel(text: "00\n05")
    
    var viewModel: HomeViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        layout()
        viewModel.startTimer()
    }

}

extension HomeVC: HomeViewModelDelegate {
    func handleWithOutput(_ output: HomeViewModelOutput) {
        switch output {
        case .stopTimer:
            break
        case .endTimer:
            break
        case .updateTimer(let time):
            self.timeLabel.text = "\(time.minutes)\n\(time.seconds)"
        }
    }
    
    func navigate(to route: HomeViewModelRoute) {
        
    }
}

//UI Related
extension HomeVC {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func layout() {
        view.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
