//
//  buttonarrayforhumansurvey.m
//  connection
//
//  Created by Group10 on 22/03/15.
//  Copyright (c) 2015 Group10. All rights reserved.
//

#import "buttonarrayforhumansurvey.h"

@interface buttonarrayforhumansurvey ()
@end

//Earlier background color is lightGray

@implementation buttonarrayforhumansurvey
@synthesize textVie;
@synthesize next;


-(void)viewDidAppear:(BOOL)animated{
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"building_details"]];
    self.navigationController.navigationBar.backItem.title = dict[@"name"];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.spinner.layer setCornerRadius:10];
    [self.spinner.layer setMasksToBounds:YES];
    [self.spinner setHidden:YES];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"building_details"]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans" size:17], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",dict[@"name"]]];
    subscription_key = @"e6aecd40e07c40718a0b3ed9a0cc609d";//"f94b34f0576f4a85b3c0c22eefb625b3";
    domain_url = @"https://api.usgbc.org/stg/leed/";
    survey_url = @"https://stg.app.arconline.io/app/project/";

    
    [_selectthat setFont:[UIFont fontWithName:@"OpenSans" size:20]];
    [_selectthat setAdjustsFontSizeToFitWidth:YES];
    opened=NO;
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    labelForTitle= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    labelForTitle.font = [UIFont fontWithName:@"GothamBook" size:15];
    [labelForTitle setCenter:titleView.center];
    labelForTitle.text = @"Sorry to hear that!";
    labelForTitle.numberOfLines=2;
    [titleView addSubview:labelForTitle];
    otherlabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    otherlabel.font = [UIFont fontWithName:@"GothamBook" size:15];
    [otherlabel setCenter:titleView.center];
    otherlabel.text = @"Other";
    otherlabel.numberOfLines=1;
    otherlabel.hidden=YES;
    [titleView addSubview:otherlabel];
    [self.nav1 setTitleView:titleView];
    prefs=[NSUserDefaults standardUserDefaults];
    [prefs synchronize];
    [textVie setUserInteractionEnabled:YES];
    submitteddonthide=[prefs integerForKey:@"humandone"];
    i=0;
    hot=dirty=dark=loud=stuffy=cold=smelly=glare=privacy=other=0;
    experiencearr=[[[NSMutableArray alloc ]initWithArray:[prefs objectForKey:@"experiencearr"]] mutableCopy];
    NSLog(@"Experience arr is %@",experiencearr);
    position=[[experiencearr objectAtIndex:0] intValue];
    NSMutableArray *experience=[[NSMutableArray alloc] initWithArray:[experiencearr objectAtIndex:1]];
    if (experience.count>0) {
        dark=[[experience objectAtIndex:1] intValue];
        cold=[[experience objectAtIndex:5] intValue];
        smelly=[[experience objectAtIndex:6] intValue];
        stuffy=[[experience objectAtIndex:4] intValue];
        privacy=[[experience objectAtIndex:8] intValue];
        loud=[[experience objectAtIndex:3] intValue];
        dirty=[[experience objectAtIndex:2] intValue];
        hot=[[experience objectAtIndex:0] intValue];
        other=[[experience objectAtIndex:9] intValue];
        glare=[[experience objectAtIndex:7] intValue];
        str=[experience objectAtIndex:10];
    }
    hotcheckBoxSelected=hot;
    darkcheckBoxSelected=dark;
    dirtycheckBoxSelected=dirty;
    loudcheckBoxSelected=loud;
    stuffycheckBoxSelected=stuffy;
    coldcheckBoxSelected=cold;
    smellycheckBoxSelected=smelly;
    privacycheckBoxSelected=privacy;
    glarecheckBoxSelected=glare;
    othercheckBoxSelected=other;
    self.vv.layer.cornerRadius=5;
    [self.vv.layer setMasksToBounds:YES ];
    self.vv.hidden=YES;
   
    othertext=NO;
    height=[UIScreen mainScreen].bounds.size.height;
    width=[UIScreen mainScreen].bounds.size.width;
    y=0.3640*height;
    it=0;
    for (int j=0; j<=4; j++) {
        NSString *title=@"Button";
        Button=[[UIButton alloc] initWithFrame:CGRectMake(4, y, 0.483*width, 0.0904*height)];
        if(j==0){
            title=@"Hot";
            [Button setImage:[UIImage imageNamed:@"ic_lomobile_env_hot.png"]
                    forState:UIControlStateNormal];
            
        }
        else if(j==1){
            [Button setImage:[UIImage imageNamed:@"ic_lomobile_env_dirty.png"]
                    forState:UIControlStateNormal];
            title=@"Dirty";
        }
        else if(j==2){
            [Button setImage:[UIImage imageNamed:@"ic_lomobile_env_dark.png"]
                    forState:UIControlStateNormal];
            title=@"Dark";
        }
        else if(j==3){
            [Button setImage:[UIImage imageNamed:@"ic_lomobile_env_loud.png"]
                    forState:UIControlStateNormal];
            title=@"Loud";
        }
        else if(j==4){
            [Button setImage:[UIImage imageNamed:@"ic_lomobile_env_stuffy.png"]
                    forState:UIControlStateNormal];
            title=@"Stuffy";
        }
        [Button setTitle:title forState:UIControlStateNormal];
        Button.backgroundColor=[UIColor darkGrayColor];
        [Button setImageEdgeInsets:UIEdgeInsetsMake(7.0, 0.0276*width, 3.0, 0.3548*width)];
        [Button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.04125*width, 0.0, -0.03125*width)];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        Button.titleLabel.font=[UIFont fontWithName:@"Gotham" size:19];
        }
        else{
            Button.titleLabel.font=[UIFont fontWithName:@"Gotham" size:16];
        }
        [Button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [Button setTag:1000+j];
        [Button addTarget:self action:@selector(scanBarCode:) forControlEvents:UIControlEventTouchDown];
        Button.layer.cornerRadius=5;
        checkbox=[[UIButton alloc] initWithFrame:CGRectMake(0.504*width, y, 0.483*width, 0.0904*height)];
        [checkbox setBackgroundColor:[UIColor darkGrayColor]];
        if(j==0){
            title=@"Cold";
            [checkbox setImage:[UIImage imageNamed:@"ic_lomobile_env_cold.png"]
                      forState:UIControlStateNormal];
        }
        else if(j==1){
            [checkbox setImage:[UIImage imageNamed:@"ic_lomobile_env_smelly.png"]
                      forState:UIControlStateNormal];
            title=@"Smelly";
        }
        else if(j==2){
            [checkbox setImage:[UIImage imageNamed:@"ic_lomobile_env_glare.png"]
                      forState:UIControlStateNormal];
            title=@"Glare";
        }
        else if(j==3){
            [checkbox setImage:[UIImage imageNamed:@"ic_lomobile_env_privacy.png"]
                      forState:UIControlStateNormal];
            title=@"Privacy";
        }
        else if(j==4){
            [checkbox setImage:[UIImage imageNamed:@"ic_lomobile_env_other.png"]
                      forState:UIControlStateNormal];
            title=@"Other";
        }
        [UIView setAnimationsEnabled:YES];
        [checkbox setTitle:title forState:UIControlStateNormal];
        [checkbox setImageEdgeInsets:UIEdgeInsetsMake(7.0, 0.0276*width, 3.0, 0.3548*width)];
        [checkbox setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.03125*width, 0.0, -0.03125*width)];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            checkbox.titleLabel.font=[UIFont fontWithName:@"Gotham" size:19];
        }
        else{
            checkbox.titleLabel.font=[UIFont fontWithName:@"Gotham" size:16];
        }
        [checkbox setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [UIView setAnimationsEnabled:YES];
        [checkbox setTag:2000+j];
        if(Button.tag==1001){
            if(dirty==1){
                [Button setBackgroundColor:[UIColor colorWithRed:0.772 green: 0.721 blue:0.318 alpha:1]];
            }
        }
        if(Button.tag==1000){
            if(hot==1){
               [Button setBackgroundColor:[UIColor colorWithRed:1 green: 0.361 blue:0.167 alpha:1]];
            }
        }
        if(Button.tag==1002){
            if(dark==1){
                [Button setBackgroundColor:[UIColor colorWithRed:0.0775 green: 0.167 blue:0.488 alpha:1]];
            }
        }
        if(Button.tag==1003){
            if(loud==1){
                  [Button setBackgroundColor:[UIColor colorWithRed:0.73 green: 0.161 blue:0.419 alpha:1]];
            }
        }
        if(Button.tag==1004){
            if(stuffy==1){
                 [Button setBackgroundColor:[UIColor colorWithRed:0.596 green: 0.73 blue:0.224 alpha:1]];
            }
        
        }
        if(checkbox.tag==2000){
            if(cold==1){
                 [checkbox setBackgroundColor: [UIColor colorWithRed:0.2 green: 0.682 blue:1 alpha:1]];

            }
        }
        if(checkbox.tag==2001){
            if(smelly==1){
                [checkbox setBackgroundColor:[UIColor colorWithRed:0.219 green: 0.836 blue:0.723 alpha:1]];
            }
        }
        if(checkbox.tag==2002){
            if(glare==1){
                
                 [checkbox setBackgroundColor:[UIColor colorWithRed:1 green: 0.81 blue:0.242 alpha:0.8]];
            }
        }
        if(checkbox.tag==2003){
            if(privacy==1){
                [checkbox setBackgroundColor:[UIColor colorWithRed:0.865 green: 0.497 blue:0.0199 alpha:1]];
            }
        }
        if(checkbox.tag==2004){
            if(other==1){
               [checkbox setBackgroundColor:[UIColor colorWithRed:0.661 green: 0.384 blue:1 alpha:1]];
            }
        }
        [checkbox addTarget:self action:@selector(scanBarCode:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:Button];
        [self.view addSubview:checkbox];
        [checkbox.layer setCornerRadius:5];
        y+=0.09812*height;
    }
    [self.view bringSubviewToFront:self.spinner];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    NSMutableArray *experience=[[NSMutableArray alloc] init];
    [experience addObject:[NSString stringWithFormat:@"%d",hot]];
    [experience addObject:[NSString stringWithFormat:@"%d",dark]];
    [experience addObject:[NSString stringWithFormat:@"%d",dirty]];
    [experience addObject:[NSString stringWithFormat:@"%d",loud]];
    [experience addObject:[NSString stringWithFormat:@"%d",stuffy]];
    [experience addObject:[NSString stringWithFormat:@"%d",cold]];
    [experience addObject:[NSString stringWithFormat:@"%d",smelly]];
    [experience addObject:[NSString stringWithFormat:@"%d",glare]];
    [experience addObject:[NSString stringWithFormat:@"%d",privacy]];
    [experience addObject:[NSString stringWithFormat:@"%d",other]];
    [experience addObject:[NSString stringWithFormat:@"%@",textVie.text]];
    
    [experiencearr replaceObjectAtIndex:1 withObject:experience];
    NSMutableArray *experiencearr=[[NSMutableArray alloc] init];
    [experiencearr addObject:[NSString stringWithFormat:@"%d",position]];
    [experiencearr addObject:experience];
    [prefs setObject:experiencearr forKey:@"experiencearr"];
    NSLog(@"experience arra is %@",experiencearr);
    
    int leedid=[[prefs objectForKey:@"humanbuildingid"] intValue];
    NSMutableArray *humanexarray=[[[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"humanexarray"]] mutableCopy];
    for(int i=0;i<humanexarray.count;i++){
        NSMutableArray *a=[[[NSMutableArray alloc] initWithArray:[humanexarray objectAtIndex:i]] mutableCopy];
        int templeedid=[[a objectAtIndex:0] intValue];
        if(leedid==templeedid){
            [a replaceObjectAtIndex:1 withObject:experiencearr];
            [humanexarray replaceObjectAtIndex:i withObject:a];
            break;
        }
    }
    [prefs setObject:humanexarray forKey:@"humanexarray"];
    [UIView setAnimationsEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


-(IBAction)scanBarCode:(id)sender{
    cliked=(UIButton *)sender;
    if(cliked.tag==1000){
        if(hotcheckBoxSelected){
            [cliked setBackgroundColor:[UIColor darkGrayColor]];
            hotcheckBoxSelected = !hotcheckBoxSelected;
            [cliked setSelected:hotcheckBoxSelected];
            hot=0;
        }else{
            hotcheckBoxSelected=!hotcheckBoxSelected;
            [cliked setSelected:hotcheckBoxSelected];
            [cliked setBackgroundColor:[UIColor colorWithRed:1 green: 0.361 blue:0.167 alpha:1]];
            hot=1;
        }
    }
    else if(cliked.tag==1001){
        if(dirtycheckBoxSelected){
            [cliked setBackgroundColor:[UIColor darkGrayColor]];
            dirtycheckBoxSelected = !dirtycheckBoxSelected;
            [cliked setSelected:dirtycheckBoxSelected];
            dirty=0;
        }else{
            dirtycheckBoxSelected=!dirtycheckBoxSelected;
            [cliked setSelected:dirtycheckBoxSelected];
            [cliked setBackgroundColor:[UIColor colorWithRed:0.772 green: 0.721 blue:0.318 alpha:1]];
            dirty=1;
        }
    }
    else if(cliked.tag==1002){
        if(darkcheckBoxSelected){
            [cliked setBackgroundColor:[UIColor darkGrayColor]];
            darkcheckBoxSelected = !darkcheckBoxSelected;
            [cliked setSelected:darkcheckBoxSelected];
            dark=0;
        }else{/* Toggle */
            darkcheckBoxSelected=!darkcheckBoxSelected;
            [cliked setSelected:darkcheckBoxSelected];
            [cliked setBackgroundColor:[UIColor colorWithRed:0.0775 green: 0.167 blue:0.488 alpha:1]];
            dark=1;
        }
    }
    else if(cliked.tag==1003){
        if(loudcheckBoxSelected){
            [cliked setBackgroundColor:[UIColor darkGrayColor]];
            loudcheckBoxSelected = !loudcheckBoxSelected;
            [cliked setSelected:loudcheckBoxSelected];
            loud=0;
        }else{
            loudcheckBoxSelected=!loudcheckBoxSelected;
            [cliked setSelected:loudcheckBoxSelected];
            [cliked setBackgroundColor:[UIColor colorWithRed:0.73 green: 0.161 blue:0.419 alpha:1]];
            loud=1;
        }
    }
    
    else if(cliked.tag==1004){
        
        if(stuffycheckBoxSelected){
            [cliked setBackgroundColor:[UIColor darkGrayColor]];
            stuffycheckBoxSelected = !stuffycheckBoxSelected;
            [cliked setSelected:stuffycheckBoxSelected];
            stuffy=0;
        }else{/* Toggle */
            stuffycheckBoxSelected=!stuffycheckBoxSelected;
            [cliked setSelected:stuffycheckBoxSelected];
            [cliked setBackgroundColor:[UIColor colorWithRed:0.596 green: 0.73 blue:0.224 alpha:1]];
            stuffy=1;
        }
    }
    else if(cliked.tag==2000){
        if(coldcheckBoxSelected){
            [cliked setBackgroundColor:[UIColor darkGrayColor]];
            coldcheckBoxSelected = !coldcheckBoxSelected;
            [cliked setSelected:coldcheckBoxSelected];
            cold=0;
        }else{
            coldcheckBoxSelected=!coldcheckBoxSelected;
            [cliked setSelected:coldcheckBoxSelected];
            [cliked setBackgroundColor: [UIColor colorWithRed:0.2 green: 0.682 blue:1 alpha:1]];
            cold=1;
        }
    }
    else if(cliked.tag==2001){
        if(smellycheckBoxSelected){
            [cliked setBackgroundColor:[UIColor darkGrayColor]];
            smellycheckBoxSelected = !smellycheckBoxSelected;
            [cliked setSelected:smellycheckBoxSelected];
            smelly=0;
        }else{
            smellycheckBoxSelected=!smellycheckBoxSelected;
            [cliked setSelected:smellycheckBoxSelected];
            [cliked setBackgroundColor:[UIColor colorWithRed:0.219 green: 0.836 blue:0.723 alpha:1]];
            smelly=1;
        }
    }
    else if(cliked.tag==2002){
        if(glarecheckBoxSelected){
            [cliked setBackgroundColor:[UIColor darkGrayColor]];
            glarecheckBoxSelected = !glarecheckBoxSelected;
            [cliked setSelected:glarecheckBoxSelected];
            glare=0;
        }else{
            glarecheckBoxSelected=!glarecheckBoxSelected;
            [cliked setSelected:glarecheckBoxSelected];
            [cliked setBackgroundColor:[UIColor colorWithRed:1 green: 0.81 blue:0.242 alpha:0.8]];
            glare=1;
        }
    }
    else if(cliked.tag==2003){
        if(privacycheckBoxSelected){
            [cliked setBackgroundColor:[UIColor darkGrayColor]];
            privacycheckBoxSelected = !privacycheckBoxSelected;
            [cliked setSelected:privacycheckBoxSelected];
            privacy=0;
        }else{
            privacycheckBoxSelected=!privacycheckBoxSelected;
            [cliked setSelected:privacycheckBoxSelected];
            [cliked setBackgroundColor:[UIColor colorWithRed:0.865 green: 0.497 blue:0.0199 alpha:1]];
            privacy=1;
        }
    }
    else if(cliked.tag==2004){
        otherlabel.hidden=NO;
        labelForTitle.hidden=YES;
        self.sorytohearthat.text=@"Other";
        [self.goback setBackgroundImage:[UIImage imageNamed:@"ic_lomobile_menu_cancel_black.png"] forState:UIControlStateNormal];
        self.selectthat.hidden=YES;
        self.vv.hidden=NO;
        self.textVie.text=str;
        next.hidden=YES;
        [self.textVie becomeFirstResponder];
        [[self.view viewWithTag:1000] setHidden:YES];
        [[self.view viewWithTag:1001] setHidden:YES];
        [[self.view viewWithTag:1002] setHidden:YES];
        [[self.view viewWithTag:1003] setHidden:YES];
        [[self.view viewWithTag:2000] setHidden:YES];
        [[self.view viewWithTag:2001] setHidden:YES];
        [[self.view viewWithTag:2002] setHidden:YES];
        [[self.view viewWithTag:1004] setHidden:YES];
        [[self.view viewWithTag:2003] setHidden:YES];
        [[self.view viewWithTag:2004] setHidden:YES];
        othertext=YES;
        i=1;
    }
}
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textVie==self.textVie){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.2];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.vv.frame=CGRectMake(self.vv.frame.origin.x,self.vv.frame.origin.y
                                 ,self.vv.frame.size.width,self.vv.frame.size.height);
        self.vv.frame=CGRectMake(self.vv.frame.origin.x,self.vv.frame.origin.y
                                 ,self.vv.frame.size.width,self.vv.frame.size.height/2);
        [UIView commitAnimations];
    }
}

