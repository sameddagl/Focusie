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
            self.stateView.set(with: infos.currentState)
        case .stopTimer:
            break
        case .endTimer:
            break
        case .updateTimer(let time):
            self.minutesLabel.text = time.minutes
            self.secondsLabel.text = time.seconds
        case .updateState(let state):
            self.stateView.set(with: state)
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
        configureActionButton()
        
        let timeStack = UIStackView(arrangedSubviews: [minutesLabel, secondsLabel])
        timeStack.spacing = -25
        timeStack.distribution = .fill
        timeStack.axis = .vertical
        timeStack.alignment = .center
        
        let stack = UIStackView(arrangedSubviews: [stateView, timeStack, actionButton])
        stack.distribution = .fill
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 20
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            stack.widthAnchor.constraint(equalToConstant: 200),
            stack.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
        
    private func configureStateView() {
        stateView.backgroundColor = .systemGreen
        
        NSLayoutConstraint.activate([
            stateView.heightAnchor.constraint(equalToConstant: 40),
            stateView.widthAnchor.constraint(equalToConstant: 130),
        ])
    }

    
    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.widthAnchor.constraint(equalToConstant: 60),
            actionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
