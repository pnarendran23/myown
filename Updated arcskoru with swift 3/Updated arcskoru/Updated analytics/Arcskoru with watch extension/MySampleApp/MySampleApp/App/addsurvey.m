//
//  ViewController.m
//  multiple
//
//  Created by Group10 on 05/05/15.
//  Copyright (c) 2015 Group10. All rights reserved.
//

#import "addsurvey.h"
#import "listofroutes.h"
#import "buttonarray.h"
#import "CustomCollectionViews.h"

@interface addsurvey ()

@end

@implementation addsurvey


-(void)viewWillAppear:(BOOL)animated{    

}


-(void)viewDidAppear:(BOOL)animated{
    [self.spinner.layer setCornerRadius:10];
    [self.spinner.layer setMasksToBounds:YES];
    [self.spinner setHidden:YES];
    mainarr = [[NSMutableArray alloc] init];
    jsonarray = [[NSMutableArray alloc] init];
    milesarray = [[NSMutableArray alloc] init];
    cararray = [[NSArray alloc] init];
    car23array = [[NSArray alloc] init];
    walkarray = [[NSArray alloc] init];
    altarray = [[NSArray alloc] init];
    tramarray = [[NSArray alloc] init];
    motorarray = [[NSArray alloc] init];
    busarray = [[NSArray alloc] init];
    railarray = [[NSArray alloc] init];
    
    edit = 0;
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"building_details"]];
    self.navigationController.navigationBar.backItem.title = dict[@"name"];
    [self viewDidLoad];
    opened=NO;
    width=[UIScreen mainScreen].bounds.size.width;
    height=[UIScreen mainScreen].bounds.size.height;
    [self.tableview setSeparatorColor:[UIColor lightGrayColor]];
    self.tableview.layoutMargins = UIEdgeInsetsZero;
    NSString *s;
    [self.submitbtn setHidden:YES];
    mainarr=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"mainarray"]]mutableCopy];
    NSLog(@"main arr count %lu",(unsigned long)mainarr.count);
    for (NSArray *a in mainarr) {
        if([[a objectAtIndex:4] isEqualToString:@"0"]){
            s=[a objectAtIndex:4];
        }
    }
    if([s isEqualToString:@"0"]){
        [self.submitbtn setHidden:NO];
    }
        
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans" size:17], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",dict[@"name"]]];
    edit = 0;
    NSLog(@"add survey Nib name %@",[[self.navigationController.viewControllers lastObject]restorationIdentifier]);
    subscription_key = @"e6aecd40e07c40718a0b3ed9a0cc609d";//"f94b34f0576f4a85b3c0c22eefb625b3";
    domain_url = @"https://api.usgbc.org/stg/leed/";
    survey_url = @"https://stg.app.arconline.io/app/project/";
    self.navigationController.delegate = self;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(Add)];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
    prefs=[NSUserDefaults standardUserDefaults];
    [prefs synchronize];
    [self.tableview setSeparatorColor:[UIColor lightGrayColor]];
    CAShapeLayer *topline = [CAShapeLayer layer];
    topline.fillColor         = nil;
    topline.strokeColor       = [UIColor lightGrayColor].CGColor;
    UIBezierPath *baselinePath = [UIBezierPath bezierPath];
    [baselinePath moveToPoint:CGPointMake(self.tableview.bounds.size.width, 0)];
    [baselinePath addCurveToPoint:CGPointMake(0, 0) controlPoint1:CGPointMake(0, 0) controlPoint2:CGPointMake(self.tableview.bounds.size.width, 0)];
    ;
    topline.frame = CGRectMake(0, self.tableview.frame.origin.y, 0, 0);
    topline.path = baselinePath.CGPath;
    CAShapeLayer *bottomline = [CAShapeLayer layer];
    bottomline.fillColor         = nil;
    bottomline.strokeColor       = [UIColor lightGrayColor].CGColor;
    bottomline.frame = CGRectMake(0, self.tableview.frame.origin.y+self.tableview.frame.size.height+1, 0, 0);
    bottomline.path = baselinePath.CGPath;
    [self.view.layer addSublayer:topline];
    [self.view.layer addSublayer:bottomline];
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    cararray=[[prefs objectForKey:@"cararray"] mutableCopy];
    car23array=[[prefs objectForKey:@"car23array"] mutableCopy];
    walkarray =[[prefs objectForKey:@"walkarray"] mutableCopy];
    railarray =[[prefs objectForKey:@"railarray"] mutableCopy];
    altarray =[[prefs objectForKey:@"altarray"] mutableCopy];
    tramarray =[[prefs objectForKey:@"tramarray"] mutableCopy];
    motorarray =[[prefs objectForKey:@"motorarray"] mutableCopy];
    busarray =[[prefs objectForKey:@"busarray"] mutableCopy];
    btn=[[UIButton alloc] init];
    [self.tableview setSeparatorInset:UIEdgeInsetsZero];
    mainarr=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"mainarray"]]mutableCopy];
    NSString *querystring =[prefs objectForKey:@"jsonquery"];
    NSMutableArray *a;
    int i=(int)[prefs integerForKey:@"added"];
    int num=(int)[prefs integerForKey:@"selected"];
    int miles=(int)[prefs integerForKey:@"miles"];
    num=!num;
    if(i==1){
        i=(int)[prefs integerForKey:@"editindex"];
        int edite=(int)[prefs integerForKey:@"edit"];
        int changess=(int)[prefs integerForKey:@"changes"];
        if(edite==1){
            if(changess==1){
                NSString *str=[[NSString alloc] init];
                str=[prefs objectForKey:@"routelabel"];
                NSMutableDictionary *routes=[[NSMutableDictionary alloc] init];
                NSMutableArray *routear=[[NSMutableArray alloc] init];
                NSMutableDictionary *images=[[NSMutableDictionary alloc] init];
                NSMutableArray *imgarray=[[NSMutableArray alloc] init];
                NSMutableArray *captionarray=[[NSMutableArray alloc] init];
                NSMutableDictionary *captions=[[NSMutableDictionary alloc] init];
                routear=[[prefs objectForKey:@"temp"]mutableCopy];
                routes=[NSMutableDictionary dictionaryWithObjectsAndKeys:routear,@"routes", nil];
                imgarray =[[prefs objectForKey:@"image"]mutableCopy];
                images =[NSMutableDictionary dictionaryWithObjectsAndKeys: imgarray,@"images", nil];
                captionarray =[[prefs objectForKey:@"caption"]mutableCopy];
                captions =[NSMutableDictionary dictionaryWithObjectsAndKeys:captionarray ,@"captions", nil];
                a=[[NSMutableArray alloc] init];
                [a addObject:str];
                [a addObject:routes];
                [a addObject:images];
                [a addObject:captions];
                [a addObject:[NSString stringWithFormat:@"%d",num]];
                [a addObject:querystring];
                [a addObject:[NSString stringWithFormat:@"%d",miles]];
                if(mainarr.count>0){
                    [mainarr removeObjectAtIndex:i];
                    [mainarr insertObject:a atIndex:i];
                }
                else{
                    [mainarr addObject:a];
                }
                [prefs setInteger:0 forKey:@"changes"];
                [prefs setInteger:0 forKey:@"edit"];
                NSLog(@"Before backto %@", mainarr);
                [prefs setObject:mainarr forKey:@"mainarray"];
                [self backtocategories:nil];
            }
            else{
                NSString *str=[[NSString alloc] init];
                str=[prefs objectForKey:@"routelabel"];
                NSMutableDictionary *routes=[[NSMutableDictionary alloc] init];
                NSMutableArray *routear=[[NSMutableArray alloc] init];
                NSMutableDictionary *images=[[NSMutableDictionary alloc] init];
                NSMutableArray *imgarray=[[NSMutableArray alloc] init];
                NSMutableArray *captionarray=[[NSMutableArray alloc] init];
                NSMutableDictionary *captions=[[NSMutableDictionary alloc] init];
                routear=[[prefs objectForKey:@"temp"]mutableCopy];
                routes=[NSMutableDictionary dictionaryWithObjectsAndKeys:routear,@"routes", nil];
                imgarray =[[prefs objectForKey:@"image"]mutableCopy];
                images =[NSMutableDictionary dictionaryWithObjectsAndKeys: imgarray,@"images", nil];
                captionarray =[[prefs objectForKey:@"caption"]mutableCopy];
                captions =[NSMutableDictionary dictionaryWithObjectsAndKeys:captionarray ,@"captions", nil];
                a=[[NSMutableArray alloc] init];
                [a addObject:str];
                [a addObject:routes];
                [a addObject:images];
                [a addObject:captions];
                [a addObject:[NSString stringWithFormat:@"%d",num]];
                [a addObject:querystring];
                [a addObject:[NSString stringWithFormat:@"%d",miles]];
                [mainarr removeObjectAtIndex:i];
                [mainarr insertObject:a atIndex:i];
                [prefs setInteger:0 forKey:@"edit"];
            }
        }
        else{
            NSString *str=[[NSString alloc] init];
            str=[prefs objectForKey:@"routelabel"];
            NSMutableDictionary *routes=[[NSMutableDictionary alloc] init];
            NSMutableArray *routear=[[NSMutableArray alloc] init];
            NSMutableDictionary *images=[[NSMutableDictionary alloc] init];
            NSMutableArray *imgarray=[[NSMutableArray alloc] init];
            NSMutableArray *captionarray=[[NSMutableArray alloc] init];
            NSMutableDictionary *captions=[[NSMutableDictionary alloc] init];
            routear=[[prefs objectForKey:@"temp"]mutableCopy];
            routes=[NSMutableDictionary dictionaryWithObjectsAndKeys:routear,@"routes", nil];
            imgarray =[[prefs objectForKey:@"image"]mutableCopy];
            images =[NSMutableDictionary dictionaryWithObjectsAndKeys: imgarray,@"images", nil];
            captionarray =[[prefs objectForKey:@"caption"]mutableCopy];
            captions =[NSMutableDictionary dictionaryWithObjectsAndKeys:captionarray ,@"captions", nil];
            a=[[NSMutableArray alloc] init];
            [a addObject:str];
            [a addObject:routes];
            [a addObject:images];
            [a addObject:captions];
            [a addObject:[NSString stringWithFormat:@"%d",num]];
            [a addObject:querystring];
            [a addObject:[NSString stringWithFormat:@"%d",miles]];
            [mainarr addObject:a];
            
        }
    }
    milesarray=[[NSMutableArray alloc]init];
    for (int c=0; c<mainarr.count; c++) {
        NSMutableArray *temp=[[NSMutableArray arrayWithArray:[mainarr objectAtIndex:c]] mutableCopy];
        NSMutableArray  *temp1=[[NSMutableArray arrayWithArray:[[temp objectAtIndex:1] valueForKey:@"routes"]] mutableCopy];
        [milesarray addObject:temp1];
    }
    for (int c=0; c<milesarray.count; c++) {
        NSMutableArray *temp=[[NSMutableArray alloc] init];
        temp=[[NSMutableArray arrayWithArray:[milesarray objectAtIndex:c]] mutableCopy];
        for (int i=0; i<temp.count; i++) {
            double n=[[temp objectAtIndex:i]intValue];
            n=n*1.6;
            [temp removeObjectAtIndex:i];
            [temp insertObject:[NSString stringWithFormat:@"%.1f",n] atIndex:i];
        }
        [milesarray removeObjectAtIndex:c];
        [milesarray insertObject:temp atIndex:c];
    }
    [prefs setObject:milesarray forKey:@"milesarray"];
    [prefs setObject:mainarr forKey:@"mainarray"];
    jsonarray=[[NSMutableArray alloc] init];
    for (int i=0; i<mainarr.count; i++) {
        [jsonarray addObject:@""];
    }
    for (int i=0; i<mainarr.count; i++) {
        NSMutableArray *innerarray=[mainarr objectAtIndex:i];
        if([[innerarray objectAtIndex:4] isEqualToString:@"0"]){
            [jsonarray replaceObjectAtIndex:i withObject:[innerarray objectAtIndex:5]];
        }
        else{
            [jsonarray replaceObjectAtIndex:i withObject:@""];
        }
    }
    [self.tableview reloadData];
    NSLog(@"main array is %@",mainarr);
    
}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.delegate = nil;
}



