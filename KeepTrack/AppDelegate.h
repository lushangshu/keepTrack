// fullname: Wuhao Wei 

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ScoreEachDay.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong) ScoreEachDay* scoreToday;
@property (strong) NSArray * topEightCategory;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

