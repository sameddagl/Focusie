//
//  SoundSettingsVC.swift
//  Focusie
//
//  Created by Samed Dağlı on 7.12.2022.
//

import UIKit

final class SoundSettingsVC: UIViewController {
    private var tableView: UITableView!
    
    var viewModel: SoundSettingsViewModelProtocol!
    
    private var bgSounds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        createTableView()
        viewModel.load()
        
    }
    
    @objc private func doneTapped() {
        dismiss(animated: true)
    }

}

extension SoundSettingsVC: SoundSettingsViewModelDelegate {
    func handleOutput(output: SoundSettingsOutput) {
        switch output {
        case .updateSounds(let sounds):
            bgSounds = sounds
        case .updateWith(let sound):
            print(sound)
        }
    }
}

extension SoundSettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bgSounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = bgSounds[indexPath.row]
        return cell
    }
}

extension SoundSettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectItem(at: indexPath.row)
    }
}

//MARK: - UI Related
extension SoundSettingsVC {
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.rightBarButtonItem = doneButton
    }

    private func createTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}
