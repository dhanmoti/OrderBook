//
//  WebsocketService.swift
//  OrderBook
//
//  Created by Dhan Moti on 19/5/25.
//  Credit: https://github.com/appspector/URLSessionWebSocketTask/blob/master/WebSockets/WebSocketConnection.swift
//

import Foundation
import Combine

protocol WebSocketConnection: AnyObject {
    func send(text: String)
    func send(data: Data)
    func connect()
    func disconnect()
    func invalidateAndCancel()
    var delegate: WebSocketConnectionDelegate? {
        get
        set
    }
}

protocol WebSocketConnectionDelegate: AnyObject {
    func onConnected(connection: WebSocketConnection)
    func onDisconnected(connection: WebSocketConnection, error: Error?)
    func onError(connection: WebSocketConnection, error: Error)
    func onMessage(connection: WebSocketConnection, text: String)
    func onMessage(connection: WebSocketConnection, data: Data)
}

class WebSocketTaskConnection: NSObject, WebSocketConnection, URLSessionWebSocketDelegate {
    weak var delegate: WebSocketConnectionDelegate?
    var webSocketTask: URLSessionWebSocketTask!
    var urlSession: URLSession!
    let delegateQueue = OperationQueue()
    
    init(url: URL) {
        super.init()
        delegateQueue.maxConcurrentOperationCount = 1
        delegateQueue.name = "com.devidhan.orderbook.delegateQueue"
        
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: delegateQueue)
        webSocketTask = urlSession.webSocketTask(with: url)
    }
    
    // Crucial: Deinit to break the retain cycle and clean up URLSession
    deinit {
        // Invalidate the URLSession to break the strong reference cycle
        // and allow all tasks to complete or be cancelled.
        urlSession.invalidateAndCancel()
    }
    
    func invalidateAndCancel() {
        urlSession.invalidateAndCancel()
    }

    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        self.delegate?.onConnected(connection: self)
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.delegate?.onDisconnected(connection: self, error: nil)
    }
    
    func connect() {
        webSocketTask.resume()
        
        listen()
    }
    
    func disconnect() {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }
    
    func listen()  {
        webSocketTask.receive { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .failure(let error):
                self.delegate?.onError(connection: self, error: error)
            case .success(let message):
                switch message {
                case .string(let text):
                    self.delegate?.onMessage(connection: self, text: text)
                case .data(let data):
                    self.delegate?.onMessage(connection: self, data: data)
                @unknown default:
                    fatalError()
                }
                
                self.listen()
            }
        }
    }
    
    func send(text: String) {
        webSocketTask.send(URLSessionWebSocketTask.Message.string(text)) { [weak self] error in
            guard let self else { return }
            if let error = error {
                self.delegate?.onError(connection: self, error: error)
            }
        }
    }
    
    func send(data: Data) {
        webSocketTask.send(URLSessionWebSocketTask.Message.data(data)) { [weak self] error in
            guard let self else { return }
            if let error = error {
                self.delegate?.onError(connection: self, error: error)
            }
        }
    }
}
