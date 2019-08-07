//
//  SegmentedViewController.swift
//  GRDB_Test
//
//  Created by Nazar on 8/7/19.
//  Copyright © 2019 ios.dev. All rights reserved.
//

import Foundation
import UIKit

class SegmentedViewController: UIViewController {
    
    var initiallySelectedIndex = 0
    fileprivate(set) var selectedViewControllerIndex = 0
    
    var segmentedControl = UISegmentedControl()
    var currentControllerContainerView = UIView()
    
    fileprivate var segmentedBackgroundView = UIView()
    
    fileprivate var controllers = [[String: UIViewController]]()
    
    fileprivate var commonSearchTerm = String()
    
    
    init(titlesAndControllers dict: [[String: UIViewController]]) {
        super.init(nibName: nil, bundle: nil)
        controllers = dict
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectViewController(atIndex index: Int) {
        segmentedControl.selectedSegmentIndex = index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.loadSegmentedControl()
            self.loadInitialViewController()
        }
    }
    
    fileprivate func setupViews() {
        segmentedBackgroundView.backgroundColor = UINavigationBar.appearance().barTintColor
        view.addSubview(segmentedBackgroundView)
        view.addSubview(currentControllerContainerView)
        
        segmentedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        currentControllerContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let hBackgoundViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[sb]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["sb" : segmentedBackgroundView])
        
        
        let hContainerConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[container]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["container" : currentControllerContainerView])
        
        if #available(iOS 11.0, *) {
            let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(66+(UIApplication.shared.keyWindow?.safeAreaInsets.top)!)-[sb(30)]-0-[container]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["sb": segmentedBackgroundView, "container" : currentControllerContainerView])
            view.addConstraints(hBackgoundViewConstraints + hContainerConstraints + vConstraints)
        }else {
            let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-66-[sb(30)]-0-[container]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["sb": segmentedBackgroundView, "container" : currentControllerContainerView])
            view.addConstraints(hBackgoundViewConstraints + hContainerConstraints + vConstraints)
        }
        
        segmentedBackgroundView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedBackgroundView.clipsToBounds = false
        
        let hConstraintsSegment = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[segment]-20-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["segment": segmentedControl])
        
        let vConstraintsSegment = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[segment]-4-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["segment": segmentedControl])
        
        segmentedBackgroundView.addConstraints(hConstraintsSegment + vConstraintsSegment)
        segmentedControl.addTarget(self, action: #selector(SegmentedViewController.didChangeValueOfSegment(_:)), for: .valueChanged)
    }
    
    @objc func didChangeValueOfSegment(_ segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == selectedViewControllerIndex {
            return
        }
        
        let controller = controllers[segmentedControl.selectedSegmentIndex].first!.value
        
        let prevController = controllers[selectedViewControllerIndex].first!.value
        
        prevController.willMove(toParent: nil)
        prevController.removeFromParent()
        prevController.view.removeFromSuperview()
        
        controller.willMove(toParent: self)
        addChild(controller)
        currentControllerContainerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        let hConstraintsSegment = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[controller]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["controller": controller.view])
        
        let vConstraintsSegment = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[controller]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["controller": controller.view])
        
        currentControllerContainerView.addConstraints(hConstraintsSegment + vConstraintsSegment)
        
        selectedViewControllerIndex = segmentedControl.selectedSegmentIndex
    }
    
    fileprivate func loadInitialViewController() {
        
        var initialController: UIViewController?
        
        for (index, pair) in controllers.enumerated() {
            if index == initiallySelectedIndex {
                initialController = pair.first!.1
                segmentedControl.selectedSegmentIndex = initiallySelectedIndex
            }
        }
        
        if initialController == nil {
            initialController = controllers[0].first!.1
            segmentedControl.selectedSegmentIndex = 0
        }
        
        initialController!.willMove(toParent: self)
        addChild(initialController!)
        currentControllerContainerView.addSubview(initialController!.view)
        initialController!.didMove(toParent: self)
        
        initialController!.view.translatesAutoresizingMaskIntoConstraints = false
        
        
        let hConstraintsSegment = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[controller]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["controller": initialController!.view])
        
        let vConstraintsSegment = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[controller]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["controller": initialController!.view])
        
        currentControllerContainerView.addConstraints(hConstraintsSegment + vConstraintsSegment)
    }
    
    fileprivate func loadSegmentedControl() {
        for (index, item) in controllers.enumerated() {
            segmentedControl.insertSegment(withTitle: item.first?.key, at: index, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
