







#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface Content : UIViewController <UIPageViewControllerDataSource, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;

- (IBAction)startWalkthrough:(id)sender;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (weak, nonatomic) IBOutlet UITabBarItem *plaquebtn;
@property (weak, nonatomic) IBOutlet UIView *topview;
@property (weak, nonatomic) IBOutlet UILabel *buildingname;

- (IBAction)next:(id)sender;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *previous;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nav1;
@property (weak, nonatomic) IBOutlet UIPageControl *pctrl;
@property (weak, nonatomic) IBOutlet UINavigationItem *nv;

@end

