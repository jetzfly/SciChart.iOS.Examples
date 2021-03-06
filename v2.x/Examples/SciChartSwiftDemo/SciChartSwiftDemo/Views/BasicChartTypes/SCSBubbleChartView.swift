//
//  SCSBubbleChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/3/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSBubbleChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCIDateTimeAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(0.1))
        
        let dataSeries = SCIXyzDataSeries(xType: .dateTime, yType: .double, zType: .double)
        let tradeTicks = DataManager.getTradeTicks()
    
        for i in 0..<tradeTicks!.count {
            let tradeData = tradeTicks![i] as! TradeData
            dataSeries.appendX(SCIGeneric(tradeData.tradeDate), y: SCIGeneric(tradeData.tradePrice), z: SCIGeneric(tradeData.tradeSize))
        }
        
        let rSeries = SCIBubbleRenderableSeries();
        rSeries.bubbleBrushStyle = SCISolidBrushStyle(colorCode: 0x50CCCCCC)
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFFCCCCCC, withThickness: 1.0)
        rSeries.style.detalization = 44
        rSeries.zScaleFactor = 1.0
        rSeries.autoZRange = false
        rSeries.dataSeries = dataSeries
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = dataSeries
        lineSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xffff3333, withThickness: 2.0)
        
        SCIUpdateSuspender.usingWithSuspendable(surface, with:{
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(lineSeries)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCITooltipModifier()])
            
            rSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            lineSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        })
    }
}
