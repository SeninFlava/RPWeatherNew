//
//  TabBarController.swift
//  RPWeather
//
//  Created by Alexander Senin on 06.10.2021.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.setImage(UIImage(named: "round"), for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(handleTouchTabbarCenter), for: .touchUpInside)

        tabBar.addSubview(button)
        tabBar.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        tabBar.topAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        // Do any additional setup after loading the view.
    }
    
    @objc func handleTouchTabbarCenter(sender : UIButton)
    {
        self.selectedViewController = self.viewControllers?[0]
      /*
       if let count = self.tabBar.items?.count
       {
           let i = floor(Double(count / 2))
           self.selectedViewController = self.viewControllers?[Int(i)]
       }
       */
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
