//
//  MovieViewController.swift
//  H_BoxOfficeTest
//
//  Created by LEEJINWOO on 2/26/24.
//

import UIKit

class MovieViewController: UIViewController {
    var movieCd: String = ""
    
    var viewModel: MovieViewModel = MovieViewModel()
    
    @IBOutlet weak var vLoadingIndicator: UIView!
    
    // 영화 제목
    @IBOutlet weak var lbMovieNm: UILabel!
    // 영화 제목 영문
    @IBOutlet weak var lbMovieNmEn: UILabel!
    // 코드
    @IBOutlet weak var lbMovieCd: UILabel!
    // 영화유형
    @IBOutlet weak var lbTypeNm: UILabel!
    // 장르
    @IBOutlet weak var lbGenreNm: UILabel!
    // 상영시간
    @IBOutlet weak var lbShowTm: UILabel!
    // 관람등급
    @IBOutlet weak var lbWatchGradeNm: UILabel!
    // 제작국가
    @IBOutlet weak var lbNationNm: UILabel!
    // 개봉일
    @IBOutlet weak var lbOpenDt: UILabel!
    // 감독
    @IBOutlet weak var lbDirectorsPeopleNm: UILabel!
    // 출연배우
    @IBOutlet weak var lbActorsPeopleNm: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        
        vLoadingIndicator.isHidden = false
        viewModel.getData(movieCd: movieCd)
    }
    
    func initView() {
        viewModel.delegate = self
    }
    
    @IBAction func touchUpIndie_BtnClose(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension MovieViewController: MovieViewModelDelegate {
    func didFinishNetwork() {
        DispatchQueue.main.async {
            self.vLoadingIndicator.isHidden = true
        }
    }
    
    func viewUIUpdate(_ viewModel: MovieViewModel) {
        DispatchQueue.main.async {
            self.lbMovieNm.text = viewModel.getMovieNm()
            
            self.lbMovieNmEn.text = viewModel.getMovieNmEn()
            
            self.lbMovieCd.text = viewModel.getMovieCd()
            
            self.lbTypeNm.text = viewModel.getTypeNm()
            
            self.lbGenreNm.text = viewModel.getGenreNm()
            
            self.lbShowTm.text = viewModel.getShowTm()
            
            self.lbWatchGradeNm.text = viewModel.getWatchGradeNm()
            
            self.lbNationNm.text = viewModel.getNationNm()
            
            self.lbOpenDt.text = viewModel.getOpenDt()
            
            self.lbDirectorsPeopleNm.text = viewModel.getDirectorsPeopleNm()
            
            self.lbActorsPeopleNm.text = viewModel.getActorsPeopleNm()
        }
    }
}