-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if([viewController isKindOfClass:[buttonarray class]]){
    if(edit == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
    }else{
        NSMutableArray *transportationarray=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"transportationarray"]]mutableCopy];
        NSMutableArray *a=[[NSMutableArray alloc] init];
        NSString *str=[prefs objectForKey:@"transportbuildingid"];
        
        [a addObject:str];
        [a addObject:mainarr];
        [prefs setObject:mainarr forKey:@"mainarray"];
        if((int)[prefs integerForKey:@"url"]!=1){
            int lid=[str intValue];
            int exists=0;
            for (int i=0; i<transportationarray.count; i++) {
                NSMutableArray *aa=[[[NSMutableArray alloc] initWithArray:[transportationarray objectAtIndex:i]] mutableCopy];
                if(aa.count!=0){
                    int templid=[[aa objectAtIndex:0] intValue];
                    if(lid==templid){
                        [transportationarray replaceObjectAtIndex:i withObject:a];
                        [prefs setObject:transportationarray forKey:@"transportationarray"];
                        exists=1;
                        break;
                    }
                }
            }
            
            
            if((transportationarray.count==0)||(exists!=1)){
                [transportationarray addObject:a];
                [prefs setObject:transportationarray forKey:@"transportationarray"];
            }
            
        }

    }
}

