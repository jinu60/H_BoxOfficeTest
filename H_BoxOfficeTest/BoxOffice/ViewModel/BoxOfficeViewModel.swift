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
        guard let showRange = boxOffice?.boxOfficeResult.showRange, let yearWeekTime = boxOffice?.boxOfficeResult.yearWeekTime else {
            return ""
        }
        
        let weekTime = DateHelper.convertDateStringFormat(dateString: yearWeekTime, dateFormat: "yyyyMM", convertDateFormat: "MM주차")
        
        let range = DateHelper.convertDateStringFormat(dateString: showRange, dateFormat: "yyyyMMdd~yyyyMMdd", convertDateFormat: "yyyy년 MM월 dd일 ~ yyyy년 MM월 dd일")
        
        return weekTime + "(" + range + ")"
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
