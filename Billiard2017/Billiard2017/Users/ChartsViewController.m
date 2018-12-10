//
//  ChartsViewController.m
//  Billiard2017
//
//  Created by Brian Dillon on 08/12/2018.
//  Copyright © 2018 ROCUDO. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Billiard2017-Bridging-Header.h"
#import "AAChartKit.h"
#import "User.h"
#import "Game.h"
@import Charts;

@interface ChartsViewController : UIViewController <ChartViewDelegate>{
     NSString  *currentType;
     NSString *lastDate;
     BOOL chartAdded;
    CGFloat chartViewWidth;
    CGFloat chartViewHeight;
}
@property (weak, nonatomic) IBOutlet UIView *userLineChart;
@property (strong, nonatomic) IBOutlet AAChartView *userDataLineChart;
@property (strong, nonatomic) IBOutlet ChartsViewController *chartsView;
@property (nonatomic, strong) NSArray* options;
//@property (nonatomic, strong) IBOutlet LineChartView *chartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;
@property (nonatomic, strong) NSMutableArray* userData;
@property (nonatomic, strong) User* user;
@property (nonatomic, strong) NSString * userTitle;
@property (nonatomic, strong) NSArray *plotData;

@end

@implementation ChartsViewController

- (instancetype)init:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableArray *)userData withUser:(User*)user withHeight:(CGFloat)height withWidth:(CGFloat)width {
    
    NSLog(@"Instantiating graph");
    chartAdded = FALSE;
    self.user = user;
    self.userData = userData;
    self.userTitle = self.user.userName;
    currentType = @"Duration";
    
    //CGFloat topBar = self.navigationController.navigationBar.frame.size.height;
    
    chartViewWidth  = width;
    chartViewHeight = height;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    return self;
}