-(void)Add{
    edit = 1;
    [prefs setInteger:0 forKey:@"edit"];
    [prefs setObject:jsonarray forKey:@"json"];
    //[self performSegueWithIdentifier:@"addmoreroutes" sender:self];
    NSString *restorationID = [[self.navigationController.viewControllers lastObject]restorationIdentifier];
    NSString *previousrestorationID = [[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2]restorationIdentifier];
    if([restorationID isEqualToString:@"listroutes"] && ![previousrestorationID isEqualToString:@"addnewroute"]){
        [self performSegueWithIdentifier:@"addmoreroutes" sender:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Please select the below routes  ";
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        [tableViewHeaderFooterView.textLabel setTextAlignment:NSTextAlignmentCenter];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.spinner.layer setCornerRadius:10];    
    [self.tableview registerClass:[listofroutes class] forCellReuseIdentifier:@"listofroutes"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(mainarr.count==1){
        [self.tableview setScrollEnabled:NO];
    }
    else{
        [self.tableview setScrollEnabled:YES];
    }
    
    return mainarr.count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        NSMutableArray *transportationarray=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"transportationarray"]]mutableCopy];
    NSMutableArray *a=[[NSMutableArray alloc] init];
    NSString *str=[prefs objectForKey:@"transportbuildingid"];

    [a addObject:str];
    [a addObject:mainarr];
    [prefs setObject:mainarr forKey:@"mainarray"];
    if((int)[prefs integerForKey:@"url"]!=1){
        int lid=[str intValue];
        int exists=0;
        for (int i=0; i<transportationarray.count; i++) {
            NSMutableArray *aa=[[[NSMutableArray alloc] initWithArray:[transportationarray objectAtIndex:i]] mutableCopy];
            if(aa.count!=0){
            int templid=[[aa objectAtIndex:0] intValue];
            if(lid==templid){
                [transportationarray replaceObjectAtIndex:i withObject:a];
                [prefs setObject:transportationarray forKey:@"transportationarray"];
                exists=1;
                break;
            }
            }
        }
        
        
        if((transportationarray.count==0)||(exists!=1)){
            [transportationarray addObject:a];
            [prefs setObject:transportationarray forKey:@"transportationarray"];
        }
    }
}

