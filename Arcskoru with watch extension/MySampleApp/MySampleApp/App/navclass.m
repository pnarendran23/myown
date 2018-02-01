//
//  navclass.m
//  Arcskoru
//
//  Created by Group X on 15/03/17.
//
//

#import "navclass.h"
#import "buttonarray.h"
#import "addsurvey.h"
#import "smiley.h"
#import "buttonarrayforhumansurvey.h"
@interface navclass ()

@end

@implementation navclass

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (NSUInteger)supportedInterfaceOrientations
{
    NSUInteger orientation = UIInterfaceOrientationMaskAll;
    NSLog(@"%@",[self.visibleViewController class]);
    if ([self.visibleViewController isMemberOfClass:[buttonarray class]] || [self.visibleViewController isMemberOfClass:[addsurvey class]] || [self.visibleViewController isMemberOfClass:[smiley class]]) {
        orientation = (UIInterfaceOrientationPortrait |  UIInterfaceOrientationPortraitUpsideDown);
    }
    
    if([[self.visibleViewController restorationIdentifier] isEqualToString:@"more"]){
        [self setNavigationBarHidden:NO animated:NO];
        self.hidesBarsWhenVerticallyCompact = NO;
        self.hidesBarsWhenKeyboardAppears = NO;
        self.hidesBarsOnTap = NO;
        self.hidesBarsOnSwipe = NO;
    }
    
    return orientation;
}



- (BOOL)shouldAutorotate
{
    return YES;
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

@end
