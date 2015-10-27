//
//  Graph1ViewController.m
//  KeepTrack
//
//  Created by Alex on 11/01/2015.
//  Copyright (c) 2015 PairProject. All rights reserved.
//

#import <Social/Social.h>
#import "GraphViewController.h"
#import "CategoryTableVC.h"
#import "TaskCategory.h"
#import "PieGraphChart.h"
#import "PieGraphPiece.h"
#import "UIColor+HexColor.h"
#import "Item.h"

int totalNumber;

@interface Graph1ViewController ()

@end

@implementation Graph1ViewController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self loadDataTest];
    [self initweekdaysForSevendays];
    [self initCalendarForThirtyOneDays];
    [self UpdateDataForSevenDays];

    self.myGraph.enableTouchReport = YES;
    self.myGraph.colorTop = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.myGraph.colorBottom = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0]; // Leaving this not-set on iOS 7 will default to your window's tintColor
    self.myGraph.colorLine = [UIColor whiteColor];
    self.myGraph.colorXaxisLabel = [UIColor whiteColor];
    self.myGraph.widthLine = 3.0;
    self.myGraph.enableTouchReport = YES;
    
    // The labels to report the values of the graph when the user touches it
    self.labelValues.text = [NSString stringWithFormat:@"%i", totalNumber];
    self.labelDates.text = @"";
}

#pragma mark - init ArrayOfValues and ArrayOfDates of sevenDays

-(void)UpdateDataForSevenDays
{
    self.ArrayOfValues = [[NSMutableArray alloc] init];
    self.ArrayOfDates = [[NSMutableArray alloc]init];
    totalNumber = 0;
    for (int i=0; i<6; i++) {
        [self.ArrayOfValues addObject:[self.scoresForPreviousSixDays objectAtIndex:i]];
       
        [self.ArrayOfDates addObject:[_weekdaysForSevendays  objectAtIndex:i]];
        totalNumber = totalNumber + [[self.ArrayOfValues objectAtIndex:i] intValue];
    }
    if([self.scoreToday.score intValue]== 0)
    {
       [self.ArrayOfValues addObject:[NSNumber numberWithInt:0]];
        [self.ArrayOfDates addObject:[_weekdaysForSevendays objectAtIndex:6]];
        totalNumber = totalNumber + [[self.ArrayOfValues objectAtIndex:6]intValue];
    }
    else{
   
        [self.ArrayOfValues addObject:self.scoreToday.score];
        [self.ArrayOfDates addObject:[_weekdaysForSevendays objectAtIndex:6]];
        totalNumber = totalNumber + [[self.ArrayOfValues objectAtIndex:6]intValue];
    }
    
}

#pragma mark - init ArrayOfValues and ArrayOfDates of thirtyDays
-(void)UpdateDataForThirtyDays
{
    self.ArrayOfValues = [[NSMutableArray alloc] init];
    self.ArrayOfDates = [[NSMutableArray alloc]init];
    totalNumber = 0;
    for (int i=0; i<30; i++) {
        [self.ArrayOfValues addObject:[self.scoresForPreviousThirtyDays objectAtIndex:i]];
        [self.ArrayOfDates addObject:[self.calendarForThirtyOnedays objectAtIndex:i]];
        totalNumber = totalNumber + [[self.ArrayOfValues objectAtIndex:i] intValue];
    }
}

#pragma mark - Share to SNS 
-(IBAction)shareToSNS:(id)sender
{
    CGFloat xWidth = self.view.bounds.size.width - 20.0f;
    CGFloat yHeight = 272.0f;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = FALSE;
    [poplistview setTitle:@"Share to"];
    [poplistview show];
}
#pragma mark - UIPopoverListViewDataSource
// pop a list with three buttons to share graph to the facebook, twitter and we chat app
- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    int row =(int) indexPath.row;
    
    if(row == 0){
        cell.textLabel.text = @"Facebook";
        cell.imageView.image = [UIImage imageNamed:@"facebook.png"];
    }else if (row == 1){
        cell.textLabel.text = @"Twitter";
        cell.imageView.image = [UIImage imageNamed:@"twitter.png"];
    }else if (row == 2){
        cell.textLabel.text = @"We Chat";
        cell.imageView.image = [UIImage imageNamed:@"wechat.png"];
    }
    
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

