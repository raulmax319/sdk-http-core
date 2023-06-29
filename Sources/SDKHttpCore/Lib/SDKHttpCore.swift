//
// SDKHttpCore.swift
//
// Created by Raul Max on 27/06/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

final public class SDKHttpCore: NSObject {
  private let url: URL
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private let manager: SessionManager
  private lazy var request: URLRequest = {
    return URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
  }()

  public init(with url: URL, manager: SessionManager = NetworkSessionManager()) {
    self.url = url
    self.manager = manager
  }

  private func setupRequest<T: Encodable>(with params: HttpParams<T>) {
    request.httpMethod = params.method.rawValue
    request.httpBody = try? encoder.encode(params.body)
    request.allHTTPHeaderFields = params.headers
  }
}

extension SDKHttpCore: HttpRequest {
  public func request<T: Encodable>(
    params: HttpParams<T>,
    completion: @escaping (Result<HttpResponse<Data>, HttpError>) -> Void
  ) {
    setupRequest(with: params)
    manager.data(with: request) { data, resp, error in
      guard let data, let status = resp?.statusCode, error == nil else {
        completion(.failure(HttpError(with: error)))
        return
      }

      completion(
        .success(
          HttpResponse(data: data, statusCode: HttpStatusCode(rawValue: status) ?? .ok)
        )
      )
    }
  }

  public func request<T: Encodable, R: Decodable>(
    params: HttpParams<T>,
    completion: @escaping (Result<HttpResponse<R>, HttpError>) -> Void
  ) {
    setupRequest(with: params)
    manager.data(with: request) { data, resp, err in
      guard let data, let status = resp?.statusCode, err == nil else {
        completion(.failure(HttpError(with: err)))
        return
      }

      do {
        let model = try self.decoder.decode(R.self, from: data)
        let responseModel = HttpResponse(
          data: model,
          statusCode: HttpStatusCode(rawValue: status) ?? .ok
        )
        completion(.success(responseModel))
      } catch {
        completion(.failure(HttpError(with: error)))
      }
    }
  }
}
