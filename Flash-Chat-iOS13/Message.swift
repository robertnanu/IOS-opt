//
//  Message.swift
//  Flash Chat iOS13
//
//  Created by Nanu Robert on 21.04.2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import Foundation

struct Message {
    let sender: String
    let body: String
}

class Messages: Codable {
    var id: String?
    var sender: String?
    var body: String?
}

class dbMessages: Codable {
    var id : Int = 1
    var sender : String?
    var body : String?
}
