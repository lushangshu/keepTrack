// fullname: Wuhao Wei 

#import "TaskDetailVC.h"
#import "Macro.h"


@interface TaskDetailVC () <UIPickerViewDelegate>



@end

@implementation TaskDetailVC
@synthesize localNotific;

- (void)viewDidLoad {
    [super viewDidLoad];
    _dueDateTextField.delegate=self;
    _datePickerForDuedate=[[UIDatePicker alloc]init];
    _datePickerForNotification=[[UIDatePicker alloc]init];
    _scoreLabel.text=[NSString stringWithFormat:@"%@",_itemObject.timeSpent];
    _scoreForItemToday=0;
    [self setDatepickerForDueDate];
    [self setDatepickerForNotification];
    [self resetAllTextfield];
    localNotific = [[UILocalNotification alloc]init];
}




-(void) resetAllTextfield
{
    
    _taskField.text=_itemObject.name;

    if (_itemObject.timeDue) {
       
        _dueDateTextField.text=[self nsdateToString:_itemObject.timeDue];
    }
    else
    {
        _dueDateTextField.text=@"";
    }
    
    if (_itemObject.timeNotify) {
        _notifyTextfield.text=[self nsdateToString:_itemObject.timeNotify];
    }
    else
    {
        _notifyTextfield.text=@"";
    }
}

// timer circle
- (void)createCircle
{
    UIColor*color1=[UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    UIColor*color2=[UIColor colorWithRed:0 green:255 blue:0 alpha:1];
    NSDate *now=[NSDate dateWithTimeIntervalSinceNow:0];
    NSDate *stop=[NSDate dateWithTimeIntervalSinceNow:TIME_BLOCK];
    
    
    self.circularTimer = [[CircularTimer alloc] initWithPosition:CGPointMake(200.0f, 200.0f)
                                                          radius:30
                                                  internalRadius:25
                                               circleStrokeColor:color1
                                         activeCircleStrokeColor:color2
                                                     initialDate:now
                                                       finalDate:stop
                                                   startCallback:^{
                                                       
                                                   }
                                                     endCallback:^{
                                                         if (self.circularTimer.iscompleted) {
                                                             _scoreForItemAll++;
                                                              self.timeToday.score=[NSNumber numberWithInt:[self.timeToday.score intValue]+1];
                                                             self.itemObject.timeSpent=
                                                             [NSNumber numberWithInt:[self.itemObject.timeSpent intValue]+1];
                                                         }
                                                         [self.startBtn setTitle:@"start" forState:UIControlStateNormal];

                                                         _scoreLabel.text=[NSString stringWithFormat:@"%d",_scoreForItemAll];
                                                         
                                                         [self.circularTimer removeFromSuperview];
                                                         
                                                     }];
    
    
    
    [self.view addSubview:self.circularTimer];
}




#pragma mark - set date textfield input source
-(void) setDatepickerForDueDate
{
    //set datepicker as duedate input source
    
    _datePickerForDuedate.datePickerMode=UIDatePickerModeDate;
    _dueDateTextField.inputView=_datePickerForDuedate;
    UIToolbar*toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    //cancel buttonitem on uitoolbar
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithTitle:@"Remove" style:UIBarButtonItemStylePlain target:self action:@selector(removeDuedatePicker)];
    
    //title buttonitem on uitoolbar
    UIBarButtonItem *title=[[UIBarButtonItem alloc]initWithTitle:@"DueDate" style:UIBarButtonItemStylePlain target:nil action:nil];
    //done buttonitem on uitoolbar
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                                                        action:@selector(doneDuedatePicker)];
    //fixed buttonitem for adjust item position
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                 target: nil action: nil];
    
    toolBar.items = [NSArray arrayWithObjects:left,fixedButton,title,fixedButton,right, nil];
    _dueDateTextField.inputAccessoryView = toolBar;
    
}

