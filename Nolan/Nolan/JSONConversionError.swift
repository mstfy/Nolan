//
//  JSONConversionError.swift
//  ProjectNolan
//
//  Created by Mustafa Yusuf on 7.07.2015.
//  Copyright © 2015 Mustafa Yusuf. All rights reserved.
//

public enum JSONConversionError: ErrorType {
    case TypeIsNotConvertibleToJSON(typeName: String)
}