#pragma mark - capture the view and transfer it to img
- (UIImage *)captureView {
    
    //hide controls if needed
    CGRect rect = [self.myGraph bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.myGraph.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//init weekdays and create the dictionary for the line graph xaxis
-(void)initweekdaysForSevendays
{
    
    NSMutableArray*weekdaysForSevendays=[NSMutableArray arrayWithCapacity:7];
    for (int i=0; i<7; i++) {
        [weekdaysForSevendays addObject:[NSNull null]];
    }
    // Sunday = 1, Saturday = 7
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSInteger weekday = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:currentDate] weekday];
  
    
    [weekdaysForSevendays replaceObjectAtIndex:6 withObject:[NSNumber numberWithInteger:weekday]];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    NSDate*targetDate=currentDate;
    for (int i=0; i<6; i++) {
        //the previous day of the above
        [components setYear:0];
        [components setMonth:0];
        [components setDay:-1];
        targetDate=[[NSCalendar currentCalendar]dateByAddingComponents:components toDate:targetDate options:0];
        weekday=[[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:targetDate] weekday];
        
        [weekdaysForSevendays replaceObjectAtIndex:6-i-1 withObject:[NSNumber numberWithInteger:weekday] ];
    }
   
    //transfor weekday num to weekday str
    
    for (int i=0; i<7; i++) {
        switch ([[weekdaysForSevendays objectAtIndex:i]intValue]) {
            case 7:
                [weekdaysForSevendays replaceObjectAtIndex:i withObject:@"Sun"];
                break;
            case 6:
                [weekdaysForSevendays replaceObjectAtIndex:i withObject:@"Sat"];
                break;
            case 5:
                [weekdaysForSevendays replaceObjectAtIndex:i withObject:@"Fri"];
                break;
            case 4:
                [weekdaysForSevendays replaceObjectAtIndex:i withObject:@"Thu"];
                break;
            case 3:
                [weekdaysForSevendays replaceObjectAtIndex:i withObject:@"Wed"];
                break;
            case 2:
                [weekdaysForSevendays replaceObjectAtIndex:i withObject:@"Tue"];
                break;
            case 1:
                [weekdaysForSevendays replaceObjectAtIndex:i withObject:@"Mon"];
                break;
            default:
                break;
        }
    }
  
    
    _weekdaysForSevendays=[weekdaysForSevendays copy];
}

