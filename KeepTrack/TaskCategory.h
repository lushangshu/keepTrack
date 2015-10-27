// fullname: Wuhao Wei 

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface TaskCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *items;
@end

@interface TaskCategory (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
