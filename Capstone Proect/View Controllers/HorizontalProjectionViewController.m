//
//  HorizontalProjectionViewController.m
//  Capstone Proect
//
//  Created by Lilit Avetisyan on 5/13/18.
//  Copyright © 2018 Lil. All rights reserved.
//

#import "HorizontalProjectionViewController.h"

@interface HorizontalProjectionViewController (){
    
    IBOutlet UIView *projectionView;
}

@end

@implementation HorizontalProjectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    projectionView.hidden = YES;
//    [projectionView setFrame:CGRectMake(projectionView.frame.origin.x, projectionView.frame.origin.y, projectionView.frame.size.width, self.rows.count)];
    [self createProjection];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createProjection{
    for (int i = 0; i < self.rows.count; i++) {
        float width = self.view.frame.size.width;
        float lineWidth = width*width/[self.rows[i] intValue];
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 20+i, lineWidth,1 )];
        NSLog(@"rows[i] :%f", lineWidth);
//        NSLog(@"projectionView.frame.origin.y+i :%f", projectionView.frame.origin.y+i);
//        NSLog(@"line height :%f", line.frame.size.height);
//        NSLog(@"projectionView.frame.size.width :%f", width);
        
//        NSLog(@"view height :%f", projectionView.frame.size.height);
        NSLog(@"rows.count :%lu", (unsigned long)self.rows.count);
        [line setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:line];
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

@end