//init the month and create the dictionary for the line graph xaxis
-(void)initCalendarForThirtyOneDays
{
    
    NSMutableArray*calendarForThirtyOneDays=[NSMutableArray arrayWithCapacity:31];
    for (int i=0; i<31; i++) {
        [calendarForThirtyOneDays addObject:[NSNull null]];
    }
    // Sunday = 1, Saturday = 7
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSInteger day = [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:currentDate] weekday];
    
    
    [calendarForThirtyOneDays replaceObjectAtIndex:30 withObject:[NSNumber numberWithInteger:day]];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    NSDate*targetDate=currentDate;
    for (int i=0; i<30; i++) {
        //the previous day of the above
        [components setYear:0];
        [components setMonth:0];
        [components setDay:-1];
        targetDate=[[NSCalendar currentCalendar]dateByAddingComponents:components toDate:targetDate options:0];
        day = [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:targetDate] day];
        
        [calendarForThirtyOneDays replaceObjectAtIndex:29-i withObject:[NSString stringWithFormat:@"%ld",(long)day] ];
       
    }
    
    _calendarForThirtyOnedays=[calendarForThirtyOneDays copy];
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        NSLog(@"facebook");
        UIImage *postImage = [self captureView];
        NSString *postTest = @"S#KeepTrack# I have done tasks this week!";
        NSArray *activityItems = @[postTest, postImage];
        
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc]
         initWithActivityItems:activityItems
         applicationActivities:nil];
        
        [self presentViewController:activityController
                           animated:YES completion:nil];
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
        }
        
    }
    else if (indexPath.row ==1)
    {
        NSLog(@"twitter");
        UIImage *postImage = [self captureView];
        NSString *postTest = @"#KeepTrack# I have done tasks this week!";
        NSArray *activityItems = @[postTest, postImage];
        
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc]
         initWithActivityItems:activityItems
         applicationActivities:nil];
        
        [self presentViewController:activityController
                           animated:YES completion:nil];
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [composeController setInitialText:@"Just found this great application"];
            [composeController addImage:postImage];
            [composeController addURL:[NSURL URLWithString:@"http://www.baidu.com"]];
            [self presentViewController:composeController animated:YES completion:nil];
        }
        else{
            //NSLog(@"failed");
        }}
    else if (indexPath.row ==2)
    {
        
    }
    else if (indexPath.row == 3)
    {
        //NSLog(@"other");
    }
}

//return the height of the pop list cell height
- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - Graph Action - added by frank


-(IBAction)GraphSelect:(id)sender
{
    UIColor *color;
    if (self.graphColorChoices.selectedSegmentIndex==0) {
        [_chart removeFromSuperview];
        [self initweekdaysForSevendays];
        [self UpdateDataForSevenDays];
        [self.myGraph clearsContextBeforeDrawing];
        color = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
        self.myGraph.colorTop = color;
        self.myGraph.colorBottom = color;
        self.myGraph.backgroundColor = color;
        self.view.tintColor = color;
        self.labelValues.textColor = color;
        [self.myGraph reloadGraph];
        self.labelDates.text = @"DATA IN THE PAST 7 DAYS";

    }
    else if(self.graphColorChoices.selectedSegmentIndex ==1)
    {
         [_chart removeFromSuperview];
        [self UpdateDataForThirtyDays];
        [self.myGraph clearsContextBeforeDrawing];
        color = [UIColor colorWithRed:255.0/255.0 green:187.0/255.0 blue:31.0/255.0 alpha:1.0];
        self.myGraph.colorTop = color;
        self.myGraph.colorBottom = color;
        self.myGraph.backgroundColor = color;
        self.view.tintColor = color;
        self.labelValues.textColor = color;
        [self.myGraph reloadGraph];
        self.labelDates.text = @"DATA IN THE PAST 30 DAYS";

    }
    else if(self.graphColorChoices.selectedSegmentIndex ==2)
    {
        //color = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0];
        [_chart removeFromSuperview];
        _chart = [[PieGraphChart alloc]init];
        [self.myGraph clearsContextBeforeDrawing];
        // [self.myGraph removeFromSuperview];
        
        [self.view addSubview:_chart];
        [_chart setBackgroundColor:[UIColor whiteColor]];
        [_chart setBackgroundColor:[UIColor colorWithIntegerRed:120 green:210 blue:250 alpha:1]];
        [_chart setFrame:CGRectMake(0, 64, 320, 240)];
        
        _chart.bounds=CGRectMake(_chart.bounds.origin.x, _chart.bounds.origin.y-40, _chart.bounds.size.width, _chart.bounds.size.height);
        [_chart setEnableStrokeColor:YES];
        [_chart setHoleRadiusPrecent:0.3];
        
        [_chart.layer setShadowOffset:CGSizeMake(2, 2)];
        [_chart.layer setShadowRadius:3];
        [_chart.layer setShadowColor:[UIColor blackColor].CGColor];
        [_chart.layer setShadowOpacity:0.7];
        [_chart setHoleRadiusPrecent:0.3];
        NSArray *chartValues = @[
                                 @{@"name":@"first", @"value":@50, @"color":[UIColor colorWithHex:0xdd191daa]},
                                 @{@"name":@"second", @"value":@20, @"color":[UIColor colorWithHex:0xd81b60aa]},
                                 @{@"name":@"third", @"value":@40, @"color":[UIColor colorWithHex:0x8e24aaaa]},
                                 @{@"name":@"fourth 2", @"value":@70, @"color":[UIColor colorWithHex:0x3f51b5aa]},
                                 @{@"name":@"fourth 3", @"value":@65, @"color":[UIColor colorWithHex:0x5677fcaa]},
                                 @{@"name":@"fourth 4", @"value":@23, @"color":[UIColor colorWithHex:0x2baf2baa]},
                                 @{@"name":@"fourth 5", @"value":@34, @"color":[UIColor colorWithHex:0xb0bec5aa]},
                                 @{@"name":@"fourth 6", @"value":@54, @"color":[UIColor colorWithHex:0xf57c00aa]}
                                 ];
        NSArray *colors=[NSArray arrayWithObjects:
                         [UIColor colorWithHex:0xdd191daa],
                         [UIColor colorWithHex:0xd81b60aa],
                         [UIColor colorWithHex:0x8e24aaaa],
                         [UIColor colorWithHex:0x3f51b5aa],
                         [UIColor colorWithHex:0x5677fcaa],
                         [UIColor colorWithHex:0x2baf2baa],
                         [UIColor colorWithHex:0xb0bec5aa],
                         [UIColor colorWithHex:0xf57c00aa],
                         nil];
        NSMutableDictionary*item=[[NSMutableDictionary alloc]init];
        NSMutableArray*items=[[NSMutableArray alloc]init];
        for (int i=0; i<[_topEightCategory count]; i++) {
            item=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                  [[_topEightCategory objectAtIndex:i]objectAtIndex:0], @"name",
                  [NSString stringWithFormat:@"%d",[[[_topEightCategory objectAtIndex:i]objectAtIndex:1]intValue]],@"value",
                  [colors objectAtIndex:i],@"color",
                  nil];
            [items addObject:item];
            
        }
        chartValues=[items mutableCopy];
        [_chart setChartValues:chartValues animation:YES];
        self.labelDates.text = @"PIE GRAPH OF FINSHED TASKS IN EACH CATEGORY";
    }
}

