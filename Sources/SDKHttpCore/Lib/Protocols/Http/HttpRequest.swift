//
// HttpRequest.swift
//
// Created by Raul Max on 27/06/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public protocol HttpRequest: AnyObject {
  func request(
    params: HttpParams,
    completion: @escaping (Result<HttpResponse<Data>, HttpError>) -> Void
  )
  func request<R: Decodable>(
    params: HttpParams,
    completion: @escaping (Result<HttpResponse<R>, HttpError>) -> Void
  )
}
