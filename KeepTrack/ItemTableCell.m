// fullname: Wuhao Wei 


#import "ItemTableCell.h"

@implementation ItemTableCell

-(void)drawRect:(CGRect)rect
{
    CGRect square =
    CGRectMake(0,0,20 ,20);
    [[UIColor redColor] set];
    UIRectFill(square);
    [self setBackgroundColor:[UIColor whiteColor]];
    
    
}


@end
