//
//  surveycategory.m
//  Occupant survey
//
//  Created by Group X on 03/07/15.
//  Copyright (c) 2015 usgbc. All rights reserved.
//

#import "surveycategory.h"

@interface surveycategory ()

@end

@implementation surveycategory



-(void)viewWillAppear:(BOOL)animated{
    opened=NO;
    NSLog(@"Experience is %@",[prefs objectForKey:@"experiencearr"]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(closeit)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    [prefs synchronize];
    
      UILabel *titleView = (UILabel *)self.nv.titleView;
     if (!titleView) {
     titleView = [[UILabel alloc] initWithFrame:CGRectZero];
     titleView.backgroundColor = [UIColor clearColor];
     //   titleView.font = [UIFont boldSystemFontOfSize:20.0];
     
     titleView.textColor = [UIColor blackColor]; // Change to desired color
     titleView.font = [UIFont fontWithName:@"GothamBook" size:11.5];
     self.nv.titleView = titleView;
     }
     titleView.text = [prefs objectForKey:@"name"];
     [titleView sizeToFit];
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
    self.plaquebutton.frame=CGRectMake(self.plaquebutton.frame.origin.x, self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y+15, self.plaquebutton.frame.size.width, self.plaquebutton.frame.size.height+50);
    }
    
    prefs=[NSUserDefaults standardUserDefaults];
    self.humanhide.hidden=[prefs integerForKey:@"humanhide"];
    self.transithide.hidden=[prefs integerForKey:@"transithide"];
    if((int)[prefs integerForKey:@"alert"]==1){
    alert = [[UIAlertView alloc] initWithTitle:@"Save building"
                                                       message:[NSString stringWithFormat:@"Save \"%@\" to the portfolio ?",[prefs objectForKey:@"namevalue"]]
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Yes", nil];
    alert.tag=1003;
    [alert show];
        opened=YES;
    }
    width=[UIScreen mainScreen].bounds.size.width;
    height=[UIScreen mainScreen].bounds.size.height;
    [super viewDidLoad];
    self.vv.layer.cornerRadius=5;
    self.vv.layer.masksToBounds=YES;
    self.plaquebutton.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.plaquebutton.layer.cornerRadius=6;
        self.humanbutton.backgroundColor=[UIColor colorWithRed:0.97 green:.78 blue:.47 alpha:1];
    [self.humanbutton setBackgroundColor:[UIColor colorWithRed:0.968 green:0.737 blue:0 alpha:1]];
    self.humanbutton.layer.masksToBounds=YES;
    //self.humanbutton.transform = CGAffineTransformMakeRotation(5.0*M_PI/180.0);

    //self.humanbutton.imageView.transform=CGAffineTransformMakeRotation(-5.0*M_PI/180.0);
    //self.transitbutton.transform = CGAffineTransformMakeRotation(5.0*M_PI/180.0);
    
    //self.transitbutton.imageView.transform=CGAffineTransformMakeRotation(-5.0*M_PI/180.0);
    
    //[self.humanbutton setImageEdgeInsets:UIEdgeInsetsMake(0.45 * self.view.frame.size.width, 0.47 * self.view.frame.size.height, 0.43 * self.view.frame.size.width, 0.06 * self.view.frame.size.height)];
    //[self.plaquebutton setImageEdgeInsets:UIEdgeInsetsMake(0.19 * self.view.frame.size.width, 0.16 * self.view.frame.size.height, 0.13 * self.view.frame.size.width, 0.13 * self.view.frame.size.height)];
    
    /*
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
   
        [self.humanbutton setImageEdgeInsets:UIEdgeInsetsMake(260, 350, 260, 220)];
     
    }
    else if(width==414 && height==736){
        [self.plaquebutton setImageEdgeInsets:UIEdgeInsetsMake(80, 120, 80, 120)];
        [self.humanbutton setImageEdgeInsets:UIEdgeInsetsMake(188, 45, 180, 45)];
  
    }
    else if(width==375 && height==667){
        [self.plaquebutton setImageEdgeInsets:UIEdgeInsetsMake(80, 110, 80, 110)];
        [self.humanbutton setImageEdgeInsets:UIEdgeInsetsMake(165, 45, 165, 25)];
    
    }
    //top,left,down,right
    else if(width==320 && height==568){
                [self.plaquebutton setImageEdgeInsets:UIEdgeInsetsMake(70, 100, 70, 100)];
        [self.humanbutton setImageEdgeInsets:UIEdgeInsetsMake(133, 145, 143, 135)];
    
    }
    else{
        [self.plaquebutton setImageEdgeInsets:UIEdgeInsetsMake(60, 110, 60, 110)];
        [self.humanbutton setImageEdgeInsets:UIEdgeInsetsMake(122, 45, 122, 35)];
     
    }

    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        [self.transitbutton setImageEdgeInsets:UIEdgeInsetsMake(220, 0, 200, 90)];
    }
    else if(width==414 && height==736){
        [self.transitbutton setImageEdgeInsets:UIEdgeInsetsMake(145, -20, 145, -20)];
    }
    else if(width==375 && height==667){
        [self.transitbutton setImageEdgeInsets:UIEdgeInsetsMake(140, -25, 130, -25)];
    }
    //top,left,down,right
    else if(width==320 && height==568){
        [self.transitbutton setImageEdgeInsets:UIEdgeInsetsMake(103, -16, 103, -16)];
    }
    else{
        [self.transitbutton setImageEdgeInsets:UIEdgeInsetsMake(95, 5, 95, 5)];
    }*/
     
     
    [self.transitbutton setBackgroundColor:[UIColor colorWithRed:.63 green:.63 blue:.57 alpha:1]];
    // Do any additional setup after loading the view.
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

- (IBAction)transitclick:(id)sender {
    /*   [prefs setObject:mut forKey:@"mut"];
     [prefs setObject:mut1 forKey:@"mut1"];
     [prefs setObject:mut2 forKey:@"mut2"];
     */
    
 
    //Correct part
    
    NSMutableArray *mut=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"mainarray"]]mutableCopy];
    if([mut isKindOfClass:[NSString class]]){
    }
    else{
    if(mut.count==0){
        [self performSegueWithIdentifier:@"transit" sender:nil];
    }
    else{
        [prefs setInteger:0 forKey:@"added"];
        [self performSegueWithIdentifier:@"listofroutes" sender:nil];
    }
    }
    
    
}

