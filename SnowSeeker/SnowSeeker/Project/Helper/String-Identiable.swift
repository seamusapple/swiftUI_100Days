//
//  String-Identiable.swift
//  SnowSeeker
//
//  Created by Ramsey on 2020/7/19.
//  Copyright © 2020 Ramsey. All rights reserved.
//

import Foundation

extension String: Identifiable {
    public var id: String { self }
}
