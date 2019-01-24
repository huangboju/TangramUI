//
//  Inspiration.swift
//  ExpandingCollectionView
//
//  Created by Vamshi Krishna on 30/04/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import Foundation
import UIKit

class Inspiration: Session {
    class func allInspirations() -> [Inspiration] {
        var inspirations = [Inspiration]()
        guard let URL = Bundle.main.url(forResource: "Inspirations", withExtension: "plist") else {
            return inspirations
        }
        guard let tutorialsFromPlist = NSArray(contentsOf: URL) as? [[String: Any]] else {
            return inspirations
        }
        for dictionary in tutorialsFromPlist {
            let inspiration = Inspiration(dictionary: dictionary)
            inspirations.append(inspiration)
        }
        return inspirations
    }

}