- (IBAction)gotolist:(id)sender {

}

- (IBAction)addurl:(id)sender {
    alert= [[UIAlertView alloc] initWithTitle:@"Add URL"
                                      message:@"Please enter the URL provided by project manager and select \"Add Project\""
                                     delegate:self
                            cancelButtonTitle:@"Cancel"
                            otherButtonTitles:@"Add Project",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert setTag:1001];
    [alert show];
    opened=YES;
    
}

-(IBAction)humanclick:(id)sender{
    [self performSegueWithIdentifier:@"smiley" sender:self];
    //[prefs setInteger:m forKey:@"smileyvalue"];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Transit status is %d",(int)[prefs integerForKey:@"transitdone"]);
    NSLog(@"Human status is %d",(int)[prefs integerForKey:@"humandone"]);
    opened=NO;
if(alertView.tag==1003){
    if(buttonIndex==1){
        NSLog(@"Hellooooooo");
        int ald=0;
        NSMutableArray *arr;
        arr=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"leed_ids"]] mutableCopy];
        leedid=[prefs objectForKey:@"leedidvalue"];
        NSDictionary *dict;
        if((int)[prefs integerForKey:@"loggedin"]==1){
            NSData *dictionaryData = [prefs objectForKey:@"buildings"];
            NSData *dictionary =[NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
            
            dict =[NSJSONSerialization JSONObjectWithData:dictionary options:0 error:nil];
        }
        else{
            dict=[[NSDictionary alloc] init];
        }
        for (int v=0; v<dict.count; v++) {
             NSString * s=[NSString stringWithFormat:@"%@",[[dict valueForKey:@"leed_id"]objectAtIndex:v]];
            if([s isEqualToString:leedid]){
                ald=1;
                break;
            }
        }

        
        for (int v=0; v<arr.count; v++) {
            NSString * s=[NSString stringWithFormat:@"%@",[arr objectAtIndex:v]];
            if([s isEqualToString:leedid]){
                ald=1;
                break;
            }
        }
        
        
        
        if(ald==0){
            [arr addObject:leedid];
            [prefs setObject:arr forKey:@"leed_ids"];
        }
        
        /*   if((int)[prefs integerForKey:@"saved"]==0){
         */
     /*   NSDictionary *dict;
        if((int)[prefs integerForKey:@"alert"]==0){
        NSData *dictionaryData = [prefs objectForKey:@"buildings"];
        NSData *dictionary =[NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
        
      dict =[NSJSONSerialization JSONObjectWithData:dictionary options:0 error:nil];
        }
        else{
            dict=[[NSDictionary alloc] init];
        }
        NSMutableArray *arr=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"leed_ids"]] mutableCopy];
        [arr addObject:[prefs objectForKey:@"leedidvalue"]];
        for (int v=0; v<dict.count; v++) {
            
            NSString * s=[NSString stringWithFormat:@"%@",[[dict valueForKey:@"leed_id"]objectAtIndex:v]];
            if([[dict valueForKey:@"leed_id"] containsObject:s]){
                ald1=1;
            }
            //       }
            
            if(ald1==1){
                
                alert = [[UIAlertView alloc] initWithTitle:nil message:@"Building already exists" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
                
                [alert show];
                [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
            }
            
        }
        arr=[[NSMutableArray alloc] init];
        
        
        arr=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"leed_ids"]] mutableCopy];
        [arr addObject:[prefs objectForKey:@"leedipdvalue"]];
        NSLog(@"arr is %@",arr);
        
        int ald=0;
        if(arr.count>=2){
            for (int v=0; v<arr.count; v++) {
                
                NSString * s=[NSString stringWithFormat:@"%@",[arr objectAtIndex:v]];
                if([arr containsObject:s]){
                    ald=1;
                }
            }
        }
        else{
            [prefs setObject:arr forKey:@"leed_ids"];
        }
      */
        
        
      
      //  [prefs setObject:arr forKey:@"leed_ids"];
        if(ald==0){
            arr=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"names"]] mutableCopy];
            [arr addObject:[NSString stringWithFormat:@"%@",[prefs objectForKey:@"namevalue"]]];
            [prefs setObject:arr forKey:@"names"];
            arr=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"streets"]] mutableCopy];
            [arr addObject:[prefs objectForKey:@"streetvalue"]];
            [prefs setObject:arr forKey:@"streets"];
            
            
            
            arr=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"scores"]] mutableCopy];
            [arr addObject:[prefs objectForKey:@"pointsvalue"]];
            [prefs setObject:arr forKey:@"scores"];
            arr=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"keys"]] mutableCopy];
            [arr addObject:[prefs objectForKey:@"keyvalue"]];
            [prefs setObject:arr forKey:@"keys"];
            
            arr=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"states"]] mutableCopy];
            [arr addObject:[prefs objectForKey:@"statevalue"]];
            [prefs setObject:arr forKey:@"states"];
            arr=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"certifications"]] mutableCopy];
            if((int)[prefs objectForKey:@"pointsvalue"]>=40 &&(int)[prefs objectForKey:@"pointsvalue"]<=49){
                [arr addObject:@"CERTIFIED"];
                
            }
            else if((int)[prefs objectForKey:@"pointsvalue"]>=50 &&(int)[prefs objectForKey:@"pointsvalue"]<=59){
                [arr addObject:@"SILVER"];
                
            }
            else if((int)[prefs objectForKey:@"pointsvalue"]>=60 &&(int)[prefs objectForKey:@"pointsvalue"]<=79){
                [arr addObject:@"GOLD"];
                
            }
            else if((int)[prefs objectForKey:@"pointsvalue"]>=80){
                [arr addObject:@"PLATINUM"];
                
            }
            else{
                
                [arr addObject:@"NONE"];
                
            }
            [prefs setObject:arr forKey:@"certifications"];
        }
        
        NSLog(@"%@",arr);
        if(ald==1){
            [prefs setInteger:1 forKey:@"url"];
            alert = [[UIAlertView alloc] initWithTitle:nil message:@"Building already exists" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            
            [alert show];
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
            NSMutableArray *currenthuman=[[NSMutableArray alloc]init];
            NSArray *a=[[NSArray alloc] init];
            [currenthuman addObject:@"5"];
            [currenthuman addObject:a];
            leedid=[prefs objectForKey:@"leedidvalue"];
            [prefs setObject:leedid forKey:@"humanbuildingid"];
            [prefs setObject:leedid forKey:@"transportbuildingid"];
            [prefs setObject:currenthuman forKey:@"experiencearr"];
            a=[[NSArray alloc] init];
            [prefs setObject:a forKey:@"mainarray"];
            
        }
        
        NSLog(@"Click Pref values are %@ %@ %@ ",[prefs objectForKey:@"names"],[prefs objectForKey:@"leed_ids"],[prefs objectForKey:@"scores"]);
       
       NSMutableArray *humanexarray =[[NSMutableArray arrayWithArray :[prefs objectForKey:@"humanexarray"]]mutableCopy];
        
                NSMutableArray *a=[[NSMutableArray alloc] init];
                [a addObject:@"5"];
                NSArray *x=[[NSArray alloc] init];
                [a addObject:x];
                [humanexarray insertObject:a atIndex:0];
        
       NSMutableArray *transportationarray =[[NSMutableArray arrayWithArray :[prefs objectForKey:@"transportationarray"]]mutableCopy];
            NSMutableArray *ar=[[NSMutableArray alloc] init];
        [prefs setObject:leedid forKey:@"humanbuildingid"];
        [prefs setObject:leedid forKey:@"transportbuildingid"];
            [prefs setObject:ar forKey:@"mainarray"];
            [ar addObject:transportationarray];
        
        
        [prefs setObject:ar forKey:@"transportationarray"];
        
    //    [prefs setObject:humanexarray forKey:@"humanexarray"];
        [prefs setObject:a forKey:@"experiencearr"];

    }
    else{
        [prefs setInteger:1 forKey:@"url"];
        NSMutableArray *currenthuman=[[NSMutableArray alloc]init];
        NSArray *a=[[NSArray alloc] init];
        [currenthuman addObject:@"5"];
        [currenthuman addObject:a];
        leedid=[prefs objectForKey:@"leedidvalue"];
        [prefs setObject:leedid forKey:@"humanbuildingid"];
        [prefs setObject:leedid forKey:@"transportbuildingid"];
        [prefs setObject:currenthuman forKey:@"experiencearr"];
        a=[[NSArray alloc] init];
         [prefs setObject:a forKey:@"mainarray"];
    }
}
        [prefs setInteger:0 forKey:@"alert"];
}

