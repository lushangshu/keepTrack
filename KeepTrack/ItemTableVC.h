// fullname: Wuhao Wei 

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TaskCategory.h"
#import "TaskDetailVC.h"
#import "ScoreEachDay.h"

@interface ItemTableVC : UITableViewController<NSFetchedResultsControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (strong) ScoreEachDay* timeToday;
@property (strong)TaskCategory* categoryObject;

@property (weak, nonatomic) IBOutlet UITextField *itemTextfield;
-(NSArray*) fetchItems;//to delete for testing


@end
