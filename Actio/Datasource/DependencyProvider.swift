//
//  DependencyProvider.swift
//  Actio
//
//  Created by Arun Eswaramurthi on 08/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

class DependencyProvider {
    static let shared = DependencyProvider()
    
	let networkService = NetworkService.shared
    let registerDatasource = RegisterDatasource.shared
}
