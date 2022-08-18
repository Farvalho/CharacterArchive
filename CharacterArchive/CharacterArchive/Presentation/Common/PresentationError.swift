//
//  PresentationError.swift
//  CharacterArchive
//
//  Created by Fábio Carvalho on 18/08/2022.
//

import Foundation

enum PresentationErrorType: Error {
    case None
    case Inline
    case Alert
    case FatalAlert
}

struct PresentationError {
    var style: PresentationErrorType
    var message: String
    var popup: Bool
    
    init() {
        self.style = .None
        self.message = ""
        self.popup = false
    }
    
    init(_ message: String, style: PresentationErrorType) {
        self.message = message
        self.style = style
        
        if self.style == .Alert || self.style == .FatalAlert {
            self.popup = true
            
        } else {
            self.popup = false
        }
    }
    
    mutating func solve() {
        style = .None
        message = ""
        popup = false
    }
}
