//
//  smiley.m
//  Occupant survey
//
//  Created by Group X on 03/07/15.
//  Copyright (c) 2015 usgbc. All rights reserved.
//

#import "smiley.h"
#import "credentialsobjc.h"
@interface smiley ()

@end

@implementation smiley
@synthesize slider;
 NSString* subscription_key = @"e6aecd40e07c40718a0b3ed9a0cc609d";//@"f94b34f0576f4a85b3c0c22eefb625b3";
 NSString* domain_url = @"https://api.usgbc.org/stg/leed/";
 NSString* survey_url = @"https://stg.app.arconline.io/app/project/";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.spinner.layer setCornerRadius:10];
    [self.spinner.layer setMasksToBounds:YES];
    [self.spinner setHidden:YES];
    self.navigationController.delegate = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"building_details"]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans" size:17], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",dict[@"name"]]];
    opened=NO;
    self.vv.layer.cornerRadius=5;
    prefs=[NSUserDefaults standardUserDefaults];
    [slider setMaximumTrackTintColor:[UIColor whiteColor]];
    submitteddonthide=(int)[prefs integerForKey:@"humanhide"];
    numbers = @[@(-5), @(-4), @(-3), @(-2), @(-1), @(0), @(1),@(2),@(3),@(4),@(5)];
    // slider values go from 0 to the number of values in your numbers array
    NSInteger numberOfSteps = ((float)[numbers count] - 1);
    slider.maximumValue = numberOfSteps;
    slider.minimumValue = 0;
    if([[NSMutableArray arrayWithArray:[prefs objectForKey:@"experiencearr"]] count] > 0){
    experiencearr=[[[NSMutableArray arrayWithArray:[prefs objectForKey:@"experiencearr"]] objectAtIndex:1]mutableCopy];
    }
    NSLog(@"exp is %@",[prefs objectForKey:@"experiencearr"]);
    NSLog(@"humanex is %@",[prefs objectForKey:@"humanexarray"]);    
    position=[[[prefs objectForKey:@"experiencearr"] objectAtIndex:0] intValue];
    [slider setValue:position animated:NO];
    width=[UIScreen mainScreen].bounds.size.width;
    height=[UIScreen mainScreen].bounds.size.height;
    if(width > height){
        int temp = width;
        width = height;
        height = temp;
    }
    face = [CAShapeLayer layer];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
   	facePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 0.56 * width, 0.56 * width)];
        }
    else{
        	facePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 0.56 * width, 0.56 * width)];
    }
    face.path = facePath.CGPath;
    face.fillColor=[UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:face];
    lefteye = [CAShapeLayer layer];
    [self.view.layer addSublayer:lefteye];
    [lefteye setFillColor:[[UIColor colorWithRed:.96 green:.77 blue:.27 alpha:1] CGColor]];
    
    righteye = [CAShapeLayer layer];
    [self.view.layer addSublayer:righteye];
    [righteye setFillColor:[[UIColor colorWithRed:.96 green:.77 blue:.27 alpha:1] CGColor]];
    face.frame = CGRectMake(0.22 * width, 0.3 * height, 0.56 * width, 0.56 * width);
    [lefteye setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.34 * width, 0.41 * height, 0.04 * width, 0.04 * width)] CGPath]];
    [righteye setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.6 * width, 0.41 * height, 0.04 * width, 0.04 * width)] CGPath]];
    
    /*if(width==320 && height==568){
        face.frame = CGRectMake(71.6, 174.34, 180, 180);
        [lefteye setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(110, 235, 15, 15)] CGPath]];
        [righteye setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(195, 235, 15, 15)] CGPath]];
    }
    else if(width==320 && height==480){
        face.frame = CGRectMake(71.6, 124.34, 180, 180);
        [lefteye setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(110, 185, 15, 15)] CGPath]];
        [righteye setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(195, 185, 15, 15)] CGPath]];
    }
    else if(width==375 && height==667){
        face.frame = CGRectMake(98.6, 224.34, 180, 180);
        [lefteye setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(137, 285, 15, 15)] CGPath]];
        [righteye setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(222, 285, 15, 15)] CGPath]];
    }
    
    else if(width==414 && height==736){
        face.frame = CGRectMake(118.6, 264.34, 180, 180);
        [lefteye setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(157, 325, 15, 15)] CGPath]];
        [righteye setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(242, 325, 15, 15)] CGPath]];
    }
    else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        face.frame = CGRectMake(201.6, 264.34, 350, 350);
        [lefteye setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(267, 355, 28, 28)] CGPath]];
        [righteye setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(452, 355, 28, 28)] CGPath]];
    }*/

    
     //[[UIColor colorWithRed:.96 green:.77 blue:.27 alpha:1] CGColor]];
    
    // As the slider moves it will continously call the -valueChanged:
    slider.continuous = YES; // NO makes it call only once you let go
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    NSLog(@"%@",experiencearr);
    [self valueChanged:slider];
    [self.view bringSubviewToFront:self.spinner];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)valueChanged:(UISlider *)sender {
    
    if((int)indx>5){
        [self.submitbtn setTitle:@"Submit" forState:UIControlStateNormal];
    }else{
                [self.submitbtn setTitle:@"Next" forState:UIControlStateNormal];
    }
    
    // round the slider position to the nearest index of the numbers array
    indx = (NSUInteger)(slider.value + 0.5);
    [slider setValue:indx animated:NO];
    number = numbers[indx]; // <-- This numeric value you want
    NSLog(@"%d",(int)indx);

    
    [smiling removeFromSuperlayer];
    smilingPath = [UIBezierPath bezierPath];
    [smilingPath moveToPoint:CGPointMake(0, 0)];
    if(indx == 6){
    [smilingPath addCurveToPoint:CGPointMake(0.32 * width, 0) controlPoint1:CGPointMake(0.16 * width, 0.02 * height) controlPoint2:CGPointMake(0.32 * width, 0)];
    }else if(indx == 7){
    [smilingPath addCurveToPoint:CGPointMake(0.32 * width, 0) controlPoint1:CGPointMake(0.16 * width, 0.05 * height) controlPoint2:CGPointMake(0.32 * width, 0)];
    }else if(indx==8){
    [smilingPath addCurveToPoint:CGPointMake(0.32 * width, 0) controlPoint1:CGPointMake(0.16 * width, 0.07 * height) controlPoint2:CGPointMake(0.32 * width, 0)];
    }else if(indx==9){
        [smilingPath addCurveToPoint:CGPointMake(0.32 * width, 0) controlPoint1:CGPointMake(0.16 * width, 0.1 * height) controlPoint2:CGPointMake(0.32 * width, 0)];
    }else if(indx==10){
        [smilingPath addCurveToPoint:CGPointMake(0.32 * width, 0) controlPoint1:CGPointMake(0.16 * width, 0.12 * height) controlPoint2:CGPointMake(0.32 * width, 0)];
    }else if(indx==5){
        [smilingPath addCurveToPoint:CGPointMake(0.32 * width, 0) controlPoint1:CGPointMake(0.16 * width, 0) controlPoint2:CGPointMake(0.32 * width, 0)];
    }else if(indx==4){
        [smilingPath addCurveToPoint:CGPointMake(0.32 * width, 0) controlPoint1:CGPointMake(0.16 * width, -0.02 * height) controlPoint2:CGPointMake(0.32 * width, 0)];
    }else if(indx==3){
        [smilingPath addCurveToPoint:CGPointMake(0.32 * width, 0) controlPoint1:CGPointMake(0.16 * width, -0.05 * height) controlPoint2:CGPointMake(0.32 * width, 0)];
    }else if(indx==2){
        [smilingPath addCurveToPoint:CGPointMake(0.32 * width, 0) controlPoint1:CGPointMake(0.16 * width, -0.07 * height) controlPoint2:CGPointMake(0.32 * width, 0)];
    }else if(indx==1){
        [smilingPath addCurveToPoint:CGPointMake(0.32 * width, 0) controlPoint1:CGPointMake(0.16 * width, -0.1 * height) controlPoint2:CGPointMake(0.32 * width, 0)];
    }else if(indx==0){
        [smilingPath addCurveToPoint:CGPointMake(0.32 * width, 0) controlPoint1:CGPointMake(0.16 * width, -0.13 * height) controlPoint2:CGPointMake(0.32 * width, 0)];
    }
    
    smiling = [CAShapeLayer layer];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        smiling.frame = CGRectMake(0.34 * width, 0.58 * height, 0.08 * width, 0);
    }else{
    smiling.frame = CGRectMake(0.34 * width, 0.52 * height, 0.08 * width, 0);
    }
    smiling.path = smilingPath.CGPath;
    smiling.fillColor=[UIColor clearColor].CGColor;
    smiling.lineWidth = 0.056 * smiling.frame.size.width;
    smiling.strokeColor=[UIColor colorWithRed:.96 green:.77 blue:.27 alpha:1].CGColor;
    [self.view.layer addSublayer:smiling];
    [self.view bringSubviewToFront:self.spinner];
    
    
    NSMutableArray *humanexarray=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"humanexarray"]]mutableCopy];
    NSString *str=[prefs objectForKey:@"humanbuildingid"];
    int lid=[str intValue];
    NSMutableArray *a=[[NSMutableArray alloc] init];
    [a addObject:str];
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    [arr addObject:[NSString stringWithFormat:@"%d",(int)indx]];
    [arr addObject:experiencearr];
    NSLog(@"%@",experiencearr);
    [prefs setObject:arr forKey:@"experiencearr"];
    [a addObject:arr];
    int notexists=0;
        for (int i=0; i<humanexarray.count; i++) {
            NSMutableArray *aa=[[[NSMutableArray alloc] initWithArray:[humanexarray objectAtIndex:i]] mutableCopy];
            if(aa.count==2){
                int templid=[[aa objectAtIndex:0] intValue];
                if(lid==templid){
                    [humanexarray replaceObjectAtIndex:i withObject:a];
                    [prefs setObject:humanexarray forKey:@"humanexarray"];
                    notexists=1;
                    break;
                }
            }
        }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)willMoveToParentViewController:(UIViewController *)parent{
    UIViewController *v = parent.navigationController.viewControllers.lastObject;
    NSLog(@"%@",v.restorationIdentifier);
    if([v.restorationIdentifier isEqualToString:@"more"]){
        NSMutableArray *humanexarray=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"humanexarray"]]mutableCopy];
        NSString *str=[prefs objectForKey:@"humanbuildingid"];
        int lid=[str intValue];
        NSMutableArray *a=[[NSMutableArray alloc] init];
        [a addObject:str];
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        [arr addObject:[NSString stringWithFormat:@"%d",(int)indx]];
        [arr addObject:experiencearr];
        [prefs setObject:arr forKey:@"experiencearr"];
        [a addObject:arr];
        int notexists=0;
        if ((int)[prefs integerForKey:@"url"]!=1) {
            for (int i=0; i<humanexarray.count; i++) {
                NSMutableArray *aa=[[[NSMutableArray alloc] initWithArray:[humanexarray objectAtIndex:i]] mutableCopy];
                if(aa.count==2){
                    int templid=[[aa objectAtIndex:0] intValue];
                    if(lid==templid){
                        [humanexarray replaceObjectAtIndex:i withObject:a];
                        [prefs setObject:humanexarray forKey:@"humanexarray"];
                        notexists=1;
                        break;
                    }
                }
            }
            
            
            if((humanexarray.count==0)||(notexists!=1)){
                [humanexarray addObject:a];
                [prefs setObject:humanexarray forKey:@"humanexarray"];
            }
            
        }else{
            
        }
        
        
    }
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([viewController.restorationIdentifier isEqualToString:@"more"]){
        NSMutableArray *humanexarray=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"humanexarray"]]mutableCopy];
        NSString *str=[prefs objectForKey:@"humanbuildingid"];
        int lid=[str intValue];
        NSMutableArray *a=[[NSMutableArray alloc] init];
        [a addObject:str];
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        [arr addObject:[NSString stringWithFormat:@"%d",(int)indx]];
        [arr addObject:experiencearr];
        [prefs setObject:arr forKey:@"experiencearr"];
        [a addObject:arr];
        int notexists=0;
        if ((int)[prefs integerForKey:@"url"]!=1) {
            for (int i=0; i<humanexarray.count; i++) {
                NSMutableArray *aa=[[[NSMutableArray alloc] initWithArray:[humanexarray objectAtIndex:i]] mutableCopy];
                if(aa.count==2){
                    int templid=[[aa objectAtIndex:0] intValue];
                    if(lid==templid){
                        [humanexarray replaceObjectAtIndex:i withObject:a];
                        [prefs setObject:humanexarray forKey:@"humanexarray"];
                        notexists=1;
                        break;
                    }
                }
            }
            
            
            if((humanexarray.count==0)||(notexists!=1)){
                [humanexarray addObject:a];
                [prefs setObject:humanexarray forKey:@"humanexarray"];
            }
            
        }else{
            
        }

        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  /*  NSMutableArray *arr=[[NSMutableArray alloc] init];
    [arr addObject:[NSString stringWithFormat:@"%d",position]];
    [arr addObject:experiencearr];
    [prefs setObject:arr forKey:@"experiencearr"];
    
    int row=(int)[prefs integerForKey:@"currentrow"];
    NSMutableArray *humanexarray=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"humanexarray"]] mutableCopy];

    
    [humanexarray removeObjectAtIndex:row];
    [humanexarray insertObject:arr atIndex:row];
    NSLog(@"After change %@",humanexarray);
    */


    
       NSMutableArray *humanexarray=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"humanexarray"]]mutableCopy];
    NSString *str=[prefs objectForKey:@"humanbuildingid"];
    int lid=[str intValue];
    NSMutableArray *a=[[NSMutableArray alloc] init];
    [a addObject:str];
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    [arr addObject:[NSString stringWithFormat:@"%d",(int)indx]];
    [arr addObject:experiencearr];
    [prefs setObject:arr forKey:@"experiencearr"];
    [a addObject:arr];
    int notexists=0;
    if ((int)[prefs integerForKey:@"url"]!=1) {
    for (int i=0; i<humanexarray.count; i++) {
        NSMutableArray *aa=[[[NSMutableArray alloc] initWithArray:[humanexarray objectAtIndex:i]] mutableCopy];
        if(aa.count==2){
        int templid=[[aa objectAtIndex:0] intValue];
        if(lid==templid){
            [humanexarray replaceObjectAtIndex:i withObject:a];
            [prefs setObject:humanexarray forKey:@"humanexarray"];
            notexists=1;
            break;
        }
    }
    }
        
        
    if((humanexarray.count==0)||(notexists!=1)){
        [humanexarray addObject:a];
        [prefs setObject:humanexarray forKey:@"humanexarray"];
    }
    
    }else{
        
    }
    NSLog(@"Humanex is %@",humanexarray);
    
}
- (IBAction)backbtn:(id)sender {
    [self goback:nil];
}


