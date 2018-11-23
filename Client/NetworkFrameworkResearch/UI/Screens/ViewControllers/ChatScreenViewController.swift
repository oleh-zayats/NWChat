//
//  ChatScreenViewController.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

final class ChatScreenViewController: KeyboardAppearanceHandlingVC, OSLogProviding {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTFBottomLayoutConstraint: NSLayoutConstraint!

    private var messages: [ChatMessage] = []
    
    // MARK: - Injected
    var username: String!
    var chatService: ChatService!
    
    // MARK: - Overrides
    override var reactingConstraint: NSLayoutConstraint? {
        return messageTFBottomLayoutConstraint
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitle("Hi, \(username!)!")
        setupBackBarButtonItem()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatService.enterChat(withUsername: username)
        
        chatService.didReceiveChatMessage = { [weak self] message in
            self?.insert(message: message)
        }
        chatService.didReceivePlainText = { [weak self] text in
            let infoMessage = ChatMessage(text: text, author: String(), date: Date())
            self?.insert(message: infoMessage)
        }
        chatService.didEmitError = { _ in
            // handle error?
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func sendButtonDidTouchUpInside(_ sender: UIButton) {
        guard let text = messageTextField.text?.blankSpaceTrimmed, text.isEmpty == false else { return }
        chatService.sendText(text)
        insert(message: ChatMessage(text: text, author: username, date: Date()))
        Log.shared.debug(log, value: .string(text))
        messageTextField.text = nil
    }
    
    // MARK: - Private
    
    private func setupBackBarButtonItem() {
        let action = #selector(ChatScreenViewController.handleCloseChat)
        let backButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-close"), style: .plain, target: self, action: action)
        navigationItem.setLeftBarButton(backButtonItem, animated: false)
    }
    
    @objc private func handleCloseChat() {
        chatService.leaveChat()
        navigationController?.popViewController(animated: true)
    }
    
    func insert(message: ChatMessage) {
        messages.append(message)
        let row = messages.count - 1
        let indexPath = IndexPath(row: row, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ChatScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatMessageTableViewCell(style: .default, reuseIdentifier: "ChatMessageTableViewCell")
        return cell.configured(with: messages[indexPath.row], username: username)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}

// MARK: - UITableViewDelegate
extension ChatScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ChatMessageTableViewCell.height(for: messages[indexPath.row], username: username)
    }
}

// MARK: - Convenience
extension ChatScreenViewController {
    static func load(withUsername username: String, and chatService: ChatService) -> ChatScreenViewController {
        let chatScreenViewController: ChatScreenViewController = ChatScreenViewController.loadFromSB()
        chatScreenViewController.chatService = chatService
        chatScreenViewController.username = username
        return chatScreenViewController
    }
}
