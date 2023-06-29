//
// NetworkSessionManagerMock.swift
//
// Created by Raul Max on 29/06/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation
@testable import SDKHttpCore

final class NetworkSessionManagerMock: SessionManager {
  var shouldCompleteWithSuccess: Bool = false
  var mockedResponse: (Data?, HTTPURLResponse?, Error?)?

  private func mockResponse(completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
    guard let mockedResponse else {
      fatalError("Response cannot be nil.")
    }

    completion(mockedResponse.0, mockedResponse.1, mockedResponse.2)
  }

  func data(
    with request: URLRequest,
    completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void
  ) {
    mockResponse(completion: completion)
  }
}
