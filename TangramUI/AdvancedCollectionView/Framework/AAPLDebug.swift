//
//  AAPLDebug.swift
//  TangramUI
//
//  Created by 黄伯驹 on 2017/12/10.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

let AAPLStringFromBOOL: (Bool) -> String = {
    return $0 ? "YES" : "NO"
}

let AAPLStringFromNSIndexPath: (IndexPath) -> String = { indexPath in
    let range = (0 ..< indexPath.count)

    return range.map { "\(indexPath[$0])" }.joined(separator: ",")
}

let AAPLStringFromNSIndexSet: (IndexSet) -> String = { indexSet in
    
    print(indexSet)
//    var result: [String] = []
//    for range in indexSet {
//        switch range.length {
//        case 0:
//            result.append("empty")
//        case 1:
//            result.append("\(range.location)")
//        default:
//            [result addObject:[NSString stringWithFormat:@"%ld..%lu", (unsigned long)range.location, (unsigned long)(range.location + range.length - 1)]];
//            break;
//        }
//    }
    
    return ""
}
