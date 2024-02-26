//
//  StringHelper.swift
//  H_BoxOfficeTest
//
//  Created by LEEJINWOO on 2/26/24.
//

import Foundation

extension String {
    // String에 Comma찍기
    func comma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: Int(self) ?? 0) ?? "0"
    }
}