- (void)myTapMethod
{
    NSLog(@"TAP");
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    listofroutes *cell = [tableView dequeueReusableCellWithIdentifier:@"cvcell"];
    
     // listofroutes  *cell = [[listofroutes alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cvcell"];
    
    listofroutes *cell = (listofroutes *)[tableView dequeueReusableCellWithIdentifier:@"listofroutes"];
    if (cell != nil) {

        cell = [[listofroutes alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"listofroutes"];
    }
    UITapGestureRecognizer *singleFingerTap;
    cell.layoutMargins = UIEdgeInsetsZero;
    singleFingerTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched:)];
    cell.contentView.tag=(int)indexPath.row;
    [cell.contentView addGestureRecognizer:singleFingerTap];
   
    [cell.mibutton addTarget:self action:@selector(milechange:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.mibutton setTag:indexPath.row];
    NSArray *cellData = [mainarr objectAtIndex:[indexPath row]];
    NSArray *routevalues=[cellData objectAtIndex:1];
    NSArray *imagevalues=[cellData objectAtIndex:2];
    [cell accessory:[cellData objectAtIndex:4]];
    int mile=[[cellData objectAtIndex:6] intValue];
    if(mile==0){
        [cell.mibutton setTitle:@"Km" forState:UIControlStateNormal];
        [cell setCollectionData:[routevalues valueForKey:@"routes"]];
    }
    else{
        [cell.mibutton setTitle:@"Mi" forState:UIControlStateNormal];
        [cell setCollectionData:[milesarray objectAtIndex:indexPath.row]];
    }
    [cell setimageData:[imagevalues valueForKey:@"images"]];
    [cell setlabelData:[cellData objectAtIndex:0]];
    [cell dashlineadjust];
    return cell;
    
}

