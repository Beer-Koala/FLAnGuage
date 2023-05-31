//
//  UserDefaultStorage.swift
//  FLAnGuage
//
//  Created by Beer Koala on 31.05.2023.
//

import Foundation

public enum UserDefaultStorage {

    @UserDefaultWrapper(key: "inputSourceTitles", defaultValue: [:])
    public static var inputSourceTitles: [String: String]

}

@propertyWrapper
public class UserDefaultWrapper<Value> {

    // MARK: -
    // MARK: Variables

    public var wrappedValue: Value {
        get {
            self.defaults.synchronize()
            return self.get(self.defaults)
        }

        set {
            self.set((newValue, self.defaults))
            self.defaults.synchronize()
        }
    }

    private let key: String
    private let defaultValue: Value
    private let defaults: UserDefaults

    private lazy var set: VoidFunc<(Value, UserDefaults)> = {
        let value = $0.0 as Any

        if case Optional<Any>.none = value {
            $0.1.removeObject(forKey: self.key)
        } else {
            $0.1.set($0.0, forKey: self.key)
        }
    }

    private lazy var get: Func<UserDefaults, Value> = {
       ($0.object(forKey: self.key) as? Value) ?? self.defaultValue
    }

    // MARK: -
    // MARK: Initializations

    init(
        key: String,
        defaultValue: Value,
        defaults: UserDefaults = .standard,
        set: VoidFunc<(Value, UserDefaults)>? = nil,
        get: Func<UserDefaults, Value>? = nil
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.defaults = defaults

        set.map { self.set = $0 }
        get.map { self.get = $0 }
    }
}
