//
//  Country.swift
//  Beyes
//
//  Created by Alex Popa on 26/04/24.
//

import Foundation

struct Country: Hashable, Equatable, Identifiable {
    var id: String
    var name: String
    var image: String?
}