#pragma mark - SimpleLineGraph Data Source

- (int)numberOfPointsInGraph {
 
    return (int)[self.ArrayOfValues count];
}

- (float)valueForIndex:(NSInteger)index {
    return [[self.ArrayOfValues objectAtIndex:index] floatValue];
}

#pragma mark - SimpleLineGraph Delegate

- (int)numberOfGapsBetweenLabels {
    return 1;
}

- (NSString *)labelOnXAxisForIndex:(NSInteger)index {
    return [self.ArrayOfDates objectAtIndex:index];
}

- (void)didTouchGraphWithClosestIndex:(int)index {
    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.ArrayOfValues objectAtIndex:index]];
    
    self.labelDates.text = [NSString stringWithFormat:@"in %@", [self.ArrayOfDates objectAtIndex:index]];
}

- (void)didReleaseGraphWithClosestIndex:(float)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.labelValues.alpha = 0.0;
        self.labelDates.alpha = 0.0;
    } completion:^(BOOL finished){
        
        self.labelValues.text = [NSString stringWithFormat:@"%i", totalNumber];
        self.labelDates.text = @"PIE GRAPH OF FINSHED TASKS IN EACH CATEGORY";
        
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.labelValues.alpha = 1.0;
            self.labelDates.alpha = 1.0;
        } completion:nil];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//comment
-(NSArray*)fetchAllCategorys{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"TaskCategory" inManagedObjectContext:self.managedObjectContext]];
    
    NSError *error = NULL;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error : %@\n", [error localizedDescription]);
    }
    
    return array;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
