//
// NetworkSessionManager.swift
//
// Created by Raul Max on 27/06/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

final public class NetworkSessionManager: NSObject, SessionManager {
  private let configuration: URLSessionConfiguration
  private lazy var session: URLSession = {
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()

  public init(configuration: URLSessionConfiguration = .default) {
    self.configuration = configuration
  }
}

extension NetworkSessionManager {
  public func data(
    with request: URLRequest,
    completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void
  ) {
    let task = session.dataTask(with: request) { data, response, error in
      guard
        let data,
        let response = response as? HTTPURLResponse,
        error == nil
      else {
        completion(nil, nil, error)
        return
      }

      completion(data, response, nil)
    }

    task.resume()
  }
}

extension NetworkSessionManager: URLSessionDelegate {
  public func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
  ) {
    guard
      let trust = challenge.protectionSpace.serverTrust,
      SecTrustGetCertificateCount(trust) > 0
    else {
      completionHandler(.cancelAuthenticationChallenge, nil)
      return
    }

    if #available(iOS 15.0, *) {
      guard
        (SecTrustCopyCertificateChain(trust) as? [SecCertificate])?.first != nil
      else {
        completionHandler(.cancelAuthenticationChallenge, nil)
        return
      }
    } else {
      guard SecTrustGetCertificateAtIndex(trust, .zero) != nil else {
        completionHandler(.cancelAuthenticationChallenge, nil)
        return
      }
    }

    completionHandler(.useCredential, URLCredential(trust: trust))
  }
}