-(void)dismissAlert:(UIAlertView *)alert{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)closeit{
    if(opened==YES){
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
}

-(void)humantotransit{
    
    NSMutableArray *mut = [[NSMutableArray alloc] initWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"mainarray"] mutableCopy]];
    if(mut.count == 0){
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *more = [mainstoryboard instantiateViewControllerWithIdentifier:@"more"];
        //UIViewController *listroutes = [mainstoryboard instantiateViewControllerWithIdentifier:@"listroutes"];
        UIViewController *addnewroute = [mainstoryboard instantiateViewControllerWithIdentifier:@"addnewroute"];
        UINavigationController *rootvc = [self navigationController];
        NSMutableArray *controllers = [[rootvc viewControllers] mutableCopy];
        [controllers removeAllObjects];
        UIViewController *v = [mainstoryboard instantiateViewControllerWithIdentifier:@"listofassets"];
        int grid = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"grid"];
        if(grid == 1){
            v = [mainstoryboard instantiateViewControllerWithIdentifier:@"grid"];
        }else{
            v = [mainstoryboard instantiateViewControllerWithIdentifier:@"listofassets"];
        }
        UIViewController *listofassets = [mainstoryboard instantiateViewControllerWithIdentifier:@"projectslist"];
        if(grid == 1){
            listofassets = [mainstoryboard instantiateViewControllerWithIdentifier:@"gridvc"];
        }else{
            listofassets = [mainstoryboard instantiateViewControllerWithIdentifier:@"projectslist"];
        }

        [controllers addObject:listofassets];
        [controllers addObject:more];
        [controllers addObject:addnewroute];
        //self.navigationController.hidesBarsOnTap = NO;
        //self.navigationController.hidesBarsOnSwipe = NO;
        //self.navigationController.hidesBarsWhenVerticallyCompact = NO;
        [self.navigationController setViewControllers:controllers animated:YES];
        
    }else{
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *v = [mainstoryboard instantiateViewControllerWithIdentifier:@"listofassets"];
        int grid = (int)[[NSUserDefaults standardUserDefaults]integerForKey:@"grid"];
        if(grid == 1){
            v = [mainstoryboard instantiateViewControllerWithIdentifier:@"grid"];
        }else{
            v = [mainstoryboard instantiateViewControllerWithIdentifier:@"listofassets"];
        }
        UIViewController *listofassets = [mainstoryboard instantiateViewControllerWithIdentifier:@"projectslist"];
        if(grid == 1){
            listofassets = [mainstoryboard instantiateViewControllerWithIdentifier:@"gridvc"];
        }else{
            listofassets = [mainstoryboard instantiateViewControllerWithIdentifier:@"projectslist"];
        }
        
        
        
        UIViewController *more = [mainstoryboard instantiateViewControllerWithIdentifier:@"more"];
        UIViewController *listroutes = [mainstoryboard instantiateViewControllerWithIdentifier:@"listroutes"];
        UINavigationController *rootvc = [self navigationController];
        NSMutableArray *controllers = [[rootvc viewControllers] mutableCopy];
        [controllers removeAllObjects];
        [controllers addObject:listofassets];
        [controllers addObject:more];
        [controllers addObject:listroutes];
        //self.navigationController.hidesBarsOnTap = NO;
        //self.navigationController.hidesBarsOnSwipe = NO;
        //self.navigationController.hidesBarsWhenVerticallyCompact = NO;
        [self.navigationController setViewControllers:controllers animated:YES];
    }
    
}

- (IBAction)plaque:(id)sender {
    NSLog(@"asdasd");
    [prefs setInteger:0 forKey:@"row"];
    [self performSegueWithIdentifier:@"gotocontent" sender:nil];
}

- (IBAction)gobacktolist:(id)sender {
    if ((int)[prefs integerForKey:@"url"]==1) {
        [prefs setInteger:0 forKey:@"url"];
        NSArray *a=[[NSArray alloc] init];
    }
    [self performSegueWithIdentifier:@"gotolist" sender:nil];
}
@end