- (IBAction)done:(id)sender {
   position =(int)indx;
    
    if(position<=5){
        [self performSegueWithIdentifier:@"gotohuman" sender:nil];
    }
    else{
        UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"Survey submission" message:@"Please enter your details" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* modify = [UIAlertAction actionWithTitle:@"Modify" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
        UIAlertAction* submit = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            opened=NO;
                [self.spinner setHidden:NO];
                NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
                NSMutableString *randomString = [NSMutableString stringWithCapacity: 16];
                for (int i=0; i<16; i++) {
                    [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
                }
                NSString *name=alrt.textFields[0].text;
                NSString *location=@"";
                //NSString *urlString=[NSString stringWithFormat:@"http://sbx2.leedon.io/buildings/LEED:%@/survey/environment/?key=%@&recompute_score=1",[prefs objectForKey:@"leed_id"],[prefs objectForKey:@"key"]];
                //assets/LEED:1000126479/survey/environment/?subscription-key=8e0baacec376430ba0f81a5d960ccbb0&key=slaJjULbXHk7CJUEggoNJ7jy&recompute_score=1
                NSString *urlString=[NSString stringWithFormat:@"%@assets/LEED:%@/survey/environment/?subscription-key=%@&key=%@&recompute_score=1",domain_url,[prefs objectForKey:@"leed_id"],subscription_key,[prefs objectForKey:@"key"]];
                //NSString *urlString = @"https://api.usgbc.org/stg/leed/assets/LEED:1000126479/survey/environment/?subscription-key=8e0baacec376430ba0f81a5d960ccbb0&key=slaJjULbXHk7CJUEggoNJ7jy&recompute_score=1";
                NSLog(@"URL asdas d%@",urlString);
                NSMutableArray *ar=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"listofrowsforhuman"]]mutableCopy];
                int exist=0;
                int current=(int)[prefs integerForKey:@"humanbuildingid"];
                NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                [dateformate setDateFormat:@"dd/MM/YYYY"];
                NSString *date_String=[dateformate stringFromDate:[NSDate date]];
                
                NSLog(@"%@",ar);
                if((int)[prefs integerForKey:@"url"]!=1){
                    nope=1;
                    for (int m=0; m<ar.count; m++) {
                        NSMutableArray *a=[[ar objectAtIndex:m] mutableCopy];
                        NSLog(@"%@",a);
                        int x=[[a objectAtIndex:0]intValue];
                        NSString *date=[a objectAtIndex:1];
                        //            int star=[[a objectAtIndex:1]intValue];
                        if(x==current){
                            if([date_String isEqualToString:date]){
                                exist=1;
                                nope=0;
                                [prefs setObject:ar forKey:@"listofrowsforhuman"];
                                break;
                            }
                            else{
                                [a replaceObjectAtIndex:1 withObject:date_String];
                                [ar replaceObjectAtIndex:m withObject:a];
                                [prefs setObject:ar forKey:@"listofrowsforhuman"];
                            }
                        }
                        else{
                            nope=1;
                        }
                    }
                }
            
            
            if(exist == 1){
                NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"building_details"]];
                if(dict[@"lobby_survey_status"] == false || dict[@"lobby_survey_status"] == [NSNull null]){
                    exist = 1;
                }else{
                    exist = 0;
                }
            }
                
                if(exist==0){
                    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                    NSArray *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:urlString]];
                    for (NSHTTPCookie *cookie in cookies) {
                        [cookieStorage deleteCookie:cookie];
                    }
                    
                }
                
                if(exist==0){
 
                    NSString *urlString=[NSString stringWithFormat:@"%@assets/LEED:%@/survey/environment/?subscription-key=%@&key=%@&recompute_score=1",domain_url,[prefs objectForKey:@"leed_id"],subscription_key,[prefs objectForKey:@"key"]];
                    
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                       timeoutInterval:60.0];
                                        
                    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                    [request addValue:subscription_key forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
                    
                    [request setHTTPMethod:@"POST"];
                    NSMutableDictionary *mapData = [[NSMutableDictionary alloc] init];
                    
                    mapData[@"tenant_name"] = name;
                    mapData[@"response_method"] = @"web";
                    mapData[@"location"] = location;
                    mapData[@"satisfaction"] = [NSNumber numberWithInteger:position];
                    mapData[@"complaints"] = @"[]";
                    mapData[@"other_complaint"] = @"";
                    mapData[@"language"] = @"English";
                    NSLog(@"%@ %@",mapData,[prefs objectForKey:@"key"]);
                    NSError *error;
                    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
                    [request setHTTPBody:postData];
                    
                    
                    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                    [configuration setHTTPAdditionalHeaders:@{@"Accept" : @"application/json", @"Content-Type" : @"application/x-www-form-urlencoded"}];
                    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
                    
                    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        int code = (int)[(NSHTTPURLResponse *)response statusCode];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.spinner setHidden:YES];
                            if (code == 401) {           // check for http errors
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.spinner.hidden = YES;
                                    self.view.userInteractionEnabled = YES;
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"renewtoken" object:nil userInfo:nil];
                                });
                            }
                            else if(code==200 || code == 201){
                                [prefs setInteger:0 forKey:@"humanhide"];
                                UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"" message:@"Human Survey submitted" preferredStyle:UIAlertControllerStyleAlert];
                                //[self presentViewController:alrt animated:YES completion:nil];
                                //[self performSelector:@selector(dismissAlert:) withObject:alrt afterDelay:1.0f];
                                //[self maketoast:@"Human survey submitted" withbackground:[UIColor blueColor] withdelay:4.5];
                                NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                                d[@"message"] = @"Human survey submitted";
                                d[@"type"] = @"message";
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
                                
                                submitteddonthide=(int)[prefs integerForKey:@"humandone"];
                                opened=YES;
                                submitteddonthide=0;
                                if(nope==1){
                                    if((int)[prefs integerForKey:@"url"]!=1){
                                        NSMutableArray *ab=[[NSMutableArray alloc] init];
                                        int current=(int)[prefs integerForKey:@"leed_id"];
                                        [ab addObject:[NSString stringWithFormat:@"%d",current]];
                                        [ab addObject:date_String];
                                        [ar addObject:ab];
                                        [prefs setObject:ar forKey:@"listofrowsforhuman"];
                                    }
                                }
                                
                                if([prefs  integerForKey:@"transithide"]==0){
                                    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                                    d[@"message"] = @"Thank you for taking the time";
                                    d[@"type"] = @"message";
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                else{
                                    //[self performSegueWithIdentifier:@"humantotransit" sender:nil];
                                    [self humantotransit];
                                }
                                return;
                                
                            }
                            else if(code==0){
                                submitteddonthide=(int)[prefs integerForKey:@"humandone"];
                                UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"" message:@"Please check your internet connection" preferredStyle:UIAlertControllerStyleAlert];
                                //[self presentViewController:alrt animated:YES completion:nil];
                                //[self performSelector:@selector(dismissAlert:) withObject:alrt afterDelay:1.0f];
                                //[self maketoast:@"Please check your internet connection" withbackground:[UIColor blackColor] withdelay:4.5];
                                NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                                d[@"message"] = @"Please check your internet connection";
                                d[@"type"] = @"error";
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
                                
                            }
                            else{
                                NSLog(@"%d",code);
                              /*  UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"" message:@"Human Survey submission Failed" preferredStyle:UIAlertControllerStyleAlert];
                                [self presentViewController:alrt animated:YES completion:nil];
                                [self performSelector:@selector(dismissAlert:) withObject:alrt afterDelay:1.0f];
                                */
                                NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                                d[@"message"] = @"Human Survey submission Failed";
                                d[@"type"] = @"error";
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
                                
                                //[self maketoast:@"Human Survey submission Failed" withbackground:[UIColor blackColor] withdelay:4.5];
                            }
                        });
                        
                    }];
                    
                    [postDataTask resume];
                }
                else{
                    UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"" message:@"You've already taken survey" preferredStyle:UIAlertControllerStyleAlert];
                    //[self presentViewController:alrt animated:YES completion:nil];
                    [prefs setInteger:0 forKey:@"humanhide"];
                    //[self performSelector:@selector(dismissAlert:) withObject:alrt afterDelay:1.0f];
