//
//  MainTabBarController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 4/4/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    var selectedTabIndicatorImage: UIImageView!
    
    override func viewDidLoad() {
        self.delegate = self as? UITabBarControllerDelegate
        
        super.viewDidLoad()
        
        addSelectedTabIndicator()
        updateIndicatorPosition(index: 0)
    }
    
    private func addSelectedTabIndicator() {
        selectedTabIndicatorImage = UIImageView(image: #imageLiteral(resourceName: "icTabbarSelected"))
        selectedTabIndicatorImage.translatesAutoresizingMaskIntoConstraints = true
        selectedTabIndicatorImage.center = CGPoint(x: 0, y: view.bounds.maxY - 10)
        selectedTabIndicatorImage.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        self.view.addSubview(selectedTabIndicatorImage)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.index(of: item) else { return }
        updateIndicatorPosition(index: index)
    }
    
    private func updateIndicatorPosition(index: Int) {
        let count = 5
        let width = CGFloat(self.view.frame.width) / CGFloat(count)
        let posX = width * CGFloat(index) + CGFloat(width/2)
        selectedTabIndicatorImage.center.x = CGFloat(posX)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
