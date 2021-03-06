//
//  DataAnalysisBaseView.m
//  BodCarManger
//
//  Created by cszhan on 13-10-2.
//  Copyright (c) 2013年 cszhan. All rights reserved.
//

#import "DataAnalysisBaseView.h"
#import "DAMultipleProgressLayer.h"
#import "WSLineChartView.h"
#import "ZCSDrawLineView.h"

#define YMax 25
@interface DataAnalysisBaseView(){
   
   
}
@end
@implementation DataAnalysisBaseView
@synthesize bgImage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (void)addPercentView:(CGRect)rect{

    
    mutipleView = [[DAMultipleProgressLayer alloc]initWithFrame:rect];
    [mutipleView setTrackTintColor:[[UIColor blackColor] colorWithAlphaComponent:1.0f]];
    //[appearance setTrackTintColor:<#(UIColor *)#>]
    //[appearance setProgressTintColor:[UIColor whiteColor]];
    [mutipleView setBackgroundColor:[UIColor clearColor]];
    [mutipleView setThicknessRatio:0.3f];
    if(kDeviceCheckIphone5){
        [mutipleView setThicknessRatio:0.4f];
    }
    [self addSubview:mutipleView];
}
- (void)addLineChartView:(CGRect)rect withBGImage:(UIImage*)image{

    drawLineView = [[ZCSDrawLineView alloc]initWithFrame:rect];
    [drawLineView setBackgroundColor:[UIColor clearColor]];
    [drawLineView setBackgroundImage:image];
    
    CGFloat offsexY = 41.f;
    CGFloat maxLenY = 88.f;
    CGFloat offsetX = 19.f;
    if(kDeviceCheckIphone5){
        maxLenY = 133.f;
        offsetX = 29.f;
    }
    
    
    [drawLineView setOffsetX:offsetX];
    [drawLineView setOffsetY:offsexY];
    
    [drawLineView setMaxLenY:maxLenY];//y
    
    [drawLineView setXStep:215/30.f];//208 x len
    [drawLineView setYStep:maxLenY/YMax];
    
    [self addSubview:drawLineView];
    
}
- (void)setDisplayViewData:(NSArray*)data withType:(int)type{
    
   
    for(int i = 0;i<3;i++){
        id item = [data objectAtIndex:i];
        if(type == 0)
        {
            [mutipleView addMutiplePecentTrackWithPercent:[[item objectForKey:@"percent"] intValue] withColor:[item objectForKey:@"color"] withClocksize:NO];
        }
    }
    [mutipleView setNeedsDisplay];
    /*
    [mutipleView addMutiplePecentTrackWithPercent:32 withColor:[UIColor yellowColor] withClocksize:YES];
    
    
    [mutipleView addMutiplePecentTrackWithPercent:40 withColor:[UIColor blueColor] withClocksize:YES];
    //mutipleView.roundedCorners = NO;
    [self addSubview:mutipleView];
    */
}

- (void)setDisplayLineChart:(NSArray*)lineData {
    
    //UIImage *bgImage = [UIIm]
    [drawLineView updateDrawLineData:lineData];
    
}
- (void)addDisplayLineChart:(NSArray*)lineData{
    [drawLineView addDrawLineData:lineData];
}
- (void)createLineChart:(NSArray*)lineData
{
    lineChart = [[WSLineChartView alloc] initWithFrame:CGRectMake(0.0,104.f,300.0, 150.0)];
    NSMutableArray *arr = [self createDemoDatas:10];
    NSDictionary *colorDict = [self createColorDict];
    
    lineChart.xAxisName = @"Year";
    lineChart.rowWidth = 40.0;
    lineChart.rowDistance = 30.0;
    lineChart.title = @"Pyanfield's Line Chart";
    lineChart.showZeroValueOnYAxis = YES;
    //lineChart.titleFrame = CGRectMake(0.0, 0.0, 400, 50);
    //lineChart.legendFrame = CGRectMake(0.0, 0.0, 400, 400);
    [lineChart drawChart:arr withColor:colorDict];
    lineChart.backgroundColor = [UIColor blackColor];
    [self addSubview:lineChart];
    SafeRelease(lineChart);
}
- (NSMutableArray*)createDemoDatas:(int)count
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=0; i<count; i++) {
        WSChartObject *lfcObj = [[WSChartObject alloc] init];
        lfcObj.name = @"Liverpool";
        lfcObj.xValue = [NSString stringWithFormat:@"%d",i];
        lfcObj.yValue = [NSNumber numberWithFloat: arc4random() % 250];
        WSChartObject *chObj = [[WSChartObject alloc] init];
        chObj.name = @"Chelsea";
        chObj.xValue = [NSString stringWithFormat:@"%d",i];
        chObj.yValue = [NSNumber numberWithFloat:(int)(arc4random() % 250)];
        WSChartObject *muObj = [[WSChartObject alloc] init];
        muObj.name = @"MU";
        muObj.xValue = [NSString stringWithFormat:@"%d",i];
        muObj.yValue = [NSNumber numberWithFloat:(int)(arc4random() % 200)];
        WSChartObject *mcObj = [[WSChartObject alloc] init];
        mcObj.name = @"ManCity";
        mcObj.xValue = [NSString stringWithFormat:@"%d",i];
        mcObj.yValue = [NSNumber numberWithFloat:(int)(arc4random() % 100) - 150];
        
        WSChartObject *avgObj = [[WSChartObject alloc] init];
        avgObj.name = @"Average";
        avgObj.xValue = [NSString stringWithFormat:@"%d",i];
        avgObj.yValue = [NSNumber numberWithFloat:([lfcObj.yValue floatValue] + [chObj.yValue floatValue] + [muObj.yValue floatValue] + [muObj.yValue floatValue])/4.0];
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              lfcObj,@"Liverpool",
                              muObj,@"MU",
                              chObj,@"Chelsea",
                              //mcObj,@"ManCity",
                             // avgObj,@"Average",
                              nil];
        [arr addObject:data];
    }
    return arr;
}

- (NSDictionary*)createColorDict
{
    NSDictionary *colorDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [UIColor redColor],@"Liverpool",
                               [UIColor purpleColor],@"MU",
                               [UIColor greenColor],@"Chelsea",
                               //[UIColor orangeColor],@"ManCity",
                               //[UIColor blueColor],@"Average",
                               nil];
    return colorDict;
}

- (void)setNeedsDisplay{
    [mutipleView setNeedsDisplay];
    [lineChart setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
