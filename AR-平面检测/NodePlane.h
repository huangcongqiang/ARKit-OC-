//
//  NodePlane.h
//  AR-平面检测
//
//  Created by Admin on 2018/10/16.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <UIKit/UIKit.h>
#import <ARKit/ARKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodePlane : SCNNode
@property(nonatomic,strong)ARPlaneAnchor *anchor;
@property(nonatomic,strong)SCNPlane *planeGeometry;

-(instancetype)initWithAnchor:(ARPlaneAnchor *)anchor;
-(void)updateWithAnchor:(ARPlaneAnchor *)anchor;
@end

NS_ASSUME_NONNULL_END
