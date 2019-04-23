//
//  Project.swift
//  Up
//
//  Created by Sunny Ouyang on 4/3/19.
//

import Foundation

class Project {
    
    var description: String
    var completion: Bool
    
    init(description: String, completion: Bool) {
        self.completion = completion
        self.description = description
    }
    
    
}

class TimedProject: Project {
    
    var time: Int
    init(description: String, completion: Bool, time: Int) {
        self.time = time
        super.init(description: description, completion: completion)
    }
    
}
