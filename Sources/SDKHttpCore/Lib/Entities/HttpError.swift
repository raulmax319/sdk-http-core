//
// HttpError.swift
//
// Created by Raul Max on 27/06/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public struct HttpError: Error {
  var error: Error?
  public var message: String {
    return """
    DataTask failed with the following error: \(String(describing: error))
    at line: \(#line)
    in method: \(#function)
    of file: \(#fileID)
    """
  }

  init(with error: Error? = nil) {
    self.error = error
  }
}
