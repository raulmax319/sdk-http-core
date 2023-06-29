//
// SessionManager.swift
//
// Created by Raul Max on 29/06/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public protocol SessionManager: AnyObject {
  func data(
    with request: URLRequest,
    completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void
  )
}
