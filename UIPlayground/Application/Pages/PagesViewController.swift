//
//  PagesViewController.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 10/30/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import UIKit
import os.log

class PagesViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    struct RestorationIdentifiers {
        static let pagerIdentifier = "pager"
    }
    
    var pageControllers: [UIViewController]!
    var pagesController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPager()
    }
    
    func initPager() {
        let storyboard = self.storyboard!
        pageControllers = [
            storyboard.instantiateViewController(withIdentifier: "A"),
            storyboard.instantiateViewController(withIdentifier: "B"),
            storyboard.instantiateViewController(withIdentifier: "C")
        ]
        
        for child in childViewControllers {
            if let pager = child as? UIPageViewController {
                if pager.restorationIdentifier == RestorationIdentifiers.pagerIdentifier {
                    pager.delegate = self
                    pager.dataSource = self
                    pager.setViewControllers([pageControllers[0]],
                                             direction: .forward,
                                             animated: true,
                                             completion: nil)
                    os_log("UI PAGE FOUND")
                }
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageControllers.index(of: viewController) else {
            return nil
        }
        let prev = index - 1
        guard prev >= 0 else {
            return nil
        }
        
        os_log("prev index: %d", prev)
        return pageControllers[prev]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageControllers.index(of: viewController) else {
            return nil
        }
        let next = index + 1
        guard next < pageControllers.count else {
            return nil
        }
        
        os_log("next index: %d", next)
        return pageControllers[next]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pager = segue.destination as? UIPageViewController {
            
        }
    }
    

}
