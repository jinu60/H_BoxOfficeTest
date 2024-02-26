//
//  MovieViewModel.swift
//  H_BoxOfficeTest
//
//  Created by LEEJINWOO on 2/26/24.
//

import Foundation

protocol MovieViewModelDelegate {
    func didFinishNetwork()
    func viewUIUpdate(_ viewModel: MovieViewModel)
}

class MovieViewModel {
    var delegate: MovieViewModelDelegate?
    
    var movie: Movie? {
        didSet {
            self.delegate?.viewUIUpdate(self)
        }
    }
    
    func getData(movieCd: String) {
        
        Network.getMoive(movieCd: movieCd) { [weak self] result in   
            self?.delegate?.didFinishNetwork()

            switch result {
            case .success(let data):
                self?.movie = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMovieNm() -> String {
        guard let movieNm = movie?.movieInfoResult.movieInfo.movieNm else {
            return ""
        }
        
        return movieNm
    }
    
    func getMovieNmEn() -> String {
        guard let movieNmEn = movie?.movieInfoResult.movieInfo.movieNmEn  else {
            return ""
        }
        
        return "(" + movieNmEn + ")"
    }
    
    func getMovieCd() -> String {
        guard let movieCd = movie?.movieInfoResult.movieInfo.movieCd  else {
            return ""
        }
        
        return movieCd
    }
    
    func getTypeNm() -> String {
        guard let typeNm = movie?.movieInfoResult.movieInfo.typeNm  else {
            return ""
        }
        
        return typeNm
    }
    
    func getGenreNm() -> String {
        guard let genres = movie?.movieInfoResult.movieInfo.genres  else {
            return ""
        }
        
        var genreNms: [String] = []
        genres.forEach { genre in
            genreNms.append(genre.genreNm)
        }
        
        return genreNms.joined(separator: "\n")
    }
    
    func getShowTm() -> String {
        guard let showTm = movie?.movieInfoResult.movieInfo.showTm  else {
            return ""
        }
        
        return showTm + "분"
    }
    
    func getWatchGradeNm() -> String {
        guard let audits = movie?.movieInfoResult.movieInfo.audits  else {
            return ""
        }

        var watchGradeNms: [String] = []
        audits.forEach { audit in
            watchGradeNms.append(audit.watchGradeNm)
        }

        return watchGradeNms.joined(separator: "\n")
    }
    
    func getNationNm() -> String {
        guard let nations = movie?.movieInfoResult.movieInfo.nations  else {
            return ""
        }
        
        var nationNms: [String] = []
        nations.forEach { nation in
            nationNms.append(nation.nationNm)
        }

        return nationNms.joined(separator: "\n")
    }
    
    func getOpenDt() -> String {
        guard let openDt = movie?.movieInfoResult.movieInfo.openDt  else {
            return ""
        }

        return DateHelper.convertDateStringFormat(dateString: openDt, dateFormat: "yyyyMMdd", convertDateFormat: "yyyy-MM-dd")
    }
    
    func getDirectorsPeopleNm() -> String {
        guard let directors = movie?.movieInfoResult.movieInfo.directors  else {
            return ""
        }
        
        var directorNms: [String] = []
        directors.forEach { director in
            directorNms.append(director.peopleNm)
        }

        return directorNms.joined(separator: "\n")
    }
    
    func getActorsPeopleNm() -> String {
        guard let actors = movie?.movieInfoResult.movieInfo.actors  else {
            return ""
        }

        var actorNms: [String] = []
        actors.forEach { actor in
            actorNms.append(actor.peopleNm)
        }
        
        return actorNms.joined(separator: "\n")
    }
}
