//
//  StoredCodable.swift
//  SLPToolbox
//
//  Created by Ryan Gilbert on 1/1/23.
//

import SwiftUI
import Combine

@propertyWrapper class StoredCodable<Value: Codable>: DynamicProperty {
    private var value: Value
    
    var wrappedValue: Value {
        get {
            value
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                storage.removeObject(forKey: key)
                return
            } else if let valueData = try? encoder.encode(newValue) {
                storage.set(valueData, forKey: key)
            }
            self.value = newValue
        }
    }
    
    var projectedValue: Binding<Value> {
        Binding {
            self.wrappedValue
        } set: {
            self.wrappedValue = $0
        }
    }
    
    let key: String
    var storage: UserDefaults
    var encoder: JSONEncoder
    var decoder: JSONDecoder
    
    static subscript<T: ObservableObject>(
        _enclosingInstance instance: T,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<T, StoredCodable>
      ) -> Value {
          get {
              instance[keyPath: storageKeyPath].wrappedValue
          }
          set {
              if let publisher = instance.objectWillChange as? ObservableObjectPublisher {
                  publisher.send()
              }
              
              instance[keyPath: storageKeyPath].wrappedValue = newValue
          }
    }
    
    init(key: String, defaultValue: Value, storage: UserDefaults = .standard, encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) {
        self.key = key
        self.storage = storage
        self.encoder = encoder
        self.decoder = decoder
        
        if let storedData = storage.data(forKey: key),
              let value = try? decoder.decode(Value.self, from: storedData) {
            self.value = value
        } else {
            self.value = defaultValue
        }
    }
}

extension StoredCodable where Value: ExpressibleByNilLiteral {
    convenience init(key: String, storage: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, storage: storage)
    }
}

protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool {
        self == nil
    }
}
