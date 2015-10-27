// fullname: Wuhao Wei 

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ScoreEachDay.h"

@interface CategoryTableVC : UITableViewController <NSFetchedResultsControllerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong) ScoreEachDay* timeToday;


@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;

@end

