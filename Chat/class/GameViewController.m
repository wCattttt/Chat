//
//  GameViewController.m
//  sprite_oc
//
//  Created by 魏唯隆 on 16/8/5.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController
{

//    __weak IBOutlet SKView *skView;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Load the SKScene from 'GameScene.sks'
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = [[SKView alloc] initWithFrame:self.view.frame];
    
    // Present the scene
    [skView presentScene:scene];
    skView.showsFPS = YES;
    
    skView.showsNodeCount = YES;
    
    [self.view addSubview:skView];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
