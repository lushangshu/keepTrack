// fullname: Wuhao Wei 

#import "AppDelegate.h"
#import "ItemTableVC.h"
#import "CategoryTableVC.h"
#import "GraphViewController.h"
#import "ScoreEachDay.h"
#import "Macro.h"
#import "TaskCategory.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    /*
     insert data for testing
     To disable the testing, you have to first comment the macros, then delete the app in simulator, and finally run the app again.
     
     The reason for it is because the data inserted is into the database.
     
    */

#ifdef  _DEBUG_WEEK_LINE_GRAPH
    //insert scores for privious six days for testing the week line graph
    [self insertScoresForSixdays];
#endif

#ifdef _DEBUG_MONTH_LINE_GRAPH
    //insert scores for privious 30 days for testing the week line graph
     [self insertScoresForThirtydays];
#endif
    
    
    
    //initial today's time record
    [self initialTimeToday];
    //pass data to table vc
    UITabBarController *navigationController = (UITabBarController *)self.window.rootViewController;
    CategoryTableVC *categoryTVC = (CategoryTableVC *)([[navigationController viewControllers][0] topViewController]);
    categoryTVC.managedObjectContext = self.managedObjectContext;
    
    //pass data to graph vc
    _topEightCategory=[self searchForTopEightCategory];
    Graph1ViewController*graph1VC=(Graph1ViewController*)([[navigationController viewControllers][1] topViewController]);
    graph1VC.managedObjectContext=self.managedObjectContext;
    graph1VC.scoresForPreviousSixDays=[self searchScoresForPreviousSixdays];
    graph1VC.scoresForPreviousThirtyDays=[self searchScoresForPreviousThirtydays];
    
    
    graph1VC.scoreToday=self.scoreToday;
    graph1VC.topEightCategory=_topEightCategory;
    categoryTVC.timeToday=self.scoreToday;
    
    
    

    
    

    /* frank add the icon badge 
     * the setApplicationIconBadgeNumber: is the badge number 
     * we can add badgenumber code everywhere in our program and put an number in it
     */
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:3]; //add a icon badge on the icon
    
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        [application cancelAllLocalNotifications];
    }
    
    //Frank code on this ---Ask for User Permission to Receive UILocalNotifications in iOS 8
//    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
//        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
//    }

    return YES;
}


//check if TimeToday exists in database
//if no, then insert one into database
//if yes, then get the one from database
-(void)initialTimeToday
{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    NSNumber* year=[NSNumber numberWithInteger:[components year] ];
    NSNumber* month=[NSNumber numberWithInteger:[components month] ];
    NSNumber* day=[NSNumber numberWithInteger:[components day] ];
    
    _scoreToday=[self setScoreForYear:year Month:month Day:day withScore:0 willReplace:NO];
    
   }


-(NSArray*) searchScoresForPreviousThirtydays
{
    
    NSMutableArray*scores=[NSMutableArray arrayWithCapacity:6];
    for (int i=0; i<30; i++) {
        [scores addObject:[NSNull null]];
    }
    
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    NSDate* targetDate=nil;
    
    
    NSNumber* year;
    NSNumber* month;
    NSNumber* day;
    //today
    year=[NSNumber numberWithInteger:[components year] ];
    month=[NSNumber numberWithInteger:[components month] ];
    day=[NSNumber numberWithInteger:[components day] ];
    
    
    //scores for 6 days
    targetDate=currentDate;
    for (int i=0; i<30; i++) {
        [components setYear:0];
        [components setMonth:0];
        [components setDay:-1];
        targetDate=[[NSCalendar currentCalendar]dateByAddingComponents:components toDate:targetDate options:0];
        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:targetDate];
        year=[NSNumber numberWithInteger:[components year] ];
        month=[NSNumber numberWithInteger:[components month] ];
        day=[NSNumber numberWithInteger:[components day] ];
        [scores replaceObjectAtIndex:30-i-1 withObject:[self searchScoresForYear:year Month:month Day:day] ];
    }
    
    
    NSArray*ret=[scores copy];
    return ret;
    
}


-(NSArray*) searchScoresForPreviousSixdays
{
    
    NSMutableArray*scores=[NSMutableArray arrayWithCapacity:6];
    for (int i=0; i<6; i++) {
        [scores addObject:[NSNull null]];
    }
  
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    NSDate* targetDate=nil;
    
    
    NSNumber* year;
    NSNumber* month;
    NSNumber* day;
    //today
    year=[NSNumber numberWithInteger:[components year] ];
    month=[NSNumber numberWithInteger:[components month] ];
    day=[NSNumber numberWithInteger:[components day] ];
    
 
    //scores for 6 days
    targetDate=currentDate;
    for (int i=0; i<6; i++) {
        [components setYear:0];
        [components setMonth:0];
        [components setDay:-1];
        targetDate=[[NSCalendar currentCalendar]dateByAddingComponents:components toDate:targetDate options:0];
        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:targetDate];
        year=[NSNumber numberWithInteger:[components year] ];
        month=[NSNumber numberWithInteger:[components month] ];
        day=[NSNumber numberWithInteger:[components day] ];
        [scores replaceObjectAtIndex:6-i-1 withObject:[self searchScoresForYear:year Month:month Day:day] ];
    }
    
    
    NSArray*ret=[scores copy];
    return ret;

}

