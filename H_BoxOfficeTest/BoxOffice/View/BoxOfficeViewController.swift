//
//  MainViewController.swift
//  H_BoxOfficeTest
//
//  Created by LEEJINWOO on 2/26/24.
//

import UIKit

class BoxOfficeViewController: UIViewController {
    // 조회 날짜
    @IBOutlet weak var btnTargetDt: UIButton!
    // 주간/주말/주중 선택
    @IBOutlet weak var btnWeekGb: UIButton!
    
    @IBOutlet weak var lbBoxofficeType: UILabel!
    @IBOutlet weak var lbShowRange: UILabel!
    
    @IBOutlet weak var tvBoxOffice: UITableView!
    
    @IBOutlet weak var vLoadingIndicator: UIView!
    @IBOutlet weak var vNodata: UIView!
    
    var viewModel: BoxOfficeViewModel = BoxOfficeViewModel()
    
    var weekGb: String = "1"
    var targetDt: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        
        setUpTableView()
        
        vLoadingIndicator.isHidden = false
        vNodata.isHidden = true
        viewModel.getData(targetDt: DateHelper.getDate(date: targetDt, dateFormat: "yyyyMMdd"), weekGb: weekGb)
    }
    
    func initView() {
        // 가까운 지난 주말 날짜로 기본 세팅
        targetDt = DateHelper.getLastWeekDate()
        
        btnTargetDt.setTitle(DateHelper.getDate(date: targetDt, dateFormat: "yyyy-MM-dd"), for: .normal)
    }
    
    func setUpTableView() {
        
        viewModel.delegate = self
        
        tvBoxOffice.delegate = self
        tvBoxOffice.dataSource = self
        
        tvBoxOffice.register(BoxOfficeCell.register(), forCellReuseIdentifier: BoxOfficeCell.identifier)
    }
    
    func openMovieViewController(movieCd: String) {
        let movieViewController = MovieViewController()
        movieViewController.movieCd = movieCd
        self.present(movieViewController, animated: true)
    }
    
    @IBAction func touchUpInside_BtnTargetDt(_ sender: Any) {
        let datePicker = UIDatePicker()
        datePicker.date = targetDt
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        
        let actionSheet = UIAlertController(title: "조회날짜", message: nil, preferredStyle: .actionSheet)
        
        //취소 버튼 - 스타일(cancel)
        actionSheet.addAction(UIAlertAction(title: "선택", style: .destructive) { action in
            self.targetDt = datePicker.date
            self.btnTargetDt.setTitle(DateHelper.getDate(date: self.targetDt, dateFormat: "yyyy-MM-dd"), for: .normal)
        })
        
        let dateViewController = UIViewController()
        dateViewController.view = datePicker
                
        actionSheet.setValue(dateViewController, forKey: "contentViewController")
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func touchUpInside_BtnWeekGb(_ sender: Any) {
        let actionSheet = UIAlertController(title: "주간/주말/주중 선택", message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "주간 (월~일)", style: weekGb == "0" ? .destructive : .default) { action in
            self.weekGb = "0"
            self.btnWeekGb.setTitle(action.title, for: .normal)
        })
        
        actionSheet.addAction(UIAlertAction(title: "주말 (금~일)", style: weekGb == "1" ? .destructive : .default) { action in
            self.weekGb = "1"
            self.btnWeekGb.setTitle(action.title, for: .normal)
        })

        actionSheet.addAction(UIAlertAction(title: "주중 (월~목)", style: weekGb == "2" ? .destructive : .default) { action in
            self.weekGb = "2"
            self.btnWeekGb.setTitle(action.title, for: .normal)
        })
        
        //취소 버튼 - 스타일(cancel)
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func touchUpInside_BtnSearch(_ sender: Any) {
        vLoadingIndicator.isHidden = false
        vNodata.isHidden = true
        viewModel.getData(targetDt: DateHelper.getDate(date: targetDt, dateFormat: "yyyyMMdd"), weekGb: weekGb)
    }
}

extension BoxOfficeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoxOfficeCell.identifier, for: indexPath) as? BoxOfficeCell else {
            return UITableViewCell()
        }

        let weeklyBoxOfficeList = viewModel.getWeeklyBoxOfficeList()
        if weeklyBoxOfficeList.count > 0 {
            let weeklyBoxOffice = weeklyBoxOfficeList[indexPath.row]
            cell.setUpCell(weeklyBoxOfficeList: weeklyBoxOffice)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weeklyBoxOfficeList = viewModel.getWeeklyBoxOfficeList()
        let weeklyBoxOffice = weeklyBoxOfficeList[indexPath.row]
        
        let movieCd = weeklyBoxOffice.movieCd
        openMovieViewController(movieCd: movieCd)
    }
}

extension BoxOfficeViewController: BoxOfficeViewModelDelegate {
    func didFinishNetwork() {
        DispatchQueue.main.async {
            self.vLoadingIndicator.isHidden = true
        }
    }
    
    func viewUIUpdate(_ viewModel: BoxOfficeViewModel) {
        DispatchQueue.main.async {
            
            if viewModel.getWeeklyBoxOfficeListCount() > 0 {
                self.lbBoxofficeType.text = viewModel.getBoxofficeType()
                self.lbShowRange.text = viewModel.getShowRange()
                
                self.tvBoxOffice.setContentOffset(CGPoint.zero, animated: false)
                self.tvBoxOffice.reloadData()
            } else {
                self.vNodata.isHidden = false
            }
        }
    }
}
