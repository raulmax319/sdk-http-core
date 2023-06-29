//
// HttpRequest.swift
//
// Created by Raul Max on 27/06/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public protocol HttpRequest: AnyObject {
  func request<T: Encodable>(
    params: HttpParams<T>,
    completion: @escaping (Result<HttpResponse<Data>, HttpError>) -> Void
  )
  func request<T: Encodable, R: Decodable>(
    params: HttpParams<T>,
    completion: @escaping (Result<HttpResponse<R>, HttpError>) -> Void
  )
}