-(NSArray*) searchForTopEightCategory
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskCategory" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = NULL;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error : %@\n", [error localizedDescription]);
    }
    
    NSMutableArray*ret=[[NSMutableArray alloc]init];
    NSMutableArray*infoItem;
    NSNumber*score;
    for (TaskCategory* object in array) {
    
        score=[NSNumber numberWithInt:0];
        for (Item *item in object.items) {
    
            score=[NSNumber numberWithInt:([score intValue]+([item.timeSpent intValue]))];
        }
        infoItem=[NSMutableArray arrayWithObjects:object.name,score,nil];
        [ret addObject:infoItem];
    }
    
    
    //sort top 8
    [ret sortUsingComparator:^NSComparisonResult(NSMutableArray *obj1, NSMutableArray* obj2) {
        int score1=[(NSNumber*)[obj1 objectAtIndex:1]intValue];
         int score2=[(NSNumber*)[obj2 objectAtIndex:1]intValue];
        return  score1<score2;
    }];
    
    NSArray* result;
    if ([ret count]>8) {
        result=[ret subarrayWithRange:NSMakeRange(0, 8)];
    }
    else
    {
        result=[ret copy];
    }
    
    
    return result;
    

}

-(NSNumber*) searchScoresForYear:(NSNumber*)year Month:(NSNumber*)month Day:(NSNumber*)day
{
    ScoreEachDay*scoreEachDay=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ScoreEachDay" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@", year,month,day];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    NSError *error = NULL;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error : %@\n", [error localizedDescription]);
    }
    
    if (array && [array count] > 0) {
        scoreEachDay= [array objectAtIndex:0];
        return scoreEachDay.score;
        
      
    }
    else
    {
        return [NSNumber numberWithInt:0];
    }

}


//check if the date for the parameters exists in database
//if no, then insert one into database
//if yes, then get the one from database
-(ScoreEachDay*) setScoreForYear: (NSNumber*)year Month:(NSNumber*)month Day:(NSNumber*)day withScore:(int)score willReplace:(BOOL)replace
{
    ScoreEachDay*scoreEachDay=nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ScoreEachDay" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"year == %@ AND month == %@ AND day == %@", year,month,day];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    NSError *error = NULL;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error : %@\n", [error localizedDescription]);
    }
    
    if (array && [array count] > 0) {
        scoreEachDay= [array objectAtIndex:0];
      
     
    }
    else
    {
        
        scoreEachDay=[NSEntityDescription insertNewObjectForEntityForName:@"ScoreEachDay" inManagedObjectContext:self.managedObjectContext];
        
        scoreEachDay.year=year;
        scoreEachDay.month=month;
        scoreEachDay.day=day;
        scoreEachDay.score=[NSNumber numberWithInt:0];
        
        
    }
    
    if (replace) {
        scoreEachDay.score=[NSNumber numberWithInt:score];
    }
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return scoreEachDay;

}

-(void)insertScoresForSixdays
{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    NSDate* targetDate=nil;
    
    
    /*
         insert 7 recent days'score for each day
     */
    
    //insert today
    NSNumber* year;
    NSNumber* month;
    NSNumber* day;
    //today
    year=[NSNumber numberWithInteger:[components year] ];
    month=[NSNumber numberWithInteger:[components month] ];
    day=[NSNumber numberWithInteger:[components day] ];
  
    
    
    /*
     insert 6 previous days
    */
    //scores for 6 days
    
    int scores[6]={0,0,0,0,0,0};
    targetDate=currentDate;
    for (int i=0; i<6; i++) {
        //the previous day of the above
        [components setYear:0];
        [components setMonth:0];
        [components setDay:-1];
        targetDate=[[NSCalendar currentCalendar]dateByAddingComponents:components toDate:targetDate options:0];
        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:targetDate];
        year=[NSNumber numberWithInteger:[components year] ];
        month=[NSNumber numberWithInteger:[components month] ];
        day=[NSNumber numberWithInteger:[components day] ];
        [self setScoreForYear:year Month:month Day:day withScore:scores[5-i] willReplace:true];
    }
}

-(void)insertScoresForThirtydays
{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    NSDate* targetDate=nil;
    
    
    /*
     insert 30 recent days'score for each day
     */
    
    //get today
    NSNumber* year;
    NSNumber* month;
    NSNumber* day;
    //today
    year=[NSNumber numberWithInteger:[components year] ];
    month=[NSNumber numberWithInteger:[components month] ];
    day=[NSNumber numberWithInteger:[components day] ];
    
    
    
    /*
     insert 30 previous days
     note:
     if you don't want to overide the scores already stored in database,
     alter the willReplace parameter in setScoreForYear with "NO"
     */
    //scores for 30 days
    
    int scores[30]={1,2,3,0,0,0};
    targetDate=currentDate;
    for (int i=0; i<30; i++) {
        //the previous day of the above
        [components setYear:0];
        [components setMonth:0];
        [components setDay:-1];
        targetDate=[[NSCalendar currentCalendar]dateByAddingComponents:components toDate:targetDate options:0];
        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:targetDate];
        year=[NSNumber numberWithInteger:[components year] ];
        month=[NSNumber numberWithInteger:[components month] ];
        day=[NSNumber numberWithInteger:[components day] ];
        [self setScoreForYear:year Month:month Day:day withScore:scores[29-i] willReplace:YES];
    }
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Sheffield.KeepTrack" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KeepTrack" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KeepTrack.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
