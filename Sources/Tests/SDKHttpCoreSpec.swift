//
// SDKHttpCoreSpec.swift
//
// Created by Raul Max on 29/06/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation
import XCTest
@testable import SDKHttpCore

final class SDKHttpCoreSpec: XCTestCase {
  var expectation: XCTestExpectation!
  var url: URL!
  var manager: NetworkSessionManagerMock!
  var request: URLRequest!
  var sut: HttpRequest!

  struct MockExample: Codable, Equatable {
    var key: String
  }

  override func setUp() {
    super.setUp()

    expectation = expectation(description: "Did call backend")

    let configuration: URLSessionConfiguration = .default
    configuration.protocolClasses = [URLProtocolMock.self]
    url = URL(string: "https://localmock:443")
    manager = NetworkSessionManagerMock()
    sut = HttpCore(with: url, manager: manager)
    request = URLRequest(url: URL(string: "https://localmock:443")!)
  }

  override func tearDown() {
    expectation = nil
    request = nil
    sut = nil

    super.tearDown()
  }

  func testSuccessWithValidData() {
    let json = "{ \"key\": \"value\" }"
    let response = HTTPURLResponse(
      url: request.url!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )!
    manager.shouldCompleteWithSuccess = true
    manager.mockedResponse = (json.data(using: .utf8), response, nil)

    let params = HttpParams(
      method: .GET,
      body: try? JSONEncoder().encode(MockExample(key: "value"))
    )

    requestWithDataResult(params: params) { result in
      guard case let .success(response) = result else {
        XCTFail("Expected the task to be of success but got \(result) instead.")
        return
      }

      XCTAssert(
        String(data: response.data!, encoding: .utf8) == json
      )
      XCTAssert(response.statusCode == .ok)
      self.expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1.0)
  }

  func testFailureWithValidError() {
    let secondExpectation = expectation(description: "Did call backend in another task.")
    let urlErr = URLError(.badServerResponse)
    let response = HTTPURLResponse(
      url: request.url!,
      statusCode: 400,
      httpVersion: nil,
      headerFields: nil
    )!
    manager.mockedResponse = (nil, response, urlErr)

    let params = HttpParams(
      method: .GET,
      body: try? JSONEncoder().encode(MockExample(key: "value"))
    )

    requestWithDataResult(params: params) { result in
      guard case let .failure(failure) = result else {
        XCTFail("Expected the task to be of failure but got \(result) instead.")
        return
      }

      let httperr = HttpError(with: urlErr)
      XCTAssertTrue(
        failure.message == httperr.message,
        "\(failure)\n is not equal to\n \(httperr)"
      )

      self.expectation.fulfill()
    }

    requestWithDecodableResult(params: params) { result in
      guard case let .failure(failure) = result else {
        XCTFail("Expected the task to be of failure but got \(result) instead.")
        return
      }

      let httperr = HttpError(with: urlErr)
      XCTAssertTrue(
        failure.message == httperr.message,
        "\(failure)\n is not equal to\n \(httperr)"
      )

      secondExpectation.fulfill()
    }

    wait(for: [expectation, secondExpectation], timeout: 1.0)
  }

  func testSuccessWithValidModel() {
    let val = "testValue"
    let json = "{ \"key\": \"\(val)\" }"
    let response = HTTPURLResponse(
      url: request.url!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )!
    manager.shouldCompleteWithSuccess = true
    manager.mockedResponse = (json.data(using: .utf8), response, nil)

    let params = HttpParams(
      method: .GET,
      body: try? JSONEncoder().encode(MockExample(key: "123"))
    )

    requestWithDecodableResult(params: params) { result in
      guard case let .success(success) = result else {
        XCTFail("Expected the task to be of success but got \(result) instead.")
        return
      }

      XCTAssertTrue(success.data == MockExample(key: val))
      self.expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1.0)
  }

  func testFailureToDecodeModel() {
    let val = "Mock Title"
    let json = "{ \"title\": \"\(val)\" }"
    let response = HTTPURLResponse(
      url: request.url!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil
    )!
    manager.shouldCompleteWithSuccess = true
    manager.mockedResponse = (json.data(using: .utf8), response, nil)

    let mockResponse = HttpResponse(
      data: MockExample(key: "Test Value"),
      statusCode: .ok
    )

    let params = HttpParams(
      method: .GET,
      body: try? JSONEncoder().encode(MockExample(key: "value"))
    )

    requestWithDecodableResult(params: params) { result in
      guard case let .failure(failure) = result else {
        XCTFail("Expected the task to be of failure but got \(result) instead.")
        return
      }

      XCTAssertTrue(failure.error is DecodingError)
      self.expectation.fulfill()
    }

    wait(for: [expectation], timeout: 1.0)
  }
}

extension SDKHttpCoreSpec {
  func requestWithDataResult(
    params: HttpParams,
    completion: @escaping (Result<HttpResponse<Data>, HttpError>) -> Void
  ) {
    sut.request(params: params, completion: completion)
  }

  func requestWithDecodableResult(
    params: HttpParams,
    completion: @escaping (Result<HttpResponse<MockExample>, HttpError>) -> Void
  ) {
    sut.request(params: params, completion: completion)
  }
}
