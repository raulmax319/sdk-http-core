//
// HttpParams.swift
//
// Created by Raul Max on 27/06/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public struct HttpParams {
  public var headers: [String: String]?
  public var method: HttpMethod
  public var body: Data?

  public init(
    headers: [String : String]? = nil,
    method: HttpMethod = .GET,
    body: Data? = nil
  ) {
    self.headers = headers
    self.method = method
    self.body = body
  }
}
