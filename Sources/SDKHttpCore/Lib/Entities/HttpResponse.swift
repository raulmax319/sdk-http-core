//
// HttpResponse.swift
//
// Created by Raul Max on 27/06/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public struct HttpResponse<T: Decodable>: Decodable {
  public var data: T?
  public var statusCode: HttpStatusCode
}