- (void)textViewDidFinishEditing:(UITextView *)textView
{
   
    [textVie resignFirstResponder];
    [textVie endEditing:YES];
}


- (void)textViewDidChange:(UITextView *)textView{
    if (textVie== self.textVie)
    {
        NSString *substring = [NSString stringWithString:textView.text];
        if (substring.length > 0) {
            self.numberofcharacters.text=@"256";
            self.numberofcharacters.text = [NSString stringWithFormat:@"%d", 256-(int)substring.length];
        }
        if (substring.length == 0) {
            self.numberofcharacters.text=@"256";
            self.numberofcharacters.hidden = NO;
        }
    }
    else{
        [self.textVie resignFirstResponder];
        [self.textVie endEditing:YES];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\b"]){
        return YES;
    }else if([[self.textVie text] length] - range.length + text.length > 256){
        return NO;
    }
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (IBAction)otherdone:(id)sender {
    otherlabel.hidden=YES;
    labelForTitle.hidden=NO;
    str=self.textVie.text;
    next.hidden=NO;
    if([self.textVie.text length]==0){
        [cliked setBackgroundColor:[UIColor darkGrayColor]];
        othercheckBoxSelected = !othercheckBoxSelected;
        [cliked setSelected:othercheckBoxSelected];
        other=0;
    }
    else{
        [cliked setSelected:othercheckBoxSelected];
        [cliked setBackgroundColor:[UIColor colorWithRed:0.661 green: 0.384 blue:1 alpha:1]];
        other=1;
    }
    [self back:nil];
}





- (IBAction)back:(id)sender {
 
          if(i==1){
              labelForTitle.hidden=NO;
              otherlabel.hidden=YES;
              self.vv.frame=CGRectMake(self.vv.frame.origin.x,self.vv.frame.origin.y,self.vv.frame.size.width,self.vv.frame.size.height*2);
        self.vv.hidden=YES;
        self.sorytohearthat.text=@"Sorry for that!";
        [self.textVie resignFirstResponder];
        [self.textVie endEditing:YES];
        [self.goback setBackgroundImage:[UIImage imageNamed:@"ic_lomobile_menu_back.png"] forState:UIControlStateNormal];
        othertext=NO;
        self.sorytohearthat.hidden=NO;
        self.selectthat.hidden=NO;
        [textVie resignFirstResponder];
        [[self.view viewWithTag:1000] setHidden:NO];
        [[self.view viewWithTag:1001] setHidden:NO];
        [[self.view viewWithTag:1002] setHidden:NO];
        [[self.view viewWithTag:1003] setHidden:NO];
        [[self.view viewWithTag:2000] setHidden:NO];
        [[self.view viewWithTag:2001] setHidden:NO];
        [[self.view viewWithTag:2002] setHidden:NO];
        [[self.view viewWithTag:1004] setHidden:NO];
        [[self.view viewWithTag:2003] setHidden:NO];
        [[self.view viewWithTag:2004] setHidden:NO];
        i=0;
        next.hidden=NO;
    }
    else{
        labelForTitle.hidden=NO;
        otherlabel.hidden=YES;
        [prefs setInteger:hot forKey:@"hot"];
        [prefs setInteger:dark forKey:@"dark"];
        [prefs setInteger:dirty forKey:@"dirty"];
        [prefs setInteger:loud forKey:@"loud"];
        [prefs setInteger:stuffy forKey:@"stuffy"];
        [prefs setInteger:cold forKey:@"cold"];
        [prefs setInteger:smelly forKey:@"smelly"];
        [prefs setInteger:glare forKey:@"glare"];
        [prefs setInteger:privacy forKey:@"privacy"];
        [prefs setInteger:other forKey:@"other"];
        [prefs setObject:textVie.text forKey:@"vvtext"];
        //[self performSegueWithIdentifier:@"smiley" sender:self];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}




- (IBAction)humansurveycomplete:(id)sender {

    if((hot+dirty+dark+loud+stuffy+cold+smelly+glare+privacy+other)==0){
      UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"" message:@"Please choose at least one option" preferredStyle:UIAlertControllerStyleAlert];
        
        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        d[@"message"] = @"Please choose at least one option";
        d[@"type"] = @"error";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
        
        //[self presentViewController:alrt animated:YES completion:nil];
         //[self performSelector:@selector(dismissAlert:) withObject:alrt afterDelay:1.0f];
        //[self maketoast:@"Please choose at least one option" withbackground:[UIColor blackColor] withdelay:4.5];
    }
    else{
        
        UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"Survey submission" message:@"Please enter your details" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction* modify = [UIAlertAction actionWithTitle:@"Modify" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
        UIAlertAction* submit = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *txt = alrt.textFields[0];
            NSLog(@"%@",txt.text);
            
            opened=NO;
                if(alrt.textFields[0].text.length == 0)
                {
                    
                }
                NSMutableArray *USAImages = [NSMutableArray array];
                if(hot==1){
                    NSString *st=@"hot";
                    [USAImages addObject:st];
                }
                if(dirty==1){
                    NSString *st=@"dirty";
                    [USAImages addObject:st];
                }
                if(dark==1){
                    NSString *st=@"dark";
                    [USAImages addObject:st];
                }
                if(loud==1){
                    NSString *st=@"loud";
                    [USAImages addObject:st];
                }
                if(stuffy==1){
                    NSString *st=@"stuffy";
                    [USAImages addObject:st];
                }
                if(cold==1){
                    NSString *st=@"cold";
                    [USAImages addObject:st];
                }
                if(glare==1){
                    NSString *st=@"glare";
                    [USAImages addObject:st];
                }
                if(privacy==1){
                    NSString *st=@"privacy";
                    [USAImages addObject:st];
                }
                if(smelly==1){
                    NSString *st=@"smelly";
                    [USAImages addObject:st];
                }
                NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
                NSMutableString *randomString = [NSMutableString stringWithCapacity: 16];
                for (int _=0; i<16; i++) {
                    [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
                }
            NSString *name=alrt.textFields[0].text;
                NSString *loc=@"";
                NSString *urlString=[NSString stringWithFormat:@"%@assets/LEED:%@/survey/environment/?subscription-key=%@&key=%@&recompute_score=1",domain_url,[prefs objectForKey:@"leed_id"],subscription_key,[prefs objectForKey:@"key"]];
            NSLog(@"%@",urlString);
                NSMutableArray *ar=[[NSMutableArray arrayWithArray:[prefs objectForKey:@"listofrowsforhuman"]]mutableCopy];
                int exist=0;
                int current=(int)[prefs integerForKey:@"humanbuildingid"];
                NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                [dateformate setDateFormat:@"dd/MM/YYYY"];
                NSString *date_String=[dateformate stringFromDate:[NSDate date]];
                
                NSLog(@"%@",ar);
                if((int)[prefs integerForKey:@"url"]!=1){
                    nope=1;
                    [self.spinner setHidden:NO];
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
                    NSMutableURLRequest *urlrequest = [[[NSMutableURLRequest alloc] init] mutableCopy] ;
                    [urlrequest setURL:[NSURL URLWithString:urlString]];
                    [urlrequest setHTTPMethod:@"POST"];
                    [urlrequest setValue:@"application/json" forHTTPHeaderField: @"content-Type"];
                    NSMutableData *body = [[NSMutableData alloc] init];
                    NSString *header;
                    if(other==1){
                        header=[NSString stringWithFormat:@"{\n    \"tenant_name\": \"%@\",\n    \"response_method\": \"web\",\n    \"complaints\": \"[%@]\", \n \"other_complaint\": \"%@\", \n    \"satisfaction\": %i, \n \"language\": \"English\",\"location\": \"\"}",loc, [USAImages componentsJoinedByString:@","], str, position];
                    }
                    else{
                        header=[NSString stringWithFormat:@"{\n    \"tenant_name\": \"%@\",\n    \"response_method\": \"web\",\n    \"complaints\": \"[%@]\", \n \"other_complaint\": \"\", \n    \"satisfaction\": %i, \n \"language\": \"English\",\"location\": \"\"}",loc, [USAImages componentsJoinedByString:@","], position];
                    }
                    NSLog(@"%@",header);
                    
                    
                    
                    [body appendData:[[NSString stringWithString:header] dataUsingEncoding:NSUTF8StringEncoding]];
                    [urlrequest setHTTPBody:body];
                    
                    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                    [configuration setHTTPAdditionalHeaders:@{@"Accept" : @"application/json", @"Content-Type" : @"application/x-www-form-urlencoded"}];
                    NSURLSession *sess = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
                    NSURL *url = [NSURL URLWithString:urlString];
                    NSMutableURLRequest *requst = [NSMutableURLRequest requestWithURL:url
                                                                          cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                      timeoutInterval:60.0];
                    
                    [requst addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                    [requst addValue:subscription_key forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
                    
                    [requst setHTTPMethod:@"POST"];
                    
                    [requst setHTTPBody:body];
                    NSError *error;
                    
                    NSMutableDictionary *mapData = [[NSMutableDictionary alloc] init];
                    
                    mapData[@"tenant_name"] = name;
                    mapData[@"response_method"] = @"web";
                    mapData[@"location"] = loc;
                    mapData[@"satisfaction"] = [NSNumber numberWithInteger:position];
                    mapData[@"complaints"] = [USAImages componentsJoinedByString:@","];
                    mapData[@"other_complaint"] = textVie.text;
                    mapData[@"language"] = @"English";
                    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
                    [requst setHTTPBody:postData];
                    
                    
                    
                    NSURLSessionDataTask *postDataTask = [sess dataTaskWithRequest:requst completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                        
                        int code = (int)[(NSHTTPURLResponse *)response statusCode];
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
                            submitteddonthide=(int)[prefs integerForKey:@"humandone"];
                            UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"" message:@"Human survey submitted" preferredStyle:UIAlertControllerStyleAlert];
                            //[self presentViewController:alrt animated:YES completion:nil];
                            //[self performSelector:@selector(dismissAlert:) withObject:alrt afterDelay:1.0f];
                            //[self maketoast:@"Human survey submitted" withbackground:[UIColor blueColor] withdelay:4.5];
                            NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                            d[@"message"] = @"Human survey submitted";
                            d[@"type"] = @"message";
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
                            
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
                                [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"closeboth"];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            else{
                                [self humantotransit];
                                //[self performSegueWithIdentifier:@"humantotransit" sender:nil];
                            }
                            
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
                            //non_field_errors
                            if(code == 400){
                                NSError *error;
                                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                     options:kNilOptions
                                                                                       error:&error];
                                if(json[@"non_field_errors"] != nil){
                                    UIAlertController *alrtt = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@",json[@"non_field_errors"]] preferredStyle:UIAlertControllerStyleAlert];
                                    //[self presentViewController:alrtt animated:YES completion:nil];
                                    //[self performSelector:@selector(dismissAlert:) withObject:alrtt afterDelay:1.0f];
                                    //[self maketoast:[NSString stringWithFormat:@"%@",json[@"non_field_errors"]] withbackground:[UIColor blackColor] withdelay:4.5];
                                    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                                    d[@"message"] = [NSString stringWithFormat:@"%@",json[@"non_field_errors"]];
                                    d[@"type"] = @"error";
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
                                    
                                }else{
                                    UIAlertController *alrtt = [UIAlertController alertControllerWithTitle:@"" message:@"Something went wrong. Please try again later" preferredStyle:UIAlertControllerStyleAlert];
                                    //[alrt dismissViewControllerAnimated:<#(BOOL)#> completion:<#^(void)completion#>]
                                    //alert.dismissViewControllerAnimated(true, completion: nil)
                                    [alrt dismissViewControllerAnimated:YES completion:nil];
                                    [alrtt dismissViewControllerAnimated:YES completion:nil];
                                    //[self presentViewController:alrtt animated:YES completion:nil];
                                    //[self performSelector:@selector(dismissAlert:) withObject:alrtt afterDelay:1.0f];
                                    //[self maketoast:@"Something went wrong. Please try again later" withbackground:[UIColor blackColor] withdelay:4.5];
                                    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                                    d[@"message"] = @"Something went wrong. Please try again later";
                                    d[@"type"] = @"error";
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
                                }
                            }else{
                            //[self maketoast:@"Something went wrong. Please try again later" withbackground:[UIColor blackColor] withdelay:4.5];
                                NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                                d[@"message"] = @"Something went wrong. Please try again later";
                                d[@"type"] = @"error";
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
                            }
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
                    //[self maketoast:@"You've already taken survey" withbackground:[UIColor blackColor] withdelay:4.5];
                    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
                    d[@"message"] = @"You've already taken survey";
                    d[@"type"] = @"error";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"awbanner" object:nil userInfo:d];
                    
                    if([prefs  integerForKey:@"transithide"]==0){
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                        //  [self performSegueWithIdentifier:@"humantotransit" sender:nil];
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
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSMutableArray *experience=[[NSMutableArray alloc] init];
    [experience addObject:[NSString stringWithFormat:@"%d",hot]];
    [experience addObject:[NSString stringWithFormat:@"%d",dark]];
    [experience addObject:[NSString stringWithFormat:@"%d",dirty]];
    [experience addObject:[NSString stringWithFormat:@"%d",loud]];
    [experience addObject:[NSString stringWithFormat:@"%d",stuffy]];
    [experience addObject:[NSString stringWithFormat:@"%d",cold]];
    [experience addObject:[NSString stringWithFormat:@"%d",smelly]];
    [experience addObject:[NSString stringWithFormat:@"%d",glare]];
    [experience addObject:[NSString stringWithFormat:@"%d",privacy]];
    [experience addObject:[NSString stringWithFormat:@"%d",other]];
    [experience addObject:[NSString stringWithFormat:@"%@",textVie.text]];
    
    [experiencearr replaceObjectAtIndex:1 withObject:experience];
    NSMutableArray *experiencearr=[[NSMutableArray alloc] init];
    [experiencearr addObject:[NSString stringWithFormat:@"%d",position]];
    [experiencearr addObject:experience];
    [prefs setObject:experiencearr forKey:@"experiencearr"];
    NSLog(@"experience arra is %@",experiencearr);
    
    int leedid=[[prefs objectForKey:@"humanbuildingid"] intValue];
    NSMutableArray *humanexarray=[[[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"humanexarray"]] mutableCopy];
    for(int i=0;i<humanexarray.count;i++){
        NSMutableArray *a=[[[NSMutableArray alloc] initWithArray:[humanexarray objectAtIndex:i]] mutableCopy];
        int templeedid=[[a objectAtIndex:0] intValue];
        if(leedid==templeedid){
            [a replaceObjectAtIndex:1 withObject:experiencearr];
            [humanexarray replaceObjectAtIndex:i withObject:a];
            break;
        }
    }
    [prefs setObject:humanexarray forKey:@"humanexarray"];
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
    NSMutableArray *experience=[[NSMutableArray alloc] init];
    [experience addObject:[NSString stringWithFormat:@"%d",hot]];
    [experience addObject:[NSString stringWithFormat:@"%d",dark]];
    [experience addObject:[NSString stringWithFormat:@"%d",dirty]];
    [experience addObject:[NSString stringWithFormat:@"%d",loud]];
    [experience addObject:[NSString stringWithFormat:@"%d",stuffy]];
    [experience addObject:[NSString stringWithFormat:@"%d",cold]];
    [experience addObject:[NSString stringWithFormat:@"%d",smelly]];
    [experience addObject:[NSString stringWithFormat:@"%d",glare]];
    [experience addObject:[NSString stringWithFormat:@"%d",privacy]];
    [experience addObject:[NSString stringWithFormat:@"%d",other]];
    [experience addObject:[NSString stringWithFormat:@"%@",textVie.text]];
    
    [experiencearr replaceObjectAtIndex:1 withObject:experience];
    NSMutableArray *experiencearra=[[NSMutableArray alloc] init];
    [experiencearra addObject:[NSString stringWithFormat:@"%d",position]];
    [experiencearra addObject:experience];
    [prefs setObject:experiencearra forKey:@"experiencearr"];
    NSLog(@"experience arra is %@",experiencearra);
    
    int leedid=[[prefs objectForKey:@"humanbuildingid"] intValue];
    NSMutableArray *humanexarray=[[[NSMutableArray alloc] initWithArray:[prefs objectForKey:@"humanexarray"]] mutableCopy];
    for(int ii=0;ii<humanexarray.count;ii++){
        NSMutableArray *a=[[[NSMutableArray alloc] initWithArray:[humanexarray objectAtIndex:ii]] mutableCopy];
        int templeedid=[[a objectAtIndex:0] intValue];
        if(leedid==templeedid){
            [a replaceObjectAtIndex:1 withObject:experiencearr];
            [humanexarray replaceObjectAtIndex:ii withObject:a];
            break;
        }
    }
    [prefs setObject:humanexarray forKey:@"humanexarray"];
}
- (IBAction)backbtn:(id)sender {
    [self back:nil];
}

-(void)dismissAlert:(UIAlertController *)vc{
    [vc dismissViewControllerAnimated:YES completion:nil];
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
