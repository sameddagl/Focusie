//
//  HomeVC.swift
//  Focusie
//
//  Created by Samed Dağlı on 29.11.2022.
//

import UIKit

final class HomeVC: UIViewController {
    private let stateView = FCStateView()
    private let minutesLabel = FCTimeLabel()
    private let secondsLabel = FCTimeLabel()
    private let actionButton = FCActionButton()
    
    var viewModel: HomeViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setInitalInfos()
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
        case.setInitialInfos(let infos):
            self.minutesLabel.text = infos.minutes
            self.secondsLabel.text = infos.seconds
            self.stateView.set(stateName: infos.stateName, image: UIImage(named: infos.stateImageName))
        case .stopTimer:
            break
        case .endTimer:
            break
        case .updateTimer(let time):
            self.minutesLabel.text = time.minutes
            self.secondsLabel.text = time.seconds
        case .updateState(let state):
            self.stateView.set(stateName: state.title, image: UIImage(named: state.imageName))
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
        
        configureStateView()
        configureMinutesLabel()
        configureSecondsLabel()
        configureActionButton()
    }
        
    private func configureStateView() {
        view.addSubview(stateView)
        
        stateView.backgroundColor = .systemGreen
        view.bringSubviewToFront(stateView)
        
        NSLayoutConstraint.activate([
            stateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            stateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stateView.heightAnchor.constraint(equalToConstant: 40),
            stateView.widthAnchor.constraint(equalToConstant: 130),
        ])
    }
    
    private func configureMinutesLabel() {
        view.addSubview(minutesLabel)
        
        NSLayoutConstraint.activate([
            minutesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            minutesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ])
    }
    
    private func configureSecondsLabel() {
        view.addSubview(secondsLabel)
        
        NSLayoutConstraint.activate([
            secondsLabel.topAnchor.constraint(equalTo: minutesLabel.bottomAnchor, constant: -20),
            secondsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func configureActionButton() {
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

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        HomeVC().showPreview()
    }
}
#endif