//                    [self maketoast:@"You've already taken survey" withbackground:[UIColor blackColor] withdelay:4.5];
                    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                    d[@"message"] = @"You've already taken survey";
                    d[@"type"] = @"message";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
                    
                    if([[prefs objectForKey:@"mainarray"] count]>0){
                        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        UIViewController *more = [mainstoryboard instantiateViewControllerWithIdentifier:@"more"];
                        UIViewController *listroutes = [mainstoryboard instantiateViewControllerWithIdentifier:@"listroutes"];
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
                        [controllers addObject:listroutes];
                        [self.navigationController setViewControllers:controllers animated:YES];
                        
                    }
                    else{
                        //[self performSegueWithIdentifier:@"humantotransit" sender:nil];
                        [self humantotransit];
                    }
                }

            }];
        
        [alrt addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Enter your name(optional)";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
        }];
        [alrt addAction:modify];
        [alrt addAction:submit];
        [[[[alrt view]subviews] objectAtIndex:0] setBackgroundColor:[UIColor whiteColor]];
        [[[alrt view] layer] setCornerRadius:10];
        [[[alrt view] layer] setMasksToBounds:YES];
        [self presentViewController:alrt animated:YES completion:nil];
            opened=YES;
        //[alert show];
    }
}
-(void)maketoast:(NSString *)message withbackground:(UIColor *)color withdelay:(double)delay{
    if([notificationView isDescendantOfView:self.view]){
        [notificationView removeFromSuperview];
    }
    notificationLabel = [[UILabel alloc] init];
    notificationView = [[UIView alloc] init];
    if(self.navigationController != nil){
    notificationView.frame = CGRectMake(0.0, 0.0 , self.view.frame.size.width, 0.058 * [UIScreen mainScreen].bounds.size.height);
    }else{
        
    }
    notificationLabel.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, notificationView.frame.size.height);
    notificationLabel.text      = message;
    [notificationView setBackgroundColor:color];
    [notificationLabel setFont:[UIFont fontWithName:@"OpenSans" size:15]];
    [notificationLabel setNumberOfLines:3];
    [notificationLabel setTextColor:[UIColor whiteColor]];
    [notificationLabel setTextAlignment:NSTextAlignmentCenter];
    [notificationView addSubview:notificationLabel];
    [self.view addSubview:notificationView];
    [self.view bringSubviewToFront:notificationView];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            notificationView.frame = CGRectMake(0.0, self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y, self.view.frame.size.width, 0.058 * [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self hide];
        });
    }];
    
    
    
}

