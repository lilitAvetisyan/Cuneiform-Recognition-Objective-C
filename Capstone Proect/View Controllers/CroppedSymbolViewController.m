//
//  CroppedSymbolViewController.m
//  Capstone Proect
//
//  Created by Lilit Avetisyan on 5/22/18.
//  Copyright © 2018 Lil. All rights reserved.
//

#import "CroppedSymbolViewController.h"

@interface CroppedSymbolViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *croppedSmb;

@end

@implementation CroppedSymbolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _croppedSmb.image = self.image;

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

@end
