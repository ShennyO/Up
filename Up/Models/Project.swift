//
//  Project.swift
//  Up
//
//  Created by Sunny Ouyang on 4/3/19.
//

import Foundation

class Project {
    
    var description: String
    
    init(description: String) {

        self.description = description
    }
    
    
}

class timedProject: Project {
    
    var time: String
    init(description: String, time: String) {
        self.time = time
        super.init(description: description)
    }
    
}
