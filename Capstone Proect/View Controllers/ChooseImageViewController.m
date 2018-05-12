//
//  ChooseImageViewController.m
//  Capstone Proect
//
//  Created by Lilit Avetisyan on 5/9/18.
//  Copyright © 2018 Lil. All rights reserved.
//

#import "ChooseImageViewController.h"
#import "UploadImageViewController.h"


@interface ChooseImageViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imgSepagir;
@property (strong, nonatomic) IBOutlet UIImageView *imgSepagir1;
@property (strong, nonatomic) IBOutlet UIImageView *imgSepagir2;
@property (strong, nonatomic) IBOutlet UIImageView *imgSepagir3;

@end

@implementation ChooseImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imgSepagir.userInteractionEnabled = YES;
    _imgSepagir1.userInteractionEnabled = YES;
    _imgSepagir2.userInteractionEnabled = YES;
    _imgSepagir3.userInteractionEnabled = YES;

    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedFirst)];
    [_imgSepagir addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScnd)];
    [_imgSepagir1 addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTrd)];
    [_imgSepagir2 addGestureRecognizer:tap3];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedFrth)];
    [_imgSepagir3 addGestureRecognizer:tap4];

    

    // Do any additional setup after loading the view.
}

#pragma mark TapGuestures

-(void)tappedFirst{
    UploadImageViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadImageViewController"];
    vc.image = _imgSepagir.image;
    [self presentViewController:vc animated:NO completion:nil];
}

-(void)tappedScnd{
    UploadImageViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadImageViewController"];
    vc.image = _imgSepagir1.image;
    [self presentViewController:vc animated:NO completion:nil];
}

-(void)tappedTrd{
    UploadImageViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadImageViewController"];
    vc.image = _imgSepagir2.image;
    [self presentViewController:vc animated:NO completion:nil];
}

-(void)tappedFrth{
    UploadImageViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UploadImageViewController"];
    vc.image = _imgSepagir3.image;
    [self presentViewController:vc animated:NO completion:nil];
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
