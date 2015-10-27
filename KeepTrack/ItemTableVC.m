// fullname: Wuhao Wei 

#import "ItemTableVC.h"
#import "Item.h"


@interface ItemTableVC ()

@end

@implementation ItemTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.ar
    
    
    _itemTextfield.delegate=self;
    [self configureTitle];
    self.tableView.tableFooterView=[[UIView alloc]init];
    
  
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [textField.text stringByTrimmingCharactersInSet:charSet];
    if ([trimmedString isEqualToString:@""]) {
        [textField resignFirstResponder];
        return NO;
    }
    [self insertNewObject:textField.text];
    [textField resignFirstResponder];
    return NO;
}

#pragma CURD operations

-(NSArray*) fetchItems
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext]];
    
    NSPredicate*predicate=[NSPredicate predicateWithFormat:@"categorys == %@",self.categoryObject];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = NULL;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Error : %@\n", [error localizedDescription]);
    }
    
    
    return array;
}


- (void)insertNewObject:(NSString*)itemName {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    item.name=itemName;
    item.categorys=self.categoryObject;
    item.timeDue=[NSDate dateWithTimeIntervalSinceNow:60*60*24*365];
  
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}





- (void)configureTitle {
    // Update the user interface for the detail item.
    if (self.categoryObject) {
      
        self.navigationItem.title=self.categoryObject.name;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    return [[self.fetchedResultsController sections]count];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[[self.fetchedResultsController sections]objectAtIndex:section]numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"itemTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    UIColor *bgColor = [self createBackGroundColorByPriority:[self getPriorityF:[self.fetchedResultsController objectAtIndexPath:(NSIndexPath *)indexPath]]];
  //  [cell setBackgroundColor:bgColor];
    cell.textLabel.backgroundColor=bgColor;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = item.name;
    
    
    if ([item.isCompleted intValue]) {
        //checked
        cell.imageView.image=[UIImage imageNamed:@"checked.png"];
        
        
    }
    else
    {
        //unchecked
        cell.imageView.image=[UIImage imageNamed:@"unchecked.png"];
        
    }
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleChecking:)];
    [cell.imageView addGestureRecognizer:tap];
    cell.imageView.userInteractionEnabled=YES;
    
   
}

-(int)getPriorityF:(Item*)item
{
    
    
    /*
      priority:
           priority = 7 if timeDue not set
           priority = 6 if more than 3 months left
           priority = 5 if more than 1 month left
           priority = 4 if more than 1 week left
           prioriry = 3 if more than 3 days left
           priority = 2 if more than 1 day
           priority = 1 if today
     */
    int priority=7;
    
    if (item.timeDue==nil) {
        //not set
        return priority;
    }
    else
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
        NSDate *startDate = [calendar dateFromComponents:components];
        NSDate *endDate=nil;
        
         //later than 3 months
        [components setDay:0];
        [components setYear:0];
        [components setMonth:3];
        endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
      
        if ([item.timeDue compare:endDate]==NSOrderedDescending) {
            return 6;
        }
        
        //later than 1 month
        [components setDay:0];
        [components setYear:0];
        [components setMonth:1];
        endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
        if ([item.timeDue compare:endDate]==NSOrderedDescending) {
            return 5;
        }
        
        //later than 1 week
        [components setDay:7];
        [components setYear:0];
        [components setMonth:0];
        endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
        if ([item.timeDue compare:endDate]==NSOrderedDescending) {
            return 4;
        }
        
        //later than 3 days
        [components setDay:3];
        [components setYear:0];
        [components setMonth:0];
        endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
        if ([item.timeDue compare:endDate]==NSOrderedDescending) {
            return 3;
        }
        
        //later than 1 day
        [components setDay:3];
        [components setYear:0];
        [components setMonth:0];
        endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
        if ([item.timeDue compare:endDate]==NSOrderedDescending) {
            return 2;
        }
        
        
    }
    
    //today
    return 1;
}

#pragma mark - frank test
//create a random color for tableview cell test background color
-(UIColor *)createBackGroundColorByPriority: (int)priority
{
    float alPha = 0.0;
    switch (priority) {
        case 1:
            alPha = 1.0;
            break;
        case 2:
            alPha = 0.7;
            break;
        case 3:
            alPha = 0.4;
            break;
        case 4:
            alPha = 0.3;
            break;
        case 5:
            alPha = 0.05;
            break;
        case 6:
            alPha = 0.0;
            break;
        case 7:
            alPha = 0.0;
            break;
        default:
            break;
    }
    UIColor *color = [UIColor colorWithRed:255 green:0 blue:0 alpha:alPha];

    return color;
}


#pragma Operations on cell
-(void)handleChecking:(UITapGestureRecognizer*)tapRecognizer
{
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
  
    
 
    
    CGPoint tapLocation=[tapRecognizer locationInView:self.tableView];
    NSIndexPath*tappedIndexPath=[self.tableView indexPathForRowAtPoint:tapLocation];
    Item*item=[self.fetchedResultsController objectAtIndexPath:tappedIndexPath];
    if (item.isCompleted.intValue)
    {
        item.isCompleted=[NSNumber numberWithInt:0];
    }
    else
    {
        item.isCompleted=[NSNumber numberWithInt:1];
    }

    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    


    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];

       
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"addTask"]) {
        NSLog(@"add task segue");
      

    }
    else if([[segue identifier] isEqualToString:@"taskDetail"])
    {
       
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        TaskDetailVC *vc=[segue destinationViewController];
        vc.itemObject=[[self fetchedResultsController] objectAtIndexPath:indexPath];
        vc.timeToday=self.timeToday;
        vc.endBlock=^{
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        };
    }

}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sec = [self.fetchedResultsController sections][section];
  
    NSString * todo=[NSString stringWithFormat:@"ToDo"];
    NSString * done=[NSString stringWithFormat:@"Done"];
    if ([(NSString*)[sec name]compare:@"0"]==NSOrderedSame) {
        return todo;
    }
    return done;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    [NSFetchedResultsController deleteCacheWithName:@"items"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortItems = [[NSSortDescriptor alloc] initWithKey:@"timeDue" ascending:YES];
    NSSortDescriptor *sortSections=[[NSSortDescriptor alloc] initWithKey:@"isCompleted" ascending:YES];
    NSArray *sortDescriptors = @[sortSections,sortItems];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"categorys == %@",self.categoryObject];
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"isCompleted" cacheName:@"items"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
