//
//  main.swift
//  StringToHex
//
//  Created by Ning Li on 2019/4/29.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import Foundation

let string = "9D72EC"

let data = string.data(using: .utf8)!
let bytes = [UInt8](data)

/*
 NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
 Byte *bytes = (Byte *)[myD bytes];
 //下面是Byte 转换为16进制。
 NSString *hexStr=@"";
 for(int i=0;i<[myD length];i++)
 {
 NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
 if([newHexStr length]==1)
 hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
 else
 hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
 }
 */

