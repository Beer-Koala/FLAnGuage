//
//  String+Extension.swift
//  FLAnGuage
//
//  Created by Beer Koala on 09.02.2023.
//

import Foundation

extension String {

    public var hasValue: Bool {
        !self.isEmpty
    }

    public static var empty: String { "" }
    
}
