//
//  BoxOfficeResult.swift
//  H_BoxOfficeTest
//
//  Created by LEEJINWOO on 2/26/24.
//

import Foundation

struct BoxOfficeResult: Codable {
    let boxofficeType: String
    let showRange: String?
    let yearWeekTime: String?
    let weeklyBoxOfficeList: [WeeklyBoxOfficeList]
}
