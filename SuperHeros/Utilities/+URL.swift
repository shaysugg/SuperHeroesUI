//
//  +URL.swift
//  SuperHeros
//
//  Created by Sha Yan on 10/4/20.
//

import Foundation

extension URL {
    init?(apiURLWithSubPath: String) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "superheroapi.com"
        components.path = "/api/2650102048374377" + apiURLWithSubPath
        
        if let validURL = components.url { self = validURL }
        else { return nil }
    }
}
