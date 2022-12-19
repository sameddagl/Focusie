//
//  SettingsVC.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import UIKit
import MessageUI

final class SettingsVC: UIViewController {
    private let focusTimeSlider = UISlider()
    private let focusTimeSliderLabel = FCTitleLabel(alignment: .left, fontSize: 15)
    
    private let shortBreakTimeSlider = UISlider()
    private let shortBreakTimeSliderLabel = FCTitleLabel(alignment: .left, fontSize: 15)
    
    private let longBreakTimeSlider = UISlider()
    private let longBreakTimeSliderLabel = FCTitleLabel(alignment: .left, fontSize: 15)
    
    private var tableView: UITableView!
    
    var viewModel: SettingsViewModelProtocol!
    
    weak var delegate: SettingsUpdateDelegate!
    
    private var tableViewOptions = ["📪 Contact us", "⭐️ Rate & Comment", "🎉 Share with friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        layoutFocusTimeSettings()
        layoutShortBreakTimeSettings()
        layoutLongBreakTimeSettings()
        createTableView()
        
        viewModel.load()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.updateTimes()
    }
    
    @objc private func focusTimeChanged() {
        viewModel.focusTimeChanged(sliderValue: focusTimeSlider.value)
    }
    
    @objc private func shortBreakTimeChanged() {
        viewModel.shortBreakTimeChanged(sliderValue: shortBreakTimeSlider.value)
    }
    
    @objc private func longBreakTimeChanged() {
        viewModel.longBreakTimeChanged(sliderValue: longBreakTimeSlider.value)
    }
    
    @objc private func doneTapped() {
        dismiss(animated: true)
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["samed.dagli@outlook.com"])
            mail.setSubject("About Focusie")
            present(mail, animated: true)
        }
    }
}

extension SettingsVC: SettingsViewModelDelegate {
    func handleWithOutput(_ output: SettingsOutput) {
        switch output {
        case .updateInitialInfos(let infos):
            focusTimeSliderLabel.text = String(format: "%.0f", infos.focusTime)
            shortBreakTimeSliderLabel.text = String(format: "%.0f", infos.shortBreakTime)
            longBreakTimeSliderLabel.text = String(format: "%.0f", infos.longBreakTime)
            
            focusTimeSlider.setValue(infos.focusTime, animated: false)
            shortBreakTimeSlider.setValue(infos.shortBreakTime, animated: false)
            longBreakTimeSlider.setValue(infos.longBreakTime, animated: false)
            
            focusTimeSlider.isUserInteractionEnabled = infos.areSlidersEnabled
            shortBreakTimeSlider.isUserInteractionEnabled = infos.areSlidersEnabled
            longBreakTimeSlider.isUserInteractionEnabled = infos.areSlidersEnabled
        case .updateTimesOnMainScreen:
            delegate.didUpdateWithTimes()
        case .focusTimeChanged(let value):
            focusTimeSliderLabel.text = String(format: "%.0f", value)
            focusTimeSlider.setValue(value, animated: false)
        case .shortBreakTimeChanged(let value):
            shortBreakTimeSliderLabel.text = String(format: "%.0f", value)
            shortBreakTimeSlider.setValue(value, animated: false)
        case .longBreakTimeChanged(let value):
            longBreakTimeSliderLabel.text = String(format: "%.0f", value)
            longBreakTimeSlider.setValue(value, animated: false)
        case .openMail:
            sendEmail()
        case .openProductPage(let url):
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case .openSharePage(let url):
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityViewController, animated: true)
        }
    }
}

extension SettingsVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = tableViewOptions[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "About"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            viewModel.contactUsTapped()
        }
        else if indexPath.row == 1 {
            viewModel.reviewTapped()
        }
        else if indexPath.row == 2 {
            viewModel.shareTapped()
        }
    }
}

//MARK: - UI Related
extension SettingsVC {
    private func configureView() {
        title = NSLocalizedString("settings_title", comment: "")
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func layoutFocusTimeSettings() {
        focusTimeSlider.minimumValue = 5
        focusTimeSlider.maximumValue = 35
        focusTimeSlider.tintColor = .systemPink
        
        focusTimeSlider.addTarget(self, action: #selector(focusTimeChanged), for: .valueChanged)
        
        let focusTimeSliderView = FCSliderView(title: NSLocalizedString("focus_time", comment: ""), valueLabel: focusTimeSliderLabel, slider: focusTimeSlider)
        view.addSubview(focusTimeSliderView)
        
        NSLayoutConstraint.activate([
            focusTimeSliderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            focusTimeSliderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            focusTimeSliderView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func layoutShortBreakTimeSettings() {
        shortBreakTimeSlider.minimumValue = 2
        shortBreakTimeSlider.maximumValue = 10
        shortBreakTimeSlider.tintColor = .systemPink
        
        shortBreakTimeSlider.addTarget(self, action: #selector(shortBreakTimeChanged), for: .valueChanged)
        
        let shortBreakTimeSliderView = FCSliderView(title: NSLocalizedString("short_break", comment: ""), valueLabel: shortBreakTimeSliderLabel, slider: shortBreakTimeSlider)
        view.addSubview(shortBreakTimeSliderView)
        
        NSLayoutConstraint.activate([
            shortBreakTimeSliderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shortBreakTimeSliderView.topAnchor.constraint(equalTo: focusTimeSlider.bottomAnchor, constant: 40),
            shortBreakTimeSliderView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func layoutLongBreakTimeSettings() {
        longBreakTimeSlider.minimumValue = 10
        longBreakTimeSlider.maximumValue = 30
        longBreakTimeSlider.tintColor = .systemPink
        
        longBreakTimeSlider.addTarget(self, action: #selector(longBreakTimeChanged), for: .valueChanged)
        
        let longBreakTimeSliderView = FCSliderView(title: NSLocalizedString("long_break", comment: ""), valueLabel: longBreakTimeSliderLabel, slider: longBreakTimeSlider)
        view.addSubview(longBreakTimeSliderView)
        
        NSLayoutConstraint.activate([
            longBreakTimeSliderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            longBreakTimeSliderView.topAnchor.constraint(equalTo: shortBreakTimeSlider.bottomAnchor, constant: 40),
            longBreakTimeSliderView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func createTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: longBreakTimeSlider.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

