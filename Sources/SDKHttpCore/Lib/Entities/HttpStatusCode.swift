//
// HttpStatusCode.swift
//
// Created by Raul Max on 27/06/23.
// Copyright © 2023 Raul Max. All rights reserved.
//

import Foundation

public enum HttpStatusCode: Int, Decodable {
  case ok = 200
  case unavailable = 1200
}
