//
//  StartViewController.swift
//  CollectionLayoutTest
//
//  Created by Artem Kvashnin on 26.08.2023.
//

import UIKit

class StartViewController: UIViewController {
    
    let customButton: UIButton = {
        let button = UIButton()
        button.setTitle("CustomLayout", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    let compositionalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Compositional Layout", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose example:"
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        customButton.addTarget(self, action: #selector(movetoNextScreen), for: .touchUpInside)
        compositionalButton.addTarget(self, action: #selector(movetoNextScreen), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(customButton)
        view.addSubview(compositionalButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        customButton.translatesAutoresizingMaskIntoConstraints = false
        compositionalButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            customButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            compositionalButton.centerXAnchor.constraint(equalTo: customButton.centerXAnchor, constant: 0),
            compositionalButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: compositionalButton.centerYAnchor, constant: -80)
        ])
    }
    
    @objc private func movetoNextScreen(_ sender: UIButton) {
        switch sender {
        case customButton:
            let customVC = CustomViewController()
            navigationController?.pushViewController(customVC, animated: true)
        case compositionalButton:
            let compositionalVC = CompositionalViewController()
            navigationController?.pushViewController(compositionalVC, animated: true)
        default:
            break
        }
    }
}
