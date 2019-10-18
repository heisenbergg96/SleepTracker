//
//  BarGraph.swift
//  dummy
//
//  Created by Vikhyath on 22/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit

@IBDesignable
class BarGraphView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var data: [CGFloat] = [100, 20, 50, 100, 200, 300, 74, 237, 20, 50, 100, 200, 300, 74, 237, 50, 100, 200, 300, 74, 237, 20, 100, 20, 50, 100, 200, 300, 74, 237, 20]
    
    var displayView: UIView = {
        
        var view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.backgroundColor = .white
        return view
        
    }()
    
    func maxValue() -> CGFloat {
        
        guard let max = data.max() else {
            return 1
        }
        return max
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GraphCell", for: indexPath) as? GraphCell else {
            return UICollectionViewCell()
        }
        cell.barValue.text = "\(Int(data[indexPath.row]).getHourMinuteSecond())"
        let ratio = (frame.height - 20) / maxValue()
        //Length of each bar.
        cell.viewHeightAnchor.constant = data[indexPath.row] * ratio
        cell.barGraphView.tag = indexPath.row
        cell.barGraphView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleTap)))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 50, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    @objc func handleTap(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
//            addSubview(displayView)
            let location = gesture.location(in: self)
            displayView.frame = CGRect(x: location.x, y: 0, width: 70, height: 50)
            print("Started")
        } else if gesture.state == .ended {
            print("Ended")
            displayView.removeFromSuperview()
        }
    }
}