#pragma mark - notification
-(void) setDatepickerForNotification
{
    //set datepicker as duedate input source
    
    _datePickerForNotification.datePickerMode=UIDatePickerModeDateAndTime;
    _notifyTextfield.inputView=_datePickerForNotification;
    UIToolbar*toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    //cancel buttonitem on uitoolbar
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithTitle:@"Remove" style:UIBarButtonItemStylePlain target:self action:@selector(removeNotifydatePicker)];
    
    //title buttonitem on uitoolbar
    UIBarButtonItem *title=[[UIBarButtonItem alloc]initWithTitle:@"NotifyDate" style:UIBarButtonItemStylePlain target:nil action:nil];
    //done buttonitem on uitoolbar
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                                                        action:@selector(doneNotifydatePicker)];
    //fixed buttonitem for adjust item position
    UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                 target: nil action: nil];
    
    toolBar.items = [NSArray arrayWithObjects:left,fixedButton,title,fixedButton,right, nil];
    _notifyTextfield.inputAccessoryView = toolBar;
    
}


-(void)removeNotifydatePicker
{
    if ([self.view endEditing:NO]) {
        _notifyTextfield.text = @"";
        [self rmLocalNotification:_itemObject.timeNotify];
        _itemObject.timeNotify=nil;
    
    }
}
-(void)doneNotifydatePicker
{
    if ([self.view endEditing:NO]) {
        _notifyTextfield.text = [self nsdateToString:_datePickerForNotification.date];
        [self rmLocalNotification:_itemObject.timeNotify];
        _itemObject.timeNotify=_datePickerForNotification.date;
        
    }
    
}

-(void)setLocalNotification:(NSDate *)date
{
   
    localNotific=[[UILocalNotification alloc]init];
    [localNotific setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",date],
                               @"uniquekey", nil]];

    localNotific.fireDate = date;
    localNotific.alertBody = [NSString stringWithFormat:@"notification:%@",_itemObject.name];
    localNotific.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication ]scheduleLocalNotification:localNotific];
}
-(void)rmLocalNotification:(NSDate *)date
{
  
    NSString *todelete= [NSString stringWithFormat:@"%@",date];

    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString* date= [userInfoCurrent valueForKey:@"uniquekey"];
        
      
        if ([date isEqualToString:todelete])
        {
            //Cancelling local notification
            [app cancelLocalNotification:oneEvent];
            break;
        }
    }

}



// NSDate to NSString
-(NSString*) nsdateToString:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:nil];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:nil];
    NSString* res = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    return res;
}

#pragma mark - picker 

//for due date
-(void)doneDuedatePicker
{
    if ([self.view endEditing:NO]) {
        _dueDateTextField.text = [self nsdateToString:_datePickerForDuedate.date];
        _itemObject.timeDue=_datePickerForDuedate.date;
        
        
        
    }
}

-(void)removeDuedatePicker
{
    
    if ([self.view endEditing:NO]) {
        _dueDateTextField.text = @"";
        _itemObject.timeDue=nil;
    }
    
}

#pragma mark - segue data
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailSegue"]) {
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)startCountdown:(id)sender {
    
    if ([[self.startBtn currentTitle] isEqualToString:@"start"]) {

        [self.startBtn setTitle:@"discard" forState:UIControlStateNormal];
        if (self.circularTimer) {
            
            [self.circularTimer removeFromSuperview];
            self.circularTimer=nil;
        }
        [self createCircle];

    }
    else
    {
        
        [self.startBtn setTitle:@"start" forState:UIControlStateNormal];
        [self.circularTimer stop];
        self.circularTimer=nil;
    }
  }



- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    ItemTableVC* itemTableVC=(ItemTableVC*)([self.navigationController topViewController]);
    NSManagedObjectContext *context = [itemTableVC.fetchedResultsController managedObjectContext];
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    if (_itemObject.timeNotify) {
        [self setLocalNotification:_itemObject.timeNotify];
    }
    
    [itemTableVC fetchItems];
    if (self.endBlock != nil) {
        self.endBlock();
    }
   
    
}
@end