-(IBAction)milechange:(id)sender event:(id)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPos = [touch locationInView:self.tableview];
    NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:touchPos];
    if(indexPath != nil){
        //do operation with indexPath
    }
    NSLog(@"%ld",(long)indexPath.row);
    
    NSMutableArray *innerarray=[[mainarr objectAtIndex:indexPath.row]mutableCopy];
    int miles=[[innerarray objectAtIndex:6] intValue];
    [innerarray removeObjectAtIndex:6];
    [innerarray insertObject:[NSString stringWithFormat:@"%d",!miles] atIndex:6];
    [mainarr removeObjectAtIndex:indexPath.row];
    [mainarr insertObject:innerarray atIndex:indexPath.row];
    [self.tableview reloadData];
}


-(void)touched:(id)sender{
    NSLog(@"Hiello");
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    NSIndexPath *path = [NSIndexPath indexPathForRow:[tapRecognizer.view tag] inSection:0];
    [self.tableview reloadData];
    path=[NSIndexPath indexPathForItem:0 inSection:0];
    [prefs setInteger:0 forKey:@"added"];
    NSMutableArray *innerarray=[[mainarr objectAtIndex:[tapRecognizer.view tag]] mutableCopy];
    [self.tableview reloadData];
    int tick=[[innerarray objectAtIndex:4] intValue];
    [innerarray removeObjectAtIndex:4];
    [innerarray insertObject:[NSString stringWithFormat:@"%d",!tick] atIndex:4];
    if([[innerarray objectAtIndex:4] isEqualToString:@"0"]){
        [jsonarray replaceObjectAtIndex:[tapRecognizer.view tag] withObject:[innerarray objectAtIndex:5]];
    }
    else{
        [jsonarray replaceObjectAtIndex:[tapRecognizer.view tag] withObject:@""];
    }
    [mainarr removeObjectAtIndex:[tapRecognizer.view tag]];
    [mainarr insertObject:innerarray atIndex:[tapRecognizer.view tag]];
    [prefs setObject:mainarr forKey:@"mainarray"];
    NSString *s;
    for (NSArray *a in mainarr) {
        if([[a objectAtIndex:4] isEqualToString:@"0"]){
            s=[a objectAtIndex:4];
        }
        
    }
    if([s isEqualToString:@"0"]){
        [self.submitbtn setHidden:NO];
    }
    else{
        [self.submitbtn setHidden:YES];
    }
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        
        
        /*alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"This will remove the selected route permanently. Are you sure ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        ind=indexPath;
        alert.tag=1;
        [alert show];*/
        
        UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"Warning" message:@"This will remove the selected route permanently. Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* modify = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
        UIAlertAction* submit = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                int row=(int)[ind row];
                [mainarr removeObjectAtIndex:row];
                [jsonarray removeObjectAtIndex:row];
                [prefs setObject:mainarr forKey:@"mainarray"];
                [self.tableview reloadData];
                if(mainarr.count==0){
                    edit = 1;
                    //[self performSegueWithIdentifier:@"addmoreroutes" sender:nil];
                    NSString *restorationID = [[self.navigationController.viewControllers lastObject]restorationIdentifier];
                    NSString *previousrestorationID = [[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2]restorationIdentifier];
                    if([restorationID isEqualToString:@"listroutes"] && ![previousrestorationID isEqualToString:@"addnewroute"]){
                        [self performSegueWithIdentifier:@"addmoreroutes" sender:nil];
                    }else{
                        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"closeall"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
        }];
        
        [alrt addAction:modify];
        [alrt addAction:submit];
        [[[[alrt view]subviews] objectAtIndex:0] setBackgroundColor:[UIColor whiteColor]];
        [[[alrt view] layer] setCornerRadius:10];
        [[[alrt view] layer] setMasksToBounds:YES];
        [[[alrt view] layer] setCornerRadius:10];
        [[[alrt view] layer] setMasksToBounds:YES];
        [self presentViewController:alrt animated:YES completion:nil];
        
        
        
        opened=YES;
    }];
    button.backgroundColor = [UIColor colorWithRed:0.858 green:0.211 blue:0.196 alpha:1];
    UITableViewRowAction *button2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@" Edit " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [prefs setInteger:1 forKey:@"edit"];
        edit = 1;
        NSMutableArray *a=[[NSMutableArray alloc] init];
        NSArray *cellData = [mainarr objectAtIndex:[indexPath row]];
        NSArray *routevalues=[cellData objectAtIndex:1];
        NSArray *imagevalues=[cellData objectAtIndex:2];
        NSArray *captionvalues=[cellData objectAtIndex:3];
        [a removeAllObjects];
        [prefs setObject:jsonarray forKey:@"json"];
        [prefs setObject:[routevalues valueForKey:@"routes"] forKey:@"temp"];
        [prefs setObject:[imagevalues valueForKey:@"images"] forKey:@"image"];
        [prefs setObject:[captionvalues valueForKey:@"captions"] forKey:@"caption"];
        [prefs setInteger:indexPath.section forKey:@"editindex"];
        [prefs setInteger:1 forKey:@"editingroute"];
        edit = 1;
        //[self performSegueWithIdentifier:@"addmoreroutes" sender:nil];
        NSString *restorationID = [[self.navigationController.viewControllers lastObject]restorationIdentifier];
        NSString *previousrestorationID = [[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2]restorationIdentifier];
        if([restorationID isEqualToString:@"listroutes"] && ![previousrestorationID isEqualToString:@"addnewroute"]){
            [self performSegueWithIdentifier:@"addmoreroutes" sender:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    button2.backgroundColor = [UIColor colorWithRed:0.756 green:0.756 blue:0.756 alpha:1];
    return @[button, button2];
        
}



-(void)gestureToShowDeleteButton{
    [UIView animateWithDuration:0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{
        [btn setFrame:CGRectMake(160, 10, 128, 55)];
    }
                     completion:^(BOOL finished){ }
     ];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // you need to implement this method too or nothing will work:
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}





- (IBAction)addmoresurvey:(id)sender {
    [prefs setInteger:0 forKey:@"edit"];
    [prefs setObject:jsonarray forKey:@"json"];
    edit = 1;
    //[self performSegueWithIdentifier:@"addmoreroutes" sender:self];
    NSString *restorationID = [[self.navigationController.viewControllers lastObject]restorationIdentifier];
    NSString *previousrestorationID = [[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2]restorationIdentifier];
    if([restorationID isEqualToString:@"listroutes"] && ![previousrestorationID isEqualToString:@"addnewroute"]){
        [self performSegueWithIdentifier:@"addmoreroutes" sender:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)backtocategories:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)selectedRow{
    
    if(self.submitbtn.enabled){
        [self.submitbtn setTitle:@"Submitting" forState:UIControlStateSelected];
        self.submitbtn.enabled=NO;
    }
    else{
        [self.submitbtn setTitle:@"Submit" forState:UIControlStateNormal];
        self.submitbtn.enabled=YES;
    }
}


- (IBAction)submitsurvey:(id)sender {
    
    NSMutableArray *jsonarr=[NSMutableArray array];
    for(id obj in jsonarray){
        NSString *str=(NSString *)obj;
        if([str isEqualToString:@""]){
        }
        else{
            [jsonarr addObject:str];
        }
    }
    
    NSLog(@"%@",jsonarr);
    [self.spinner setHidden:NO];
    //NSString *urlString=[NSString stringWithFormat:@"http://plaque.pps.leedon.io/buildings/LEED:%@/survey/transit/?key=%@&recompute_score=1",[prefs objectForKey:@"leed_id"],[prefs objectForKey:@"key"]];
        NSString *urlString=[NSString stringWithFormat:@"%@assets/LEED:%@/survey/transit/?subscription-key=%@&key=%@&recompute_score=1",domain_url,[prefs objectForKey:@"leed_id"],subscription_key,[prefs objectForKey:@"key"]];
    NSMutableData *body = [[NSMutableData alloc] init];
    NSString *header=[[NSString alloc] init];    
    NSString *string = [jsonarr componentsJoinedByString:@","];
    NSLog(@"%@",string);
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:urlString]];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStorage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    //header=[NSString stringWithFormat: @"{\n    \"instance\" : %@,\n    \"response_method\": \"web\",\n    \"routes\":[%@]\n}",randomString,string];
    //header =[NSString stringWithFormat: @"{\n \"instance\":%@,\n \"response_method\":\"web\",\n \"routes\":[%@],\n \"tenant_name\":\"\",\n \"language\":\"English\"}",randomString,string];
    header =[NSString stringWithFormat: @"{\n \"tenant_name\": \"\",\n \"response_method\":\"web\",\n \"routes\":[%@],\n \"tenant_name\":\"\",\n \"language\":\"English\"}",string];
    
    
    //{"tenant_name":"Test user","response_method":"web","routes":[{"walk":1,"bus":0,"light_rail":0,"heavy_rail":0,"motorcycle":0,"car":0,"car23":0,"cars4":0}],"language":"English"}
    
    
    [body appendData:[[NSString stringWithString:header] dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"Body is %@",header);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:subscription_key forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:body];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        int code =(int)[(NSHTTPURLResponse *)response statusCode];
        [self.spinner setHidden:YES];
        if (code == 401) {           // check for http errors
            dispatch_async(dispatch_get_main_queue(), ^{
                self.spinner.hidden = YES;
                self.view.userInteractionEnabled = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"renewtoken" object:nil userInfo:nil];
            });
        }
        else if (code == 200 || code == 201){
            dispatch_async(dispatch_get_main_queue(), ^{
                [prefs setInteger:0 forKey:@"transithide"];
                UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"Success" message:@"Thanks for submitting your route. Would you like to add another?" preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction* modify = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    if((int)[prefs integerForKey:@"humanhide"]==0){
                        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                        d[@"message"] = @"Thank you for taking the time";
                        d[@"type"] = @"message";
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
                        [self backtocategories:nil];
                    }
                    else{
                        
                        //[self performSegueWithIdentifier:@"gotohuman" sender:nil];
                        NSMutableArray *transportationarray=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"transportationarray"]]mutableCopy];
                        NSMutableArray *a=[[NSMutableArray alloc] init];
                        NSString *str=[prefs objectForKey:@"transportbuildingid"];
                        
                        [a addObject:str];
                        [a addObject:mainarr];
                        [prefs setObject:mainarr forKey:@"mainarray"];
                        if((int)[prefs integerForKey:@"url"]!=1){
                            int lid=[str intValue];
                            int exists=0;
                            for (int i=0; i<transportationarray.count; i++) {
                                NSMutableArray *aa=[[[NSMutableArray alloc] initWithArray:[transportationarray objectAtIndex:i]] mutableCopy];
                                if(aa.count!=0){
                                    int templid=[[aa objectAtIndex:0] intValue];
                                    if(lid==templid){
                                        [transportationarray replaceObjectAtIndex:i withObject:a];
                                        [prefs setObject:transportationarray forKey:@"transportationarray"];
                                        exists=1;
                                        break;
                                    }
                                }
                            }
                            
                            
                            if((transportationarray.count==0)||(exists!=1)){
                                [transportationarray addObject:a];
                                [prefs setObject:transportationarray forKey:@"transportationarray"];
                            }
                            
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"performsegue" object:nil userInfo:@{@"seguename":@"gotohuman"}];
                        
                    }

                }];
                
                UIAlertAction* submit = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                        edit = 1;
                        //[self performSegueWithIdentifier:@"addmoreroutes" sender:nil];
                        NSString *restorationID = [[self.navigationController.viewControllers lastObject]restorationIdentifier];
                        NSString *previousrestorationID = [[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2]restorationIdentifier];
                        if([restorationID isEqualToString:@"listroutes"] && ![previousrestorationID isEqualToString:@"addnewroute"]){
                            [self performSegueWithIdentifier:@"addmoreroutes" sender:nil];
                        }else{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    

                }];
                [alrt addAction:modify];
                [alrt addAction:submit];
                [[[[alrt view]subviews] objectAtIndex:0] setBackgroundColor:[UIColor whiteColor]];
        [[[alrt view] layer] setCornerRadius:10];
        [[[alrt view] layer] setMasksToBounds:YES];
                [self presentViewController:alrt animated:YES completion:nil];
                
                //alert = [[UIAlertView alloc] initWithTitle:@"Success"message:@"" delegate:self cancelButtonTitle:@"No"otherButtonTitles:@"Yes", nil];
                //alert.tag=2;
                //[alert show];
                opened=YES;
            });
            
        }
        else if(code==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"" message:@"Please check your internet connection" preferredStyle:UIAlertControllerStyleAlert];
                //[self presentViewController:alrt animated:YES completion:nil];
                //[self performSelector:@selector(dismissAlert:) withObject:alrt afterDelay:1.0f];
                //[self maketoast:@"Please check your internet connection" withbackground:[UIColor blackColor] withdelay:4.5];
                NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                d[@"message"] = @"Please check your internet connection";
                d[@"type"] = @"error";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
            });
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"" message:@"Transit Survey Submission Failed" preferredStyle:UIAlertControllerStyleAlert];
                //[self presentViewController:alrt animated:YES completion:nil];
                //[self performSelector:@selector(dismissAlert:) withObject:alrt afterDelay:1.0f];
                //[self maketoast:@"Transit survey submission failed" withbackground:[UIColor blackColor] withdelay:4.5];
                NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                d[@"message"] = @"Transit survey submission failed";
                d[@"type"] = @"error";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
            });
        }
        
    }];
    [postDataTask resume];
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




- (IBAction)backbarbtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissAlert:(UIAlertController *)alert{
    [self dismissViewControllerAnimated:alert completion:nil];
}

- (IBAction)assist:(id)sender {
    UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"Need help submitting routes?" message:@"Please select your route(s) and then submit. To edit or delete the route, just swipe left on the route" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* modify = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    [alrt addAction:modify];
    [[[[alrt view]subviews] objectAtIndex:0] setBackgroundColor:[UIColor whiteColor]];
        [[[alrt view] layer] setCornerRadius:10];
        [[[alrt view] layer] setMasksToBounds:YES];
    [self presentViewController:alrt animated:YES completion:nil];
    
    opened=YES;
}
@end
