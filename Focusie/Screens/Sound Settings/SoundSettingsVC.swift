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
    var delegate: SoundSettingsUpdateDelegate!
    
    private var bgSounds = [BGSound]()
    
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
            tableView.reloadData()
        case .updateWith:
            delegate.didUpdateWithNewSound()
        }
    }
}

extension SoundSettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bgSounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = bgSounds[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.isSelected ? .checkmark : .none
        
        return cell
    }
}

extension SoundSettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
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
