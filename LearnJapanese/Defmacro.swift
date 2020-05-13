//
//  Defmacro.swift
//  LearnJapanese
//  宏定义
//  Created by 唐星宇 on 2020/5/13.
//  Copyright © 2020 唐星宇. All rights reserved.
//
import UIKit

@_exported import SnapKit

///主题色
let mainColor = 0xbbbbbb

///屏幕宽高
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

/// 判断是否为刘海屏
var isiPhoneX: Bool {
    if #available(iOS 11, *) {
        if let w = UIApplication.shared.delegate?.window,
          let window = w, window.safeAreaInsets.left > 0 || window.safeAreaInsets.bottom > 0 {
            return true
        }
    }
    return false
}

/// 状态栏高度 44.0 20.0
let StatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
/// 系统导航条高度
let NavBarHeight: CGFloat = 44.0
/// 导航栏高度(导航条和状态栏总高度)
let NavPlusStatusH: CGFloat = (StatusBarHeight + NavBarHeight)
/// iPhone X底部多余的高度
let IPHONEX_BH:CGFloat = isiPhoneX ? 34.0:0.0

/// 基于iPhone6的屏宽比例
let Scale_iPhone6: CGFloat = SCREEN_WIDTH/375.0


/// 尺寸适配 以iPhone6为基准
/// - Parameter cgfNum: 传入iPhone6设计下的宽高
/// - Returns: 返回适配后的宽高
func WidthScale(_ cgfNum: CGFloat) -> CGFloat {
    return CGFloat(cgfNum * Scale_iPhone6)
}


/// 获取label自适应文字后的宽度
/// - Parameter label: 传入UILabel
/// - Returns: 返回Label宽度
func getWidthOfLabel(withLabel label: UILabel) -> CGFloat {
    if let font = label.font{
        return NSString(string: label.text!).size(withAttributes: [NSAttributedString.Key.font: font]).width + WidthScale(1.0)
    }
    Dprint("=====未设置UIFont=====")
    return 0
}

/// 根据十六进制数生成颜色 HEXCOLOR(h:0xe6e6e6,alpha:0.8)
/// - Parameters:
///   - h: 十六进制整数
///   - alpha: 透明度 0~1
/// - Returns: 返回UIColor
func HEXCOLOR(h:Int,alpha:CGFloat) ->UIColor {
    return RGBCOLOR(r: CGFloat(((h)>>16) & 0xFF), g: CGFloat(((h)>>8) & 0xFF), b: CGFloat((h) & 0xFF),alpha: alpha)
}

///根据R,G,B生成颜色
func RGBCOLOR(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
}

/// 获取一段两种颜色的文本
/// 颜色部分使用十六进制
/// - Parameters:
///     - str: 文本字符串
///     - sColor: 其他部分的颜色
///     - dColor: 选中部分的颜色
///     - start: 选中部分开始的位置
///     - length: 选中部分的长度
func GET_ATTRIBUTE_STR(WithString str : String, sColor : Int, dColor : Int, start: Int, length : Int ) -> NSMutableAttributedString {
    let atrriStr = NSMutableAttributedString.init(string: str)
    atrriStr.addAttribute(NSAttributedString.Key.foregroundColor, value: HEXCOLOR(h: sColor, alpha: 1.0), range: NSRange.init(location:0, length: start))
    atrriStr.addAttribute(NSAttributedString.Key.foregroundColor, value: HEXCOLOR(h: dColor, alpha: 1.0), range: NSRange.init(location:start, length: length))
    atrriStr.addAttribute(NSAttributedString.Key.foregroundColor, value: HEXCOLOR(h: sColor, alpha: 1.0), range: NSRange.init(location:start + length, length: str.count - start - length))
    return atrriStr
}

/// 系统版本
let IOS_VERSION = UIDevice.current.systemVersion._bridgeToObjectiveC().doubleValue
/// 是否是真机
func ISIPHONE() -> Bool {
    #if TARGET_OS_IPHONE
        return true
    #endif
    #if TARGET_IPHONE_SIMULATOR
        return false
    #endif
    return false
}

// MARK: - DEBUG模式下打印(Swift)
func Dprint(filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
        let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        print("class:" + fileName + "  line:" + "\(rowCount)" + "\n")
    #endif
}
func Dprint<T>(_ message: T, filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
        let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        print("class:" + fileName + "  line:" + "\(rowCount)" + "  \(message)" + "\n")
    #endif
}


