//
//  DetailsViewController.swift
//  MobileApp
//
//  Created by Tudor Stanila on 24/10/2017.
//  Copyright © 2017 Tudor Stanila. All rights reserved.
//

import UIKit
import SwiftCharts

class DetailsViewController: UIViewController {

    var viewModel : BookDetailsViewModel! = nil
   // fileprivate var chart: Chart?
   
  //  let sideSelectorHeight: CGFloat = 50
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var AuthorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        // Do any additional setup after loading the view.
        
        if viewModel != nil
        {
            TitleLabel.text = viewModel.BookTitleForDisplay()
            AuthorLabel.text = viewModel.BookAuthorForDisplay()
        }
        
        /*
        showChart(horizontal: false)
        if let chart = chart {
            let sideSelector = DirSelector(frame: CGRect(x: 0, y: chart.frame.origin.y + chart.frame.size.height, width: view.frame.size.width, height: sideSelectorHeight), controller: self)
            view.addSubview(sideSelector)
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func CancelButtonPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){
        guard let editBookViewController = unwindSegue.source as? EditBookViewController else{
            fatalError("Wrong source")
        }
        //let title = editBookViewController.viewModel.FindBookTitle()
        //let author = editBookViewController.viewModel.FindBookAuthor()
        //TitleLabel.text = title
        //AuthorLabel.text = author
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? EditBookViewController
        {
            
        
        controller.viewModel.SetBook(id: self.viewModel.book.Id,title:self.viewModel.book.Title,authorid:self.viewModel.book.AuthorId,bookauthor: self.viewModel.book.BookAuthor)
        }
    }
 
    // MARK: - Charts
    /*
    fileprivate func barsChart(horizontal: Bool) -> Chart {
        let tuplesXY = [(2, 8), (4, 9), (6, 10), (8, 12), (12, 17)]
        
        func reverseTuples(_ tuples: [(Int, Int)]) -> [(Int, Int)] {
            return tuples.map{($0.1, $0.0)}
        }
        
        let chartPoints = (horizontal ? reverseTuples(tuplesXY) : tuplesXY).map{ChartPoint(x: ChartAxisValueInt($0.0), y: ChartAxisValueInt($0.1))}
        
        let labelSettings = ChartLabelSettings(font: ChartDefaults.labelFont)
        
        let generator = ChartAxisGeneratorMultiplier(2)
        let labelsGenerator = ChartAxisLabelsGeneratorFunc {scalar in
            return ChartAxisLabel(text: "\(scalar)", settings: labelSettings)
        }
        let xGenerator = ChartAxisGeneratorMultiplier(2)
        
        let xModel = ChartAxisModel(firstModelValue: 0, lastModelValue: 20, axisTitleLabels: [ChartAxisLabel(text: "Axis title", settings: labelSettings)], axisValuesGenerator: xGenerator, labelsGenerator: labelsGenerator)
        let yModel = ChartAxisModel(firstModelValue: 0, lastModelValue: 20, axisTitleLabels: [ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical())], axisValuesGenerator: generator, labelsGenerator: labelsGenerator)
        
        let barViewGenerator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsViewsLayer, chart: Chart) -> UIView? in
            let bottomLeft = layer.modelLocToScreenLoc(x: 0, y: 0)
            
            let barWidth: CGFloat = Env.iPad ? 60 : 30
            
            let settings = ChartBarViewSettings(animDuration: 0.5)
            
            let (p1, p2): (CGPoint, CGPoint) = {
                if horizontal {
                    return (CGPoint(x: bottomLeft.x, y: chartPointModel.screenLoc.y), CGPoint(x: chartPointModel.screenLoc.x, y: chartPointModel.screenLoc.y))
                } else {
                    return (CGPoint(x: chartPointModel.screenLoc.x, y: bottomLeft.y), CGPoint(x: chartPointModel.screenLoc.x, y: chartPointModel.screenLoc.y))
                }
            }()
            return ChartPointViewBar(p1: p1, p2: p2, width: barWidth, bgColor: UIColor.blue.withAlphaComponent(0.6), settings: settings)
        }
        
        let frame = ChartDefaults.chartFrame(view.bounds)
        let chartFrame = chart?.frame ?? CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height - sideSelectorHeight)
        
        let chartSettings = ChartDefaults.chartSettingsWithPanZoom
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
        
        let chartPointsLayer = ChartPointsViewsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, chartPoints: chartPoints, viewGenerator: barViewGenerator)
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ChartDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, settings: settings)
        
        return Chart(
            frame: chartFrame,
            innerFrame: innerFrame,
            settings: chartSettings,
            layers: [
                xAxisLayer,
                yAxisLayer,
                guidelinesLayer,
                chartPointsLayer
            ]
        )
    }
    
    fileprivate func showChart(horizontal: Bool) {
        self.chart?.clearView()
        
        let chart = barsChart(horizontal: horizontal)
        view.addSubview(chart.view)
        self.chart = chart
    }
    
    class DirSelector: UIView {
        
        let horizontal: UIButton
        let vertical: UIButton
        
        weak var controller: DetailsViewController?
        
        fileprivate let buttonDirs: [UIButton : Bool]
        
        init(frame: CGRect, controller: DetailsViewController) {
            
            self.controller = controller
            
            horizontal = UIButton()
            horizontal.setTitle("Horizontal", for: UIControlState())
            vertical = UIButton()
            vertical.setTitle("Vertical", for: UIControlState())
            
            buttonDirs = [horizontal : true, vertical : false]
            
            super.init(frame: frame)
            
            addSubview(horizontal)
            addSubview(vertical)
            
            for button in [horizontal, vertical] {
                button.titleLabel?.font = ChartDefaults.fontWithSize(14)
                button.setTitleColor(UIColor.blue, for: UIControlState())
                button.addTarget(self, action: #selector(DirSelector.buttonTapped(_:)), for: .touchUpInside)
            }
        }
        
        @objc func buttonTapped(_ sender: UIButton) {
            let horizontal = sender == self.horizontal ? true : false
            controller?.showChart(horizontal: horizontal)
        }
        
        override func didMoveToSuperview() {
            let views = [horizontal, vertical]
            for v in views {
                v.translatesAutoresizingMaskIntoConstraints = false
            }
            
            let namedViews = views.enumerated().map{index, view in
                ("v\(index)", view)
            }
            
            var viewsDict = Dictionary<String, UIView>()
            for namedView in namedViews {
                viewsDict[namedView.0] = namedView.1
            }
            
            let buttonsSpace: CGFloat = Env.iPad ? 20 : 10
            
            let hConstraintStr = namedViews.reduce("H:|") {str, tuple in
                "\(str)-(\(buttonsSpace))-[\(tuple.0)]"
            }
            
            let vConstraits = namedViews.flatMap {NSLayoutConstraint.constraints(withVisualFormat: "V:|[\($0.0)]", options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict)}
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: hConstraintStr, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict)
                + vConstraits)
        }
        
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }*/

}
