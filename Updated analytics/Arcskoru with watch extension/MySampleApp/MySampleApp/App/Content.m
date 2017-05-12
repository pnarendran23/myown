//
//  ViewController.m
//  racetrack
//
//  Created by Group X on 10/07/15.
//  Copyright (c) 2015 usgbc. All rights reserved.
//

#import "Content.h"


@interface Content ()
@property (weak, nonatomic) IBOutlet UIButton *closebtn;

@end

@implementation Content
int i,width,height;
NSUserDefaults *prefs;
-(void)viewWillAppear:(BOOL)animated{
    prefs=[NSUserDefaults standardUserDefaults];
    NSArray *subviews = self.pageViewController.view.subviews;
    UIPageControl *thisControl = nil;
    for (int i=0; i<[subviews count]; i++) {
        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]]) {
            thisControl = (UIPageControl *)[subviews objectAtIndex:i];
        }
    }
    
    
    
    width=[UIScreen mainScreen].bounds.size.width;
    height=[UIScreen mainScreen].bounds.size.height;
    NSLog(@"%d %d",width,height);
    thisControl.hidden = true;
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
    self.pageViewController.view.frame = CGRectMake(0, self.topview.frame.size.height, self.view.frame.size.width, 0.9*fabs(self.previous.layer.frame.size.height - self.previous.layer.frame.origin.y));
    }
    else if(width==320 && height==568){
    self.pageViewController.view.frame = CGRectMake(0, self.topview.frame.size.height, self.view.frame.size.width, 0.9*fabs(self.previous.layer.frame.size.height - self.previous.layer.frame.origin.y));
    }
    else if(width==320 && height==480){
        self.pageViewController.view.frame = CGRectMake(0, self.topview.frame.size.height, self.view.frame.size.width, 0.9*fabs(self.previous.layer.frame.size.height - self.previous.layer.frame.origin.y));
    }
    else if (width==375 && height==667){
        self.pageViewController.view.frame = CGRectMake(0, self.topview.frame.size.height, self.view.frame.size.width, 0.9*fabs(self.previous.layer.frame.size.height - self.previous.layer.frame.origin.y)); //self.view.frame.size.height-120);
    }
    else if (width==414 && height==736){
        self.pageViewController.view.frame = CGRectMake(0, self.topview.frame.size.height, self.view.frame.size.width, 0.9*fabs(self.previous.layer.frame.size.height - self.previous.layer.frame.origin.y));
    }
    UIPageControl *pageControlAppearance = [UIPageControl appearanceWhenContainedIn:[UIPageViewController class], nil];
    pageControlAppearance.pageIndicatorTintColor = [UIColor blackColor];
    pageControlAppearance.currentPageIndicatorTintColor = [UIColor darkGrayColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[_closebtn layer] setCornerRadius:7];
    //building_details
    NSDictionary * dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"building_details"]];
    NSArray * notificationscount = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]objectForKey:@"notifications"]];
    [[[[self tabbar]items] objectAtIndex:4] setBadgeValue:[NSString stringWithFormat:@"%d",notificationscount.count]];
    
    NSLog(@"Dic dic %@",dict[@"name"]);
    self.buildingname.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor=[UIColor colorWithRed:0.922 green: 0.922 blue:0.922 alpha:1];
    //self.topview.backgroundColor=[UIColor colorWithRed:0.922 green: 0.922 blue:0.922 alpha:1];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,self.topview.bounds.size.height-5, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor blackColor];
  //  [self.topview addSubview:lineView];
    

    // Create the data model
    int i;
    i=0;
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];

    
    
    
      UILabel *titleView = (UILabel *)self.nv.titleView;
     if (!titleView) {
     titleView = [[UILabel alloc] initWithFrame:CGRectZero];
     titleView.backgroundColor = [UIColor clearColor];
     //   titleView.font = [UIFont boldSystemFontOfSize:20.0];
     
         titleView.numberOfLines=2;
     titleView.textColor = [UIColor blackColor]; // Change to desired color
     titleView.font = [UIFont fontWithName:@"GothamBook" size:11.5];
         titleView.numberOfLines=2;
     self.nv.titleView = titleView;
     }
     titleView.text = [prefs objectForKey:@"name"];
     [titleView sizeToFit];
     
    
    _pageTitles = @[@"Over 200 Tips and Tricks", @"Discover Hidden Features", @"Bookmark Favorite Tip", @"Free Regular Update",@"asd",@"asdas"];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;

    
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:(int)[prefs integerForKey:@"row"]];
    self.pctrl.currentPage=(int)[prefs integerForKey:@"row"];

    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self.tabbar.delegate = self;
    self.tabbar.selectedItem = [self.tabbar.items objectAtIndex:0];
    [self.view bringSubviewToFront:self.tabbar];
    [self.view bringSubviewToFront:self.topview];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if([item.title isEqualToString:@"Credits/Actions"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"performrootsegue" object:nil userInfo:@{@"seguename":@"listofactions"}];
        
    }else if([item.title isEqualToString:@"Analytics"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"performrootsegue" object:nil userInfo:@{@"seguename":@"beforeanalytics"}];
    }
    else if([item.title isEqualToString:@"Manage"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"performrootsegue" object:nil userInfo:@{@"seguename":@"manage"}];
    }
    else if([item.title isEqualToString:@"More"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"performrootsegue" object:nil userInfo:@{@"seguename":@"more"}];
    }else if([item.title isEqualToString:@"Plaque"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"performrootsegue" object:nil userInfo:@{@"seguename":@"plaque"}];
    }
}


