//
//  BoxOfficeViewModel.swift
//  H_BoxOfficeTest
//
//  Created by LEEJINWOO on 2/26/24.
//

import Foundation

protocol BoxOfficeViewModelDelegate {
    func didFinishNetwork()
    func viewUIUpdate(_ viewModel: BoxOfficeViewModel)
}

class BoxOfficeViewModel {
    
    var delegate: BoxOfficeViewModelDelegate?
    
    var boxOffice: BoxOffice? {
        didSet {
            self.delegate?.viewUIUpdate(self)
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return getWeeklyBoxOfficeListCount()
    }
    
    func getData(targetDt: String, weekGb: String) {
        Network.getBoxOffice(targetDt: targetDt, weekGb: weekGb) { [weak self] result in
            
            self?.delegate?.didFinishNetwork()

            switch result {
            case .success(let data):
                self?.boxOffice = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getBoxofficeType() -> String {
        guard let boxofficeType = boxOffice?.boxOfficeResult.boxofficeType else {
            return ""
        }
        
        return boxofficeType
    }
    
    func getShowRange() -> String {
        guard let showRange = boxOffice?.boxOfficeResult.showRange, let yearWeekTime = boxOffice?.boxOfficeResult.yearWeekTime, yearWeekTime.count >= 2 else {
            return ""
        }
        
        let weekTime = yearWeekTime.suffix(2) + "주차"
        
        let range = showRange.split(separator: "~").map{ String($0) }
        
        let startRange = DateHelper.convertDateStringFormat(dateString: range[0], dateFormat: "yyyyMMdd", convertDateFormat: "yyyy년MM월dd일")
        let endRange = DateHelper.convertDateStringFormat(dateString: range[1], dateFormat: "yyyyMMdd", convertDateFormat: "yyyy년MM월dd일")
        
        return weekTime + "(" + startRange + "~" + endRange + ")"
    }
    
    func getWeeklyBoxOfficeList() -> [WeeklyBoxOfficeList] {
        guard let weeklyBoxOfficeList = boxOffice?.boxOfficeResult.weeklyBoxOfficeList else {
            return []
        }
        
        return weeklyBoxOfficeList
    }
    
    func getWeeklyBoxOfficeListCount() -> Int {
        return getWeeklyBoxOfficeList().count
    }
}
