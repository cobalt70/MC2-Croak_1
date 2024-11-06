//
//  DailyStat.swift
//  Croak
//
//  Created by Giwoo Kim on 5/27/24.
//

import Foundation
import SwiftData

@Model
class DailyStat{
 
    
    var id: UUID
    var date : String

    var numberOfWarnings: Int
    var numberOfFix: Int
    var numberOfSit : Int
    var numberOfLeftLie : Int
    var numberOfRightLie : Int
   
    
    init(date: String, numberOfWarnings: Int, numberOfFix: Int , numberOfSit :Int, numberOfLeftLie : Int, numberOfRightLie : Int)  {
        self.id = UUID()
        self.date = date
        self.numberOfWarnings = numberOfWarnings
        self.numberOfFix = numberOfFix
        
        self.numberOfSit = numberOfSit
        self.numberOfLeftLie = numberOfLeftLie
        self.numberOfRightLie = numberOfRightLie
       
    }
}
