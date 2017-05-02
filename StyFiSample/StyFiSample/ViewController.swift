//
//  ViewController.swift
//  StyFiSample
//
//  Created by SunilMaurya on 01/05/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Outlets
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    lazy var onboardingImageView = UIImageView(image: UIImage(named: "onboardingImage"))
    
    //constants
    let screenWidth         = UIScreen.main.bounds.size.width
    let screenHeight        = UIScreen.main.bounds.size.height
    let finalRotationAngle:CGFloat = 5.3 //5.3×180°/π = 303.66763142° (radian to degree)
    
    //variables
    var onboardingDataArray = [[String:String]]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataInit()
        setupOnboardingImageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Helper Method
    fileprivate func dataInit() {
        onboardingDataArray = [["title":"", "subtitle":"Your shopping companion"],["title":"Curated", "subtitle":"A wide range of products curated by professional stylists only for you."],["title":"Personalised", "subtitle":"We’ll personalize your feed based on your wishlist."],["title":"All in one platform", "subtitle":"300+ Brands and 50+ websites to shop from."]]
        onboardingCollectionView.reloadData()
    }
    
    fileprivate func setupOnboardingImageView() {
        onboardingImageView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth*2, height: screenWidth*2)
        self.view.addSubview(onboardingImageView)
        self.view.insertSubview(onboardingImageView, at: 0)
        onboardingImageView.center = CGPoint(x: screenWidth, y: screenHeight)
    }
}

//MARK:- Collection View Implementation
extension ViewController:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingDataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionCell", for: indexPath) as? OnboardingCollectionCell else {
            fatalError("OnBoardingCollectionCell not found.")
        }
        if indexPath.item == 0 {
            cell.titleImageView.isHidden = false
            cell.titleLabel.isHidden = true
        } else {
            cell.titleImageView.isHidden = true
            cell.titleLabel.isHidden = false
        }
        cell.titleLabel.text = onboardingDataArray[indexPath.item]["title"]
        cell.subTitleLabel.text = onboardingDataArray[indexPath.item]["subtitle"]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

//MARK:- ScrollView Delegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //image rotation
        let angle = -scrollView.contentOffset.x * finalRotationAngle / screenWidth / CGFloat(onboardingDataArray.count - 1)
        onboardingImageView.transform = CGAffineTransform(rotationAngle: angle)
        
        //bottom view show/hide with animation
        let pageNumber = Int(round(scrollView.contentOffset.x / screenWidth))
        var finalAlpha:CGFloat = 0
        var willAnimate = false
        if pageNumber >= onboardingDataArray.count - 1 {
            finalAlpha = 1
        }
        if self.bottomView.alpha != finalAlpha {
            willAnimate = true
        }
        if willAnimate {
            showHideBottomViewWithAnimation(finalAlpha: finalAlpha)
        }
    }
    
    //MARK:- Helper Method
    fileprivate func showHideBottomViewWithAnimation(finalAlpha:CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.bottomView.alpha = finalAlpha
        }, completion: nil)
    }
}

//MARK:- Onboarding Collection View Cell
class OnboardingCollectionCell: UICollectionViewCell {
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
}
 
