//
//  guessPosture.swift
//  Croak
//
//  Created by Giwoo Kim on 5/20/24.
//

import Foundation
//
//  guessPosture.swift
//  Croak
//
//  Created by Giwoo Kim on 5/18/24.
//

import Foundation


func guessPostureFromAngle(rollAngle: Double, pitchAngle: Double, yawAngle: Double = 0  , z: Double) -> PostureToKor {
    
   let z  = z
   var posture : PostureToKor

   // 대칭이 아니어도 괜찮을까?
    
    if (rollAngle < -80 && rollAngle > -110 && pitchAngle < 10 && pitchAngle > -10) {
        posture = PostureToKor.LYING_LEFT
    } else if (rollAngle > 80 && rollAngle < 140 && pitchAngle < 10 && pitchAngle > -10) {
        posture = PostureToKor.LYING_RIGHT
    } else if (rollAngle < 4 && rollAngle > -4 && pitchAngle < 60 && pitchAngle > 30) {
        posture = PostureToKor.SITTING
    } else {
        posture = PostureToKor.NOT_AVAILABLE
    }
    
    // 휴대폰이 뒤집혀있는지 여부를 판단하는 조건
    // 이건 필요가있을까?
    let isPhoneUpsideDown = (z > 0.9) // TODO 임의의 기준값으로 설정, 수정 필요
    return posture
    
}

func guesspostureFromGravity( x: Double, y: Double, z : Double) -> PostureToKor{
    var posture : PostureToKor
    let threshold = 0.55
    // 중력 벡터의 성분 값이 이 임계값을 넘으면 해당 방향으로 인식합니다.
    
    let xBound = 0.5
    let yBound = 0.3
    let zBoundLying = 0.70
    let zBoundFaceDown = -0.90
    
    
    
    if z > zBoundLying  {
        posture = PostureToKor.LYING
    }
    
    else if  z < zBoundFaceDown{
        posture = PostureToKor.LYING_FACE_DOWN
    }
    else{
        if x < -xBound {
            
            posture = PostureToKor.LYING_LEFT
            
        } else if x > xBound {
            
            posture = PostureToKor.LYING_RIGHT
        } else {
            posture = PostureToKor.SITTING
        }
    }
    
    return posture
}



