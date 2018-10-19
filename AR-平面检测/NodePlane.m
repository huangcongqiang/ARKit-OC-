//
//  NodePlane.m
//  AR-平面检测
//
//  Created by Admin on 2018/10/16.
//  Copyright © 2018年 Admin. All rights reserved.
//

#import "NodePlane.h"

@implementation NodePlane
-(instancetype)initWithAnchor:(ARPlaneAnchor *)anchor
{
    self = [super init];
    if (self) {
        self.anchor = anchor;
        self.planeGeometry = [SCNPlane planeWithWidth:anchor.extent.x height:anchor.extent.z];
        // 相比把网格视觉化为灰色平面，我更喜欢用科幻风的颜色来渲染
        SCNMaterial *material = [SCNMaterial new];
        UIImage *img = [UIImage imageNamed:@"tron_grid"];
        material.diffuse.contents = img;
        material.lightingModelName = SCNLightingModelPhysicallyBased;
        
        self.planeGeometry.materials = @[material];
        
        SCNNode *planeNode = [SCNNode nodeWithGeometry:self.planeGeometry];
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        
        // SceneKit 里的平面默认是垂直的，所以需要旋转90度来匹配 ARKit 中的平面
        planeNode.transform = SCNMatrix4MakeRotation(-M_PI_2, 1.0, 0.0, 0.0);
        
        [self setTextureScale];
        [self addChildNode:planeNode];
        
    }
    return self;
}

-(void)updateWithAnchor:(ARPlaneAnchor *)anchor{
    // 随着用户移动，平面 plane 的 范围 extend 和 位置 location 可能会更新。
    // 需要更新 3D 几何体来匹配 plane 的新参数。
    self.planeGeometry.width = anchor.extent.x;
    self.planeGeometry.height = anchor.extent.z;
    
    self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
    [self setTextureScale];
}

-(void)setTextureScale{
    float width = self.planeGeometry.width;
    float height = self.planeGeometry.height;
    
    // 平面的宽度/高度 width/height 更新时，我希望 tron grid material 覆盖整个平面，不断重复纹理。
    // 但如果网格小于 1 个单位，我不希望纹理挤在一起，所以这种情况下通过缩放更新纹理坐标并裁剪纹理
    
    SCNMaterial *material = self.planeGeometry.materials.firstObject;
    material.diffuse.contentsTransform = SCNMatrix4MakeScale(width, height, 1);
    material.diffuse.wrapS = SCNWrapModeRepeat;
    material.diffuse.wrapT = SCNWrapModeRepeat;
}

@end
