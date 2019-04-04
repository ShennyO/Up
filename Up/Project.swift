//
//  Project.swift
//  Up
//
//  Created by Sunny Ouyang on 4/3/19.
//

import Foundation

class Project {
    
    var title: String
    var description: String?
    var time: String?
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    init(title: String, description: String, time: String) {
        self.title = title
        self.description = description
        self.time = time
    }
    
}
