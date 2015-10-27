// fullname: Wuhao Wei 

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ScoreEachDay : NSManagedObject

@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * day;

@end
