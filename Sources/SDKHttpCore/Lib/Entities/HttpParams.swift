//
// HttpParams.swift
//
// Created by Raul Max on 27/06/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public struct HttpParams<T: Encodable> {
  public var headers: [String: String]?
  public var method: HttpMethod
  public var body: T?
}
