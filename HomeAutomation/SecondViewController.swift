//
//  SecondViewController.swift
//  HomeAutomation
//
//  Created by Nguyen Bui An Trung on 27/5/16.
//  Copyright © 2016 Nguyen Bui An Trung. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, LineChartDelegate {
    
    var label: UILabel = UILabel()
    var lineChart = LineChart()

    @IBOutlet weak var chartView: UIView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        let vc: FirstViewController = ((self.parentViewController as! UITabBarController).viewControllers![0] as? FirstViewController)!
        if (vc.list.list.count > 7) {
            lineChart.clear()
            drawChart()
        } else {
            label.text = "Data is not available now"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawChart(){
        var views: [String: AnyObject] = [:]
        
        label.text = "Tab on the dot"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        self.chartView.addSubview(label)
        views["label"] = label
        self.chartView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
        self.chartView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[label]", options: [], metrics: nil, views: views))
        
        // simple arrays
        var data: [CGFloat] = []
        let vc: FirstViewController = ((self.parentViewController as! UITabBarController).viewControllers![0] as? FirstViewController)!
        let piDataList = vc.list.last(7)
        for piData in piDataList {
            
            data.append(CGFloat(Float(piData.temp)))
        }
        
        let data1: [CGFloat] = [255]
        
        // simple line with custom x axis labels
        
        lineChart.animation.enabled = true
        lineChart.area = false
        lineChart.x.grid.count = 5
        lineChart.x.labels.visible = false
        lineChart.y.grid.count = 5
        lineChart.y.labels.visible = true
        lineChart.y.axis.inset = 25
        lineChart.addLine(data)
        lineChart.addLine(data1)
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        self.chartView.addSubview(lineChart)
        views["chart"] = lineChart
        self.chartView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
        self.chartView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==400)]", options: [], metrics: nil, views: views))

    }
    
    func didSelectDataPoint(x: CGFloat, yValues: [CGFloat]) {
        label.text = "Selected value: \(yValues[0])"
        print("\(x) and \(yValues)")
    }

}

