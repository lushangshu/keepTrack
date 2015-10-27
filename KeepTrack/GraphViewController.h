//
//  Graph1ViewController.h
//  KeepTrack
//
//  Created by Alex on 11/01/2015.
//  Copyright (c) 2015 PairProject. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LineGraphView.h"
#import "UIPopoverListView.h"
#import "ScoreEachDay.h"
#import "PieGraphChart.h"

@interface Graph1ViewController : UIViewController <LineGraphDelegate,UIPopoverListViewDataSource, UIPopoverListViewDelegate>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak,nonatomic) IBOutlet LineGraphView *myGraph;
@property (strong,nonatomic) NSMutableArray *ArrayOfValues;
@property (strong,nonatomic) NSMutableArray *ArrayOfDates;
@property (strong,nonatomic) IBOutlet UILabel *labelValues;
@property (strong,nonatomic) IBOutlet UILabel *labelDates;
@property (strong) PieGraphChart *chart;
@property (strong) NSArray * scoresForPreviousSixDays;
@property (strong) NSArray * scoresForPreviousThirtyDays;
@property (strong) NSArray * weekdaysForSevendays;
@property (strong) NSArray * calendarForThirtyOnedays;
@property (strong) ScoreEachDay* scoreToday;


@property (weak,nonatomic) IBOutlet UISegmentedControl *graphColorChoices;
//@property (weak,nonatomic) IBOutlet UIStepper *graphObjectIncrement;
@property (strong) NSArray * topEightCategory;
@property (assign) int transfer;


-(IBAction)shareToSNS:(id)sender;

// todo hours spent for each category
   //iter every category
   //todo iter every object in category
// todo hours spent for each day
@end