-(void)hide{
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
    } completion:^(BOOL finished){
        [self.spinner setHidden:YES];
        [notificationView removeFromSuperview];
    }];
    
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)viewDidAppear:(BOOL)animated{
    // 2. Force the device in landscape mode when the view controller gets loaded
    if([[NSMutableArray arrayWithArray:[prefs objectForKey:@"experiencearr"]] count] > 0){
        experiencearr=[[[NSMutableArray arrayWithArray:[prefs objectForKey:@"experiencearr"]] objectAtIndex:1]mutableCopy];
    }
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"building_details"]];
    self.navigationController.navigationBar.backItem.title = dict[@"name"];
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"closeboth"] == 1){
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"closeboth"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)humantotransit{
    
    NSMutableArray *mut = [[NSMutableArray alloc] initWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:@"mainarray"] mutableCopy]];
            [self savedata];
    if(mut.count == 0){

        [[NSNotificationCenter defaultCenter] postNotificationName:@"performsegue" object:nil userInfo:@{@"seguename":@"gototransit"}];
        
    }else{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"performsegue" object:nil userInfo:@{@"seguename":@""}];
    }
    
}


-(void)savedata{
    NSMutableArray *humanexarray=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"humanexarray"]]mutableCopy];
    NSString *str=[prefs objectForKey:@"humanbuildingid"];
    int lid=[str intValue];
    NSMutableArray *a=[[NSMutableArray alloc] init];
    [a addObject:str];
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    [arr addObject:[NSString stringWithFormat:@"%d",(int)indx]];
    [arr addObject:experiencearr];
    [prefs setObject:arr forKey:@"experiencearr"];
    [a addObject:arr];
    int notexists=0;
    if ((int)[prefs integerForKey:@"url"]!=1) {
        for (int i=0; i<humanexarray.count; i++) {
            NSMutableArray *aa=[[[NSMutableArray alloc] initWithArray:[humanexarray objectAtIndex:i]] mutableCopy];
            if(aa.count==2){
                int templid=[[aa objectAtIndex:0] intValue];
                if(lid==templid){
                    [humanexarray replaceObjectAtIndex:i withObject:a];
                    [prefs setObject:humanexarray forKey:@"humanexarray"];
                    notexists=1;
                    break;
                }
            }
        }
        
        
        if((humanexarray.count==0)||(notexists!=1)){
            [humanexarray addObject:a];
            [prefs setObject:humanexarray forKey:@"humanexarray"];
        }
        
    }else{
        
    }
}


-(void)dismissAlert:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
    //[alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)goback:(id)sender {
    position=(int)indx;
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
