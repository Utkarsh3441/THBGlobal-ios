//
//  Result.swift
//  Dot_Health_1
//
//  Created by Animesh Mohanty on 02/06/20.
//  Copyright © 2020 Animesh Mohanty. All rights reserved.
//
import Foundation

enum Result<T, E> where E: Error {
    case success(T)
    case failure(E)
}
