// fullname: Wuhao Wei 

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaskCategory;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * isCompleted;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timeDue;
@property (nonatomic, retain) NSNumber * timeSpent;
@property (nonatomic, retain) NSDate * timeNotify;
@property (nonatomic, retain) TaskCategory *categorys;

@end