- (IBAction)logout:(id)sender {
   // [self dismissViewControllerAnimated:YES completion:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"performsegue" object:nil userInfo:@{@"seguename":@"listofassets"}];
}


- (IBAction)startWalkthrough:(id)sender{
    NSLog(@"asadasdasdas ");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
    -(UIInterfaceOrientationMask)supportedInterfaceOrientations{
        return UIInterfaceOrientationMaskPortrait;
    }

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    self.pctrl.currentPage=index;
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    prefs=[NSUserDefaults standardUserDefaults];
    
    [prefs setInteger:index forKey:@"row"];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 0.7*self.view.frame.size.height);
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        // code for landscape orientation
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    prefs=[NSUserDefaults standardUserDefaults];

    index++;
    self.pctrl.currentPage=index;
    [prefs setInteger:index forKey:@"row"];

    if (index == [self.pageTitles count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}





- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
        i=(int)index;
    UIColor *color;
    if(i==1){
        color=[UIColor colorWithRed:0.776 green: 0.859 blue:0.122 alpha:1]; //Energy
    }
    else if(i==2){
        
        color=[UIColor colorWithRed:0.259 green: 0.741 blue:0.961 alpha:1];
    }
    else if(i==3){
        color=[UIColor colorWithRed:0.443 green: 0.769 blue:0.624 alpha:1];
    }
    else if(i==4){
        color=[UIColor colorWithRed:0.573 green: 0.557 blue:0.498 alpha:1];
    }
    else if(i==5){
        color=[UIColor colorWithRed:0.937 green: 0.62 blue:0.153 alpha:1];
    }
    else{
        color=[UIColor colorWithRed:0.619 green: 0.55 blue:1 alpha:1];
    }
    self.pctrl.pageIndicatorTintColor = [UIColor blackColor];
    self.pctrl.currentPageIndicatorTintColor=color;
    
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }

    if(i<5){
        self.next.userInteractionEnabled=YES;
    }
    else{
        self.next.userInteractionEnabled=NO;
    }

    
    if(i>0){
        self.previous.userInteractionEnabled=YES;
    }
    else{
        self.previous.userInteractionEnabled=NO;
    }
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.titleText = self.pageTitles[index];
    i=index;
    pageContentViewController.pageIndex = index;
    [self.view bringSubviewToFront:self.tabbar];
    [self.view bringSubviewToFront:self.topview];
    return pageContentViewController;
}

- (IBAction)next:(id)sender {
    i++;
    self.pctrl.currentPage=i;
    [prefs setInteger:i forKey:@"row"];
    PageContentViewController *startingViewController = [self viewControllerAtIndex:i];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

- (IBAction)back:(id)sender {
    i--;
    self.pctrl.currentPage=i;
    [prefs setInteger:i forKey:@"row"];
    PageContentViewController *startingViewController = [self viewControllerAtIndex:i];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}
@end
