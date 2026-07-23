//
//  DSRatingConfig.swift
//  UISystem
//
//  Created by Eyhciurmrn Zmpodackrl on 7/22/26.
//

public struct DSRatingConfig {
  public static func getIntegerRating(from rating: Double) -> Int {
    switch rating {
    case 4...4.5: return 4
    case 4.5...: return 5
    case 3..<4: return 3
    case 2..<3: return 2
    default: return 1
    }
  }
}
