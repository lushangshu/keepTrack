// fullname: Wuhao Wei 

#import <UIKit/UIKit.h>
#import "Item.h"
#import "ItemTableVC.h"
#import "CircularTimer.h"
#import "ScoreEachDay.h"
@interface TaskDetailVC : UIViewController<UITextFieldDelegate>


typedef void(^TaskDetailBlock)(void);

@property (strong) NSDate*timeDue;
@property (assign) int secondsLeft;
@property (strong) UIDatePicker* datePickerForDuedate;
@property (strong) UIDatePicker* datePickerForNotification;
@property (strong) Item*itemObject;
@property (nonatomic, strong) CircularTimer *circularTimer;
@property (assign) int scoreForItemAll;
@property (assign) int scoreForItemToday;

@property (nonatomic, copy) TaskDetailBlock endBlock;
@property (strong,nonatomic) UILocalNotification *localNotific;

@property (strong) ScoreEachDay* timeToday;

@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *taskField;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UITextField *notifyTextfield;

- (IBAction)startCountdown:(id)sender;


- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
