//
//  HomeVC.swift
//  Focusie
//
//  Created by Samed Dağlı on 29.11.2022.
//

import UIKit

final class HomeVC: UIViewController {
    private let bgImageView = UIImageView()
    private let minutesLabel = FCTimeLabel(text: "00")
    private let secondsLabel = FCTimeLabel(text: "25")
    private let actionButton = FCActionButton()
    
    var viewModel: HomeViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        layout()
    }
    
    @objc private func actionButtonTapped() {
        print("tapped")
        actionButton.isSelected.toggle()
        
        if actionButton.isSelected {
            viewModel.startTimer()
        }
        else {
            viewModel.pauseTimer()
        }
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
            self.minutesLabel.text = time.minutes
            self.secondsLabel.text = time.seconds
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
        bgImageView.image = UIImage(named: "BGImage")
        bgImageView.alpha = 0.9
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bgImageView)
        
        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(minutesLabel)
        
        NSLayoutConstraint.activate([
            minutesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            minutesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ])
        
        view.addSubview(secondsLabel)
        
        NSLayoutConstraint.activate([
            secondsLabel.topAnchor.constraint(equalTo: minutesLabel.bottomAnchor, constant: -20),
            secondsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: secondsLabel.bottomAnchor, constant: 60),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 60),
            actionButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
}
