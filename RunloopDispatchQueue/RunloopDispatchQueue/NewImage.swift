//
//  NewImage.swift
//  RunloopDispatchQueue
//
//  Created by 안종표 on 2023/10/15.
//

import Foundation

struct NewImage: Decodable {
    enum CodingKeys: String, CodingKey {
        case url = "download_url"
    }
    
    let url: String
}
