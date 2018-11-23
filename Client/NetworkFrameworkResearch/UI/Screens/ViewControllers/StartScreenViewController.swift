//
//  StartScreenViewController.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

final class StartScreenViewController: UIViewController {
    
    @IBOutlet weak var ipAddressTextfield: UITextField!
    @IBOutlet weak var portNumberTextfield: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitle("Welcome")
        usernameTextField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -8).isActive = true
        usernameTextField.returnKeyType = .join
        usernameTextField.delegate = self
        ipAddressTextfield.text = Configuration.host
        portNumberTextfield.text = String(Configuration.port)
    }
    
    // MARK: - Actions
    @IBAction private func goButtonDidtouchUpInside(_ sender: UIButton) {
        joinChatroomIfPossible()
    }
    
    private func joinChatroomIfPossible() {
        guard let username = usernameTextField.text?.blankSpaceTrimmed, username.isEmpty == false,
            let portStr = portNumberTextfield.text?.blankSpaceTrimmed, portStr.isEmpty == false, let port = UInt(portStr),
            let ip = ipAddressTextfield.text?.blankSpaceTrimmed, ip.isEmpty == false
            else { return }
        pushChatScreenViewController(username: username, host: ip, port: port)
        usernameTextField.text = nil
    }
    
    private func pushChatScreenViewController(username: String, host: String, port: UInt) {
        let transportClient = TransportClientFactory.client(host: host, port: port)
        let chatService = ChatService(transportClient: transportClient)
        let chatScreenViewController: ChatScreenViewController = ChatScreenViewController.load(withUsername: username, and: chatService)
        navigationController?.pushViewController(chatScreenViewController, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension StartScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        joinChatroomIfPossible()
        return true
    }
}
