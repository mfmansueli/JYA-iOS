//
//  Rx+Util.swift
//  Recrutamento JYA iOS
//
//  Created by Mateus Ferneda Mansueli on 18/05/19.
//  Copyright © 2019 Mateus Ferneda Mansueli. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum RxOptionalError: Error, CustomStringConvertible {
    case foundNilWhileUnwrappingOptional(Any.Type)
    case emptyOccupiable(Any.Type)
    
    public var description: String {
        switch self {
        case .foundNilWhileUnwrappingOptional(let type):
            return "Found nil while trying to unwrap type <\(String(describing: type))>"
        case .emptyOccupiable(let type):
            return "Empty occupiable of type <\(String(describing: type))>"
        }
    }
}

extension ObservableType {
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
    
}
