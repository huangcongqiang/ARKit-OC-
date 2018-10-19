//
//  ViewController.m
//  AR-平面检测
//
//  Created by Admin on 2018/10/16.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import "ViewController.h"
#import <ARKit/ARKit.h>
#import <ARKit/ARSession.h>
#import <SceneKit/SceneKit.h>
#import "NodePlane.h"

@interface ViewController ()<ARSCNViewDelegate>
@property(nonatomic,strong)ARSCNView *arScnView;
@property(nonatomic,strong)ARSession *arSession;
@property(nonatomic,strong)ARConfiguration *arConfiguration;
@property(nonatomic,strong)SCNNode *scnNode;
@property(nonatomic,strong)NSMutableDictionary *dataDict;
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.view addSubview:self.arScnView];
    [self.arSession runWithConfiguration:self.arConfiguration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSMutableDictionary *)dataDict{
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}

-(ARConfiguration *)arConfiguration{
    if (!_arConfiguration) {
        ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc]init];
        configuration.planeDetection = ARPlaneDetectionHorizontal;
        _arConfiguration = configuration;
        [_arConfiguration setLightEstimationEnabled:YES];
    }
    return _arConfiguration;
}

-(ARSession *)arSession{
    if (!_arSession) {
        _arSession = [[ARSession alloc]init];
    }
    return _arSession;
}

-(ARSCNView *)arScnView{
    if (!_arScnView) {
        _arScnView = [[ARSCNView alloc]initWithFrame:self.view.bounds];
        _arScnView.session = self.arSession;
        _arScnView.delegate = self;
        _arScnView.autoenablesDefaultLighting = YES;
        //设置debug选项，
        //ARSCNDebugOptionShowFeaturePoints     显示捕捉到的特征点（小黄点）
        //ARSCNDebugOptionShowWorldOrigin       显示世界坐标原点（相机位置，3D坐标系）

        _arScnView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
        SCNScene *scene = [SCNScene new];
        _arScnView.scene = scene;
    }
    return _arScnView;
}

-(void)setupSession{
    
}


// MARK: - ARSCNViewDelegate

/**
 实现此方法来为给定 anchor 提供自定义 node。
 
 @discussion 此 node 会被自动添加到 scene graph 中。
 如果没有实现此方法，则会自动创建 node。
 如果返回 nil，则会忽略此 anchor。
 @param renderer 将会用于渲染 scene 的 renderer。
 @param anchor 新添加的 anchor。
 @return 将会映射到 anchor 的 node 或 nil。
 */
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        return nil
//    }

/**
 将新 node 映射到给定 anchor 时调用。
 
 @param renderer 将会用于渲染 scene 的 renderer。
 @param node 映射到 anchor 的 node。
 @param anchor 新添加的 anchor。
 */
-(void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    if (![anchor isKindOfClass:[ARPlaneAnchor class]]) {
        return;
    }
    NodePlane *plane = [[NodePlane alloc]initWithAnchor:(ARPlaneAnchor *)anchor];
    [self.dataDict setObject:plane forKey:anchor.identifier];
    [node addChildNode:plane];
}


/**
 使用给定 anchor 的数据更新 node 时调用。
 
 @param renderer 将会用于渲染 scene 的 renderer。
 @param node 更新后的 node。
 @param anchor 更新后的 anchor。
 */
-(void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    if (nil == self.dataDict[anchor.identifier]) {
        return;
    }
    
    NodePlane *plane = self.dataDict[anchor.identifier];
    
    // anchor 更新后也需要更新 3D 几何体。例如平面检测的高度和宽度可能会改变，所以需要更新 SceneKit 几何体以匹配
    [plane updateWithAnchor:(ARPlaneAnchor *)anchor];
}

/**
 从 scene graph 中移除与给定 anchor 映射的 node 时调用。
 
 @param renderer 将会用于渲染 scene 的 renderer。
 @param node 被移除的 node。
 @param anchor 被移除的 anchor。
 */
-(void)renderer:(id<SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    [self.dataDict removeObjectForKey:anchor.identifier];
}
/**
 将要用给定 anchor 的数据来更新时 node 调用。
 
 @param renderer 将会用于渲染 scene 的 renderer。
 @param node 即将更新的 node。
 @param anchor 被更新的 anchor。
 */
-(void)renderer:(id<SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    
}

-(void)session:(ARSession *)session didFailWithError:(NSError *)error
{
    
}

-(void)sessionWasInterrupted:(ARSession *)session
{

}

-(void)sessionInterruptionEnded:(ARSession *)session
{
    
}
@end