- (void) viewWillLayoutSubviews{

    //if (chartAdded == FALSE){
    
    chartAdded = TRUE;
        
    CGFloat navheight = self.navigationController.view.frame.size.height;
    //CGFloat height = chartViewHeight - navheight;

    
    self.userDataLineChart = [[AAChartView alloc]init];
    self.userDataLineChart.frame = CGRectMake(0, 0, chartViewWidth, chartViewHeight - 60);
    self.userDataLineChart.scrollEnabled = YES;
    
   // self.userDataLineChart.contentHeight =chartViewHeight - 50;
        
    [self.view addSubview:self.userDataLineChart];
    self.title =self.userTitle;
    
    NSArray *array = [self.user.game allObjects];
    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Game*)a gameDate];
        NSDate *second = [(Game*)b gameDate];
        return [first compare:second];
    }];
    
    //if ([sortedArray count]==0) {
    //    return;
    //}
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMM y "];
    
    NSLog(@"SORTED -- - %@", sortedArray);
    //NSLog(@"PLOT DATA -- - %@", plotData);
    
    NSMutableArray *dates = [NSMutableArray array];
    NSMutableArray *markerColours = [NSMutableArray array];
    for (int i=0; i<[sortedArray count]; i++) {
        NSLog(@"DATE PLACER i %d", i);
        NSLog(@"sortedArray %lu", (unsigned long)[sortedArray count]);
        
        Game *game=[sortedArray objectAtIndex:i];
        NSDate *date = game.gameDate;
        NSString *stringFromDate=[formatter stringFromDate:date];
        NSLog(@"last date %@", lastDate);
        NSLog(@"current date %@", stringFromDate);
        
        if ([lastDate isEqualToString: stringFromDate]){
            stringFromDate = @"";
            NSLog(@"skipping date label - same as previous");
        }
        
        [dates addObject: stringFromDate];
        lastDate = [formatter stringFromDate:date] ;
        
        if ([game.gameDirection isEqualToString:@"exhale"]) {
           [markerColours addObject: @"#35b31c"];
            
        }else if ([game.gameDirection isEqualToString:@"inhale"])
        {
            [markerColours addObject: @"#ef3118"];
        }
    }
    
    // For the y-axis
    NSMutableArray *durationVals = [NSMutableArray array];
    for (int b=0; b< [sortedArray count]; b++) {
        Game *game=[sortedArray objectAtIndex:b];
        NSNumber * duration = game.duration;
        [durationVals addObject: duration];
    }

    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeSpline)
    .titleSet(@"")
    .subtitleSet(@"")
    //.categoriesSet(@[@"Java",@"Swift",@"Python",@"Ruby", @"PHP",@"Go",@"C",@"C#",@"C++"])
    .categoriesSet(dates)
    .yAxisTitleSet(@"Duration")
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"Exhale"),
                 AAObject(AASeriesElement)
                 .dataSet(durationVals )
                 .markerSet(AAMarker.new
                            .fillColorSet(@"#ffffff")
                            .lineWidthSet(@2)
                            ),
                 @{@"name" : @"Inhale",
                     @"data" : durationVals,
                     @"colorByPoint" : @true,
                     @"markerRadius" : @15,
                     @"markerSymbol" : @"circle"
                   }
                 
    /*
     
     .nameSet(@"Inhale")
     .dataSet(durationVals ),
     AAObject(AASeriesElement)
     .nameSet(@"Inhale")
     .dataSet(durationVals ),
     AAObject(AASeriesElement)
     .nameSet(@"Exhale")
                 .lineWidthSet(@8)
                 .lineWidthSet(@3)

                 .zoneAxisSet(@"x")
                 .zonesSet(@[@{@"value": @4,
                               @"color":@"rgba(220,20,60,1)",//猩红色
                               @"fillColor": gradientColorDic1  // 1,
                               },@{
                                 @"color":@"rgba(30,144,255,1)",//道奇蓝
                                 @"fillColor": gradientColorDic2 // 2
                                 }, ])
                 
                  */
                ]);
    
    
    //aaChartModel.colorsThemeSet(@[@"#35b31c",@"#35b31c",@"#35b31c",@"#35b31c",@"#35b31c",@"#35b31c",@"#35b31c",@"#ef3118",@"#35b31c",@"#ef3118",@"#ef3118", @"#35b31c",@"#ef3118"]);
    aaChartModel.colorsThemeSet(markerColours);
    aaChartModel.categoriesSet(dates);
    
    
    //aaChartModel.seriesSet();
    
    
    [self.userDataLineChart aa_drawChartWithChartModel:aaChartModel];
    
    //// set the content height of aaChartView
      //self.userDataLineChart.contentHeight = chartViewHeight;
   // }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
    NSLog(@"THIS VIEW HAS LOADED");
    //[self.userDataLineChart setNoDataText:@"You need to provide data for the chart BLAH."];
    

  
}


-(void)generateData
{
    NSArray *array = [self.user.game allObjects];
    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Game*)a gameDate];
        NSDate *second = [(Game*)b gameDate];
        return [first compare:second];
    }];
    
    if ([array count]==0) {
        return;
    }
    
    NSMutableArray *contentArray = [NSMutableArray array];
    
    for ( NSUInteger i = 0; i < [sortedArray count]; i++ ) {
        
        NSNumber  *dateNumber=[NSNumber numberWithInt:i];
        NSNumber  *yvalue=0;
        
        if ([currentType isEqualToString:@"Power"]) {
            yvalue=[[sortedArray objectAtIndex:i]valueForKey:@"power"];
            [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:dateNumber, @"x", yvalue, @"y", nil]];
        }else if([currentType isEqualToString:@"Duration"])
        {
            yvalue=[[sortedArray objectAtIndex:i]valueForKey:@"duration"];
            [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:dateNumber, @"x", yvalue, @"y", nil]];
        }else
        {
            yvalue=[[sortedArray objectAtIndex:i]valueForKey:@"power"];
        }
    }
    
    self.plotData = contentArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
