//
//  BoxOfficeCell.swift
//  H_BoxOfficeTest
//
//  Created by LEEJINWOO on 2/26/24.
//

import UIKit

class BoxOfficeCell: UITableViewCell {

    @IBOutlet weak var lbRank: UILabel!
    
    @IBOutlet weak var lbRankOldAndNew: UILabel!
    @IBOutlet weak var lbRankInten: UILabel!
    
    @IBOutlet weak var lbMovieNm: UILabel!
    
    @IBOutlet weak var lbOpenDt: UILabel!
    @IBOutlet weak var lbAudiCnt: UILabel!
    @IBOutlet weak var lbAudiInten: UILabel!
    @IBOutlet weak var lbAudiAcc: UILabel!
    
    
    static let identifier: String = "BoxOfficeCell"
    
    static func register() -> UINib {
        return UINib(nibName: "BoxOfficeCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpCell(weeklyBoxOfficeList: WeeklyBoxOfficeList) {
        // 해당일자의 박스오피스 순위
        lbRank.text = weeklyBoxOfficeList.rank
        
        // 랭킹에 신규진입여부
        if weeklyBoxOfficeList.rankOldAndNew == "NEW" {
            lbRankOldAndNew.isHidden = false
            lbRankInten.isHidden = true
        } else {
            lbRankOldAndNew.isHidden = true
            lbRankInten.isHidden = false
        }
        
        // 전일대비 순위의 증감분
        let rankInten = Int(weeklyBoxOfficeList.rankInten)!
        if rankInten > 0 {
            lbRankInten.text = "(+\(weeklyBoxOfficeList.rankInten))"
            lbRankInten.textColor = .red
        } else if rankInten < 0 {
            lbRankInten.text = "(\(weeklyBoxOfficeList.rankInten))"
            lbRankInten.textColor = .blue
        } else {
            lbRankInten.text = "(-)"
            lbRankInten.textColor = .black
        }
        
        // 영화제목
        lbMovieNm.text = weeklyBoxOfficeList.movieNm
        
        // 개봉일
        lbOpenDt.text = weeklyBoxOfficeList.openDt
        
        // 관객수
        lbAudiCnt.text = weeklyBoxOfficeList.audiCnt.comma()
        
        // 관객수증감(전주대비)
        lbAudiInten.text = weeklyBoxOfficeList.audiInten.comma() + "\n" + "(\(weeklyBoxOfficeList.salesChange)%)"
        
        // 누적관객수
        lbAudiAcc.text = weeklyBoxOfficeList.audiAcc.comma()
    }
}
