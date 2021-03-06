//
//  BandChartViewController.m
//  SciChartDemo
//
//  Created by Admin on 22.02.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "BandChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation BandChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(1.1) Max:SCIGeneric(2.7)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    DoubleSeries * data = [DataManager getDampedSinewaveWithAmplitude:1.0 DampingFactor:0.01 PointCount:1000 Freq:10];
    DoubleSeries * moreData = [DataManager getDampedSinewaveWithAmplitude:1.0 DampingFactor:0.05 PointCount:1000 Freq:12];
    
    SCIXyyDataSeries * dataSeries = [[SCIXyyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    [dataSeries appendRangeX:data.xValues Y1:data.yValues Y2:moreData.yValues Count:data.size];
    
    SCIFastBandRenderableSeries * rSeries = [SCIFastBandRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x33279B27];
    rSeries.fillY1BrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x33FF1919];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 withThickness:1.0];
    rSeries.strokeY1Style = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF1919 withThickness:1.0];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [rSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
    }];
}

@end
