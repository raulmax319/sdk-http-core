//
// NetworkSessionManagerSpec.swift
//
// Created by Raul Max on 29/06/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation
import XCTest
@testable import SDKHttpCore

final class NetworkSessionManagerSpec: XCTestCase {
  var expectation: XCTestExpectation!
  var request: URLRequest!
  var sut: NetworkSessionManager!

  override func setUp() {
    super.setUp()

    expectation = expectation(description: "Did call backend")

    let configuration: URLSessionConfiguration = .default
    configuration.protocolClasses = [URLProtocolMock.self]
    sut = NetworkSessionManager(configuration: configuration)
    request = URLRequest(url: URL(string: "https://localmock:443")!)
  }

  override func tearDown() {
    expectation = nil
    request = nil
    sut = nil

    super.tearDown()
  }

  func testTaskWithValidData() {
    let genericJsonData = "{ \"some\": \"value\" }"
    URLProtocolMock.requestHandler = { request in
      guard let url = request.url else {
        throw URLError(.badURL)
      }

      let response = HTTPURLResponse(
        url: url,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      )!

      return (response, genericJsonData.data(using: .utf8))
    }

    sut.data(with: request) { data, _, error in
      guard let data, error == nil else {
        XCTFail("Expected a success but got an Error instead.")
        return
      }

      XCTAssert(String(data: data, encoding: .utf8) == genericJsonData)
      self.expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1.0)
  }

  func testTaskWithError() {
    let urlerr = URLError(.cannotDecodeRawData)
    URLProtocolMock.requestHandler = { _ in
      throw urlerr
    }

    sut.data(with: request) { _, _, error in
      XCTAssert(
        error?.localizedDescription == urlerr.localizedDescription,
        "\(String(describing: error))\n is not equal to\n \(urlerr)"
      )
      self.expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1.0)
  }
}
