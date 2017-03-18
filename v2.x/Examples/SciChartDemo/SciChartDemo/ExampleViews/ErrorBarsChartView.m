//
//  ErrorBarsChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 9/17/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "ErrorBarsChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation ErrorBarsChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

- (void)initializeSurfaceRenderableSeries {
    
    SCIXyDataSeries * data = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    [DataManager getFourierSeriesZoomed:data amplitude:1.0 phaseShift:0.1 xStart:5.0 xEnd:5.15 count:5000];
    
    SCIHlcDataSeries * dataSeries0 = [[SCIHlcDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    SCIHlcDataSeries * dataSeries1 = [[SCIHlcDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    
    [self fillSeries:dataSeries0 sourceData:data scale:1.0];
    [self fillSeries:dataSeries1 sourceData:data scale:1.3];
    
    SCIFastFixedErrorBarsRenderableSeries * errorBars0 = [SCIFastFixedErrorBarsRenderableSeries new];
    [errorBars0 setErrorDirection:SCIErrorBarDirectionVertical];
    [errorBars0 setErrorMode:SCIErrorBarModeBoth];
    [errorBars0 setErrorType:SCIErrorBarTypeAbsolute];
    [errorBars0 setErrorDataPointWidth:0.005];
    errorBars0.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFFC6E6FF withThickness:1.f];
    errorBars0.dataSeries = dataSeries0;
    
    SCIFastLineRenderableSeries * lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFFC6E6FF withThickness:1.f];
    lineSeries.dataSeries = dataSeries0;
    
    SCIEllipsePointMarker * pMarker = [[SCIEllipsePointMarker alloc]init];
    pMarker.width = 5;
    pMarker.height = 5;
    pMarker.fillBrush = [[SCISolidBrushStyle alloc]initWithColorCode:0xFFC6E6FF];
    lineSeries.style.drawPointMarkers = YES;
    lineSeries.style.pointMarker = pMarker;
    
    [surface.renderableSeries add:errorBars0];
    [surface.renderableSeries add:lineSeries];
    
    SCIFastFixedErrorBarsRenderableSeries * errorBars1 = [SCIFastFixedErrorBarsRenderableSeries new];
    errorBars1.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFFC6E6FF withThickness:1.f];
    errorBars1.dataSeries = dataSeries1;
    [errorBars1 setErrorDataPointWidth:0.005];
    SCIXyScatterRenderableSeries * scatterSeries = [SCIXyScatterRenderableSeries new];
    scatterSeries.dataSeries = dataSeries1;
    
    SCIEllipsePointMarker * sMarker = [[SCIEllipsePointMarker alloc]init];
    sMarker.width = 7;
    sMarker.height = 7;
    sMarker.fillBrush = [[SCISolidBrushStyle alloc]initWithColorCode:0x00FFFFFF];
    scatterSeries.style.pointMarker = sMarker;
    scatterSeries.dataSeries = dataSeries1;
    
    [surface.renderableSeries add:errorBars1];
    [surface.renderableSeries add:scatterSeries];
    
    [surface invalidateElement];
}

-(void) fillSeries:(id<SCIHlcDataSeriesProtocol>)dataSeries sourceData:(id<SCIXyDataSeriesProtocol>)sourceData scale:(double)scale{
    SCIArrayController * xValues = [sourceData xValues];
    SCIArrayController * yValues = [sourceData yValues];
    
    for (int i =0 ; i< xValues.count; i++){
        double y = SCIGenericDouble([yValues valueAt:i]) * scale;
        [dataSeries appendX: [xValues valueAt:i] Y:SCIGeneric(y) High:SCIGeneric(y + randf(0.0, 1.0)*0.2) Low:SCIGeneric(y - randf(0.0, 1.0)*0.2)];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]initWithFrame:frame];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self setupSurface];
        [self addAxes];
        [self addModifiers];
        [self initializeSurfaceRenderableSeries];
    }
    return self;
}

- (void)setupSurface {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
}

- (void)addAxes{
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    [surface.xAxes add:axis];
}

- (void)addModifiers{
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIZoomPanClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    [zem setModifierName:@"ZoomExtents Modifier"];
    
    SCIRolloverModifier * rollover = [[SCIRolloverModifier alloc] init];
    rollover.style.tooltipSize = CGSizeMake(200, NAN);
    [rollover setModifierName:@"Rollover Modifier"];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifier = gm;
}

@end
