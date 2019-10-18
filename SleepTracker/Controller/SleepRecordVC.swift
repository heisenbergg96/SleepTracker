//
//  SleepRecordVC.swift
//  dummy
//
//  Created by Vikhyath on 20/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit

class SleepRecordVC: BaseVC {
    
    @IBOutlet weak var sleepRecordTable: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var normalSleepLabel: UILabel!
    @IBOutlet weak var disturbedSleepLabel: UILabel!
    @IBOutlet weak var phoneCallDurationLabel: UILabel!
    @IBOutlet weak var barProgressView: BarProgressView!
    @IBOutlet weak var placeHolder1: UILabel!
    @IBOutlet weak var placeHolder2: UILabel!
    @IBOutlet weak var barGraphView: BarGraphView!
    
    var dataSource = [Section]()
    let coredataManager = CoreDataManager()
    var currentSection = -1
    var isExpanded: Bool = false
    var ratio = [CGFloat]()
    var maxWidth = UIScreen.main.bounds.width - 40
  
    override func viewDidLoad() {
        super.viewDidLoad()
        populateDataSource()
        placeHolder1.isHidden = !dataSource.isEmpty
        placeHolder2.isHidden = !dataSource.isEmpty
        updateUIWithRecentSleep()
    }
    
    func updateUIWithRecentSleep() {
        
        var disturbedSleep = 0
        var normalSleep = 0
        var phoneCallDuration = 0
        
        if dataSource.count > 0 {
            dataSource[0].rows.forEach { (session) in
                
                disturbedSleep += session.disturbedSleep
                normalSleep += (session.endTime - session.startTime - session.phoneCallDuration - session.disturbedSleep)
                phoneCallDuration += (session.phoneCallDuration)
            }
            normalSleepLabel.text = "\(normalSleep.getHourMinuteSecond())"
            disturbedSleepLabel.text = "\(disturbedSleep.getHourMinuteSecond())"
            phoneCallDurationLabel.text = "\(phoneCallDuration.getHourMinuteSecond())"
        }
        
    }
    
    fileprivate func populateDataSource() {
        
        coredataManager.fetchData { (sleepData, graphData) in
            
            dataSource = sleepData
            barGraphView.data = graphData
            dataSource.forEach { (section) in
                
                let max = section.rows.max(by: { (row1, row2) -> Bool in
                    return (row1.endTime - row1.startTime) < (row2.endTime - row2.startTime)
                })
                guard max != nil else { return }
                if let unwrappedMax = max {
                    ratio.append(maxWidth/CGFloat(unwrappedMax.endTime - unwrappedMax.startTime))
                }
            }
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SleepRecordVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (section == currentSection) ? dataSource[section].rows.count : 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SleepCell", for: indexPath) as? SleepCell else {
            return UICollectionViewCell()
        }
        let data = dataSource[indexPath.section].rows[indexPath.row]
        cell.startTime.text = Double(dataSource[indexPath.section].rows[indexPath.row].startTime).getReadableDate(type: .time)
        cell.endTime.text = Double(dataSource[indexPath.section].rows[indexPath.row].endTime).getReadableDate(type: .time)
        cell.imageViewWidthAnchor.constant = CGFloat((data.endTime - data.startTime)) * ratio[indexPath.section]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SleepRecordHeader", for: indexPath) as? SleepRecordHeader else { return UICollectionReusableView() }
        header.totalSleepHourLabel.text = "8:39"
        header.openCloseButton.tag = indexPath.section
        header.date.text = Double(dataSource[indexPath.section].date).getReadableDate(type: .date)
        header.totalSleepHourLabel.text = dataSource[indexPath.section].totalSleepDuration.getHourMinuteSecond()
        header.openCloseButton.addTarget(self, action: #selector(handleOpenClose), for: .touchUpInside)
        header.openCloseButton.isSelected = (indexPath.section == currentSection)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = dataSource[indexPath.section].rows[indexPath.row]
        normalSleepLabel.text = "\(data.totalSleep.getHourMinuteSecond())"
        disturbedSleepLabel.text = "\(data.disturbedSleep.getHourMinuteSecond())"
        phoneCallDurationLabel.text = "\(data.phoneCallDuration.getHourMinuteSecond())"
    }
    
    @objc func handleOpenClose(button: UIButton) {
        
        let section = button.tag
        button.isSelected = !button.isSelected
        currentSection = button.isSelected ? section : -1
        UIView.animate(withDuration: 3) {
            DispatchQueue.main.async {
                self.sleepRecordTable.reloadData()
            }
        }
        
        if currentSection == -1 {
            updateUIWithRecentSleep()
        }
    }
}

