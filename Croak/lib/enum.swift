//
//  enum.swift
//  Croak
//
//  Created by jeong hyein on 5/11/24.
//

enum Posture: String, CaseIterable {
    case SITTING = "SIT"
    case LYING = "LYING"
    case LYING_LEFT = "LYING_LEFT"
    case LYING_RIGHT = "LYING_RIGHT"
    case LYING_FACE_DOWN = "LYING_FACE_DOWN"
    case NOT_AVAILABLE = "NOT_AVAILABLE"
    case NIL = "NIL"
}

enum PostureToKor: String, CaseIterable {
    case SITTING = "앉은 자세"
    case LYING = "천장보고 누운 자세"
    case LYING_LEFT = "왼쪽으로 누운 자세"
    case LYING_RIGHT = "오른쪽으로 누운 자세"
    case LYING_FACE_DOWN = "엎드린 포복 자세"
    case NOT_AVAILABLE = "측정 불가 자세"
    case NIL = ""
}

//enum MeasurementUnitByMinute: Int, CaseIterable {
//    case FIFTEEN = 15
//    case TEN = 10
//    case FIVE = 5
//    case ONE = 1
//}
//enum MeasurementUnitBySecond: Double, CaseIterable {
//    case FIFTEEN = 900
//    case TEN = 600
//    case FIVE = 300
//    case ONE = 60
//}
//
//enum MeasurementUnit: Double, CaseIterable {
//    case MINUTE = 1
//    case SECOND = 60
//}

enum tapInfo : String, CaseIterable {
    case SUMMARY = "요약"
    case DATA = "자세분석"
    case HABBIT = "자세습관"
    case MONITOR = "과거자세"

    
}
