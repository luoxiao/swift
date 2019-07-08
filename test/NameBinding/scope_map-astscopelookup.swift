// REQUIRES: enable-astscope-lookup
// Note: test of the scope map. All of these tests are line- and
// column-sensitive, so any additions should go at the end.

struct S0 {
  class InnerC0 { }
}

extension S0 {
}

class C0 {
}

enum E0 {
  case C0
  case C1(Int, Int)
}

struct GenericS0<T, U> {
}

func genericFunc0<T, U>(t: T, u: U, i: Int = 10) {
}

class ContainsGenerics0 {
  init<T, U>(t: T, u: U) {
  }

  deinit {
  }
}

typealias GenericAlias0<T> = [T]

#if arch(unknown)
struct UnknownArchStruct { }
#else
struct OtherArchStruct { }
#endif

func functionBodies1(a: Int, b: Int?) {
  let (x1, x2) = (a, b),
      (y1, y2) = (b, a)
  let (z1, z2) = (a, a)
  do {
    let a1 = a
    let a2 = a
    do {
      let b1 = b
      let b2 = b
    }
  }
  do {
    let b1 = b
    let b2 = b
  }
  func f(_ i: Int) -> Int { return i }
  let f2 = f(_:)
  struct S7 { }
  typealias S7Alias = S7
  
  if let b1 = b, let b2 = b {
    let c1 = b
  } else {
    let c2 = b
  }

  guard let b1 = b, { $0 > 5 }(b1), let b2 = b else {
    let c = 5
    return
  }

  while let b3 = b, let b4 = b {
    let c = 5
  }

  repeat { } while true;

  for (x, y) in [(1, "hello"), (2, "world")] where x % 2 == 0 {

  }

  do {
    try throwing()
  } catch let mine as MyError where mine.value == 17 {
  } catch {
  }

  switch MyEnum.second(1) {
  case .second(let x) where x == 17:
    break;

  case .first:
    break;

  default:
    break;
  }
  for (var i = 0; i != 10; i += 1) { }
}

func throwing() throws { }

struct MyError : Error {
  var value: Int
}

enum MyEnum {
  case first
  case second(Int)
  case third
}

struct StructContainsAbstractStorageDecls {
  subscript (i: Int, j: Int) -> Int {
    set {
    }
    get {
      return i + j
    }
  }

  var computed: Int {
    get {
      return 0
    }
    set {
    }
  }
}

class ClassWithComputedProperties {
  var willSetProperty: Int = 0 {
    willSet { }
  } 

  var didSetProperty: Int = 0 {
    didSet { }
  } 
}

func funcWithComputedProperties(i: Int) {
  var computed: Int {
    set {
    }
    get {
      return 0
    }
  }, var (stored1, stored2) = (1, 2),
  var alsoComputed: Int {
    return 17
  }
    
  do { }
}

func closures() {
  { x, y in 
    return { $0 + $1 }(x, y)
  }(1, 2) + 
  { a, b in a * b }(3, 4)
}

{ closures() }()

func defaultArguments(i: Int = 1,
                      j: Int = { $0 + $1 }(1, 2)) {

  func localWithDefaults(i: Int = 1,
                         j: Int = { $0 + $1 }(1, 2)) {
  }

  let a = i + j
  { $0 }(a)
}

struct PatternInitializers {
  var (a, b) = (1, 2),
      (c, d) = (1.5, 2.5)
}

protocol ProtoWithSubscript {
  subscript(native: Int) -> Int { get set }
}

func localPatternsWithSharedType() {
  let i, j, k: Int
}

class LazyProperties {
  var value: Int = 17

  lazy var prop: Int = self.value
}

// RUN: not %target-swift-frontend -dump-scope-maps expanded %s 2> %t.expanded
// RUN: %FileCheck -check-prefix CHECK-EXPANDED %s < %t.expanded


// CHECK-EXPANDED:      ***Complete scope map***
// CHECK-EXPANDED-NEXT: ASTSourceFileScope {{.*}}, (uncached) [1:1 - 52{{[0-9]}}:1] 'SOURCE_DIR/test/NameBinding/scope_map-astscopelookup.swift'
// CHECK-EXPANDEC-NEXT: |-NominalTypeDeclScope {{.*}}, [5:1 - 7:1] 'S0'
// CHECK-EXPANDEC-NEXT:   `-NominalTypeBodyScope {{.*}}, [5:11 - 7:1] 'S0'
// CHECK-EXPANDEC-NEXT:     `-NominalTypeDeclScope {{.*}}, [6:3 - 6:19] 'InnerC0'
// CHECK-EXPANDEC-NEXT:       `-NominalTypeBodyScope {{.*}}, [6:17 - 6:19] 'InnerC0'
// CHECK-EXPANDEC-NEXT: |-ExtensionDeclScope {{.*}}, [9:1 - 10:1] 'S0'
// CHECK-EXPANDEC-NEXT:   `-ExtensionBodyScope {{.*}}, [9:14 - 10:1] 'S0'
// CHECK-EXPANDEC-NEXT: |-NominalTypeDeclScope {{.*}}, [12:1 - 13:1] 'C0'
// CHECK-EXPANDEC-NEXT:   `-NominalTypeBodyScope {{.*}}, [12:10 - 13:1] 'C0'
// CHECK-EXPANDEC-NEXT: |-NominalTypeDeclScope {{.*}}, [15:1 - 18:1] 'E0'
// CHECK-EXPANDEC-NEXT:   `-NominalTypeBodyScope {{.*}}, [15:9 - 18:1] 'E0'
// CHECK-EXPANDEC-NEXT: |-NominalTypeDeclScope {{.*}}, [20:1 - 21:1] 'GenericS0'
// CHECK-EXPANDEC-NEXT:   `-GenericParamScope {{.*}}, [20:18 - 21:1] param 0 'T'
// CHECK-EXPANDEC-NEXT:     `-GenericParamScope {{.*}}, [20:21 - 21:1] param 1 'U'
// CHECK-EXPANDEC-NEXT:       `-NominalTypeBodyScope {{.*}}, [20:24 - 21:1] 'GenericS0'
// CHECK-EXPANDEC-NEXT: |-AbstractFunctionDeclScope {{.*}}, [23:1 - 24:1] 'genericFunc0(t:u:i:)'
// CHECK-EXPANDEC-NEXT:   `-GenericParamScope {{.*}}, [23:19 - 24:1] param 0 'T'
// CHECK-EXPANDEC-NEXT:     `-GenericParamScope {{.*}}, [23:22 - 24:1] param 1 'U'
// CHECK-EXPANDEC-NEXT:       `-AbstractFunctionParamsScope {{.*}}, [23:24 - 24:1]
// CHECK-EXPANDEC-NEXT:         |-DefaultArgumentInitializerScope {{.*}}, [23:46 - 23:46]
// CHECK-EXPANDEC-NEXT:         `-PureFunctionBodyScope {{.*}}, [23:50 - 24:1]
// CHECK-EXPANDEC-NEXT:           `-BraceStmtScope {{.*}}, [23:50 - 24:1]
// CHECK-EXPANDEC-NEXT: |-NominalTypeDeclScope {{.*}}, (uncached) [26:1 - 32:1] 'ContainsGenerics0'
// CHECK-EXPANDEC-NEXT:   `-NominalTypeBodyScope {{.*}}, [26:25 - 32:1] 'ContainsGenerics0'
// CHECK-EXPANDEC-NEXT:     |-AbstractFunctionDeclScope {{.*}}, [27:3 - 28:3] 'init(t:u:)'
// CHECK-EXPANDEC-NEXT:       `-GenericParamScope {{.*}}, [27:8 - 28:3] param 0 'T'
// CHECK-EXPANDEC-NEXT:         `-GenericParamScope {{.*}}, [27:11 - 28:3] param 1 'U'
// CHECK-EXPANDEC-NEXT:           `-AbstractFunctionParamsScope {{.*}}, [27:13 - 28:3]
// CHECK-EXPANDEC-NEXT:             `-MethodBodyScope {{.*}}, [27:26 - 28:3]
// CHECK-EXPANDEC-NEXT:               `-BraceStmtScope {{.*}}, [27:26 - 28:3]
// CHECK-EXPANDEC-NEXT:     `-AbstractFunctionDeclScope {{.*}}, [30:3 - 31:3] 'deinit'
// CHECK-EXPANDEC-NEXT:       `-AbstractFunctionParamsScope {{.*}}, [30:3 - 31:3]
// CHECK-EXPANDEC-NEXT:         `-MethodBodyScope {{.*}}, [30:10 - 31:3]
// CHECK-EXPANDEC-NEXT:           `-BraceStmtScope {{.*}}, [30:10 - 31:3]
// CHECK-EXPANDEC-NEXT: |-TypeAliasDeclScope {{.*}}, (uncached) [34:1 - 34:32] <no extended nominal?!>
// CHECK-EXPANDEC-NEXT:   `-GenericParamScope {{.*}}, [34:25 - 34:32] param 0 'T'
// CHECK-EXPANDEC-NEXT: |-NominalTypeDeclScope {{.*}}, [37:1 - 37:28] 'UnknownArchStruct'
// CHECK-EXPANDEC-NEXT:   `-NominalTypeBodyScope {{.*}}, [37:26 - 37:28] 'UnknownArchStruct'
// CHECK-EXPANDEC-NEXT: |-NominalTypeDeclScope {{.*}}, [39:1 - 39:26] 'OtherArchStruct'
// CHECK-EXPANDEC-NEXT:   `-NominalTypeBodyScope {{.*}}, [39:24 - 39:26] 'OtherArchStruct'
// CHECK-EXPANDEC-NEXT: `-LookupParentDiversionScope, [40:1 - 195:1]
// CHECK-EXPANDEC-NEXT:   |-AbstractFunctionDeclScope {{.*}}, [42:1 - 101:1] 'functionBodies1(a:b:)'
// CHECK-EXPANDEC-NEXT:     `-AbstractFunctionParamsScope {{.*}}, [42:21 - 101:1]
// CHECK-EXPANDEC-NEXT:       `-PureFunctionBodyScope {{.*}}, [42:39 - 101:1]
// CHECK-EXPANDEC-NEXT:         `-BraceStmtScope {{.*}}, [42:39 - 101:1]
// CHECK-EXPANDEC-NEXT:           `-PatternEntryDeclScope {{.*}}, [43:7 - 100:38] entry 0 'x1' 'x2'
// CHECK-EXPANDEC-NEXT:             |-PatternEntryInitializerScope {{.*}}, [43:18 - 43:23] entry 0 'x1' 'x2'
// CHECK-EXPANDEC-NEXT:             `-PatternEntryUseScope {{.*}}, [43:23 - 100:38] entry 0 'x1' 'x2'
// CHECK-EXPANDEC-NEXT:               `-PatternEntryDeclScope {{.*}}, [44:7 - 100:38] entry 1 'y1' 'y2'
// CHECK-EXPANDEC-NEXT:                 |-PatternEntryInitializerScope {{.*}}, [44:18 - 44:23] entry 1 'y1' 'y2'
// CHECK-EXPANDEC-NEXT:                 `-PatternEntryUseScope {{.*}}, [44:23 - 100:38] entry 1 'y1' 'y2'
// CHECK-EXPANDEC-NEXT:                   `-PatternEntryDeclScope {{.*}}, [45:7 - 100:38] entry 0 'z1' 'z2'
// CHECK-EXPANDEC-NEXT:                     |-PatternEntryInitializerScope {{.*}}, [45:18 - 45:23] entry 0 'z1' 'z2'
// CHECK-EXPANDEC-NEXT:                     `-PatternEntryUseScope {{.*}}, [45:23 - 100:38] entry 0 'z1' 'z2'
// CHECK-EXPANDEC-NEXT:                       |-BraceStmtScope {{.*}}, [46:6 - 53:3]
// CHECK-EXPANDEC-NEXT:                         `-PatternEntryDeclScope {{.*}}, [47:9 - 52:5] entry 0 'a1'
// CHECK-EXPANDEC-NEXT:                           |-PatternEntryInitializerScope {{.*}}, [47:14 - 47:14] entry 0 'a1'
// CHECK-EXPANDEC-NEXT:                           `-PatternEntryUseScope {{.*}}, [47:14 - 52:5] entry 0 'a1'
// CHECK-EXPANDEC-NEXT:                             `-PatternEntryDeclScope {{.*}}, [48:9 - 52:5] entry 0 'a2'
// CHECK-EXPANDEC-NEXT:                               |-PatternEntryInitializerScope {{.*}}, [48:14 - 48:14] entry 0 'a2'
// CHECK-EXPANDEC-NEXT:                               `-PatternEntryUseScope {{.*}}, [48:14 - 52:5] entry 0 'a2'
// CHECK-EXPANDEC-NEXT:                                 `-BraceStmtScope {{.*}}, [49:8 - 52:5]
// CHECK-EXPANDEC-NEXT:                                   `-PatternEntryDeclScope {{.*}}, [50:11 - 51:16] entry 0 'b1'
// CHECK-EXPANDEC-NEXT:                                     |-PatternEntryInitializerScope {{.*}}, [50:16 - 50:16] entry 0 'b1'
// CHECK-EXPANDEC-NEXT:                                     `-PatternEntryUseScope {{.*}}, [50:16 - 51:16] entry 0 'b1'
// CHECK-EXPANDEC-NEXT:                                       `-PatternEntryDeclScope {{.*}}, [51:11 - 51:16] entry 0 'b2'
// CHECK-EXPANDEC-NEXT:                                         |-PatternEntryInitializerScope {{.*}}, [51:16 - 51:16] entry 0 'b2'
// CHECK-EXPANDEC-NEXT:                                         `-PatternEntryUseScope {{.*}}, [51:16 - 51:16] entry 0 'b2'
// CHECK-EXPANDEC-NEXT:                       |-BraceStmtScope {{.*}}, [54:6 - 57:3]
// CHECK-EXPANDEC-NEXT:                         `-PatternEntryDeclScope {{.*}}, [55:9 - 56:14] entry 0 'b1'
// CHECK-EXPANDEC-NEXT:                           |-PatternEntryInitializerScope {{.*}}, [55:14 - 55:14] entry 0 'b1'
// CHECK-EXPANDEC-NEXT:                           `-PatternEntryUseScope {{.*}}, [55:14 - 56:14] entry 0 'b1'
// CHECK-EXPANDEC-NEXT:                             `-PatternEntryDeclScope {{.*}}, [56:9 - 56:14] entry 0 'b2'
// CHECK-EXPANDEC-NEXT:                               |-PatternEntryInitializerScope {{.*}}, [56:14 - 56:14] entry 0 'b2'
// CHECK-EXPANDEC-NEXT:                               `-PatternEntryUseScope {{.*}}, [56:14 - 56:14] entry 0 'b2'
// CHECK-EXPANDEC-NEXT:                       |-AbstractFunctionDeclScope {{.*}}, [58:3 - 58:38] 'f(_:)'
// CHECK-EXPANDEC-NEXT:                         `-AbstractFunctionParamsScope {{.*}}, [58:9 - 58:38]
// CHECK-EXPANDEC-NEXT:                           `-PureFunctionBodyScope {{.*}}, [58:27 - 58:38]
// CHECK-EXPANDEC-NEXT:                             `-BraceStmtScope {{.*}}, [58:27 - 58:38]
// CHECK-EXPANDEC-NEXT:                       `-PatternEntryDeclScope {{.*}}, [59:7 - 100:38] entry 0 'f2'
// CHECK-EXPANDEC-NEXT:                         |-PatternEntryInitializerScope {{.*}}, [59:12 - 59:16] entry 0 'f2'
// CHECK-EXPANDEC-NEXT:                         `-PatternEntryUseScope {{.*}}, [59:16 - 100:38] entry 0 'f2'
// CHECK-EXPANDEC-NEXT:                           |-NominalTypeDeclScope {{.*}}, [60:3 - 60:15] 'S7'
// CHECK-EXPANDEC-NEXT:                             `-NominalTypeBodyScope {{.*}}, [60:13 - 60:15] 'S7'
// CHECK-EXPANDEC-NEXT:                           |-TypeAliasDeclScope {{.*}}, [61:3 - 61:23] <no extended nominal?!>
// CHECK-EXPANDEC-NEXT:                           |-IfStmtScope {{.*}}, [63:3 - 67:3]
// CHECK-EXPANDEC-NEXT:                             |-ConditionalClauseScope, [63:6 - 65:3] index 0
// CHECK-EXPANDEC-NEXT:                               `-ConditionalClausePatternUseScope, [63:18 - 65:3] let b1
// CHECK-EXPANDEC-NEXT:                                 `-ConditionalClauseScope, [63:18 - 65:3] index 1
// CHECK-EXPANDEC-NEXT:                                   `-ConditionalClausePatternUseScope, [63:29 - 65:3] let b2
// CHECK-EXPANDEC-NEXT:                                     `-BraceStmtScope {{.*}}, [63:29 - 65:3]
// CHECK-EXPANDEC-NEXT:                                       `-PatternEntryDeclScope {{.*}}, [64:9 - 64:14] entry 0 'c1'
// CHECK-EXPANDEC-NEXT:                                         |-PatternEntryInitializerScope {{.*}}, [64:14 - 64:14] entry 0 'c1'
// CHECK-EXPANDEC-NEXT:                                         `-PatternEntryUseScope {{.*}}, [64:14 - 64:14] entry 0 'c1'
// CHECK-EXPANDEC-NEXT:                             `-BraceStmtScope {{.*}}, [65:10 - 67:3]
// CHECK-EXPANDEC-NEXT:                               `-PatternEntryDeclScope {{.*}}, [66:9 - 66:14] entry 0 'c2'
// CHECK-EXPANDEC-NEXT:                                 |-PatternEntryInitializerScope {{.*}}, [66:14 - 66:14] entry 0 'c2'
// CHECK-EXPANDEC-NEXT:                                 `-PatternEntryUseScope {{.*}}, [66:14 - 66:14] entry 0 'c2'
// CHECK-EXPANDEC-NEXT:                           `-GuardStmtScope {{.*}}, [69:3 - 100:38]
// CHECK-EXPANDEC-NEXT:                             |-ConditionalClauseScope, [69:9 - 69:53] index 0
// CHECK-EXPANDEC-NEXT:                               `-ConditionalClausePatternUseScope, [69:21 - 69:53] let b1
// CHECK-EXPANDEC-NEXT:                                 `-ConditionalClauseScope, [69:21 - 69:53] index 1
// CHECK-EXPANDEC-NEXT:                                   |-WholeClosureScope {{.*}}, [69:21 - 69:30]
// CHECK-EXPANDEC-NEXT:                                     `-ClosureBodyScope {{.*}}, [69:21 - 69:30]
// CHECK-EXPANDEC-NEXT:                                       `-BraceStmtScope {{.*}}, [69:21 - 69:30]
// CHECK-EXPANDEC-NEXT:                                   `-ConditionalClauseScope, [69:37 - 69:53] index 2
// CHECK-EXPANDEC-NEXT:                                     `-ConditionalClausePatternUseScope, [69:53 - 69:53] let b2
// CHECK-EXPANDEC-NEXT:                             |-BraceStmtScope {{.*}}, [69:53 - 72:3]
// CHECK-EXPANDEC-NEXT:                               `-PatternEntryDeclScope {{.*}}, [70:9 - 70:13] entry 0 'c'
// CHECK-EXPANDEC-NEXT:                                 |-PatternEntryInitializerScope {{.*}}, [70:13 - 70:13] entry 0 'c'
// CHECK-EXPANDEC-NEXT:                                 `-PatternEntryUseScope {{.*}}, [70:13 - 70:13] entry 0 'c'
// CHECK-EXPANDEC-NEXT:                             `-LookupParentDiversionScope, [72:3 - 100:38]
// CHECK-EXPANDEC-NEXT:                               |-WhileStmtScope {{.*}}, [74:3 - 76:3]
// CHECK-EXPANDEC-NEXT:                                 `-ConditionalClauseScope, [74:9 - 76:3] index 0
// CHECK-EXPANDEC-NEXT:                                   `-ConditionalClausePatternUseScope, [74:21 - 76:3] let b3
// CHECK-EXPANDEC-NEXT:                                     `-ConditionalClauseScope, [74:21 - 76:3] index 1
// CHECK-EXPANDEC-NEXT:                                       `-ConditionalClausePatternUseScope, [74:32 - 76:3] let b4
// CHECK-EXPANDEC-NEXT:                                         `-BraceStmtScope {{.*}}, [74:32 - 76:3]
// CHECK-EXPANDEC-NEXT:                                           `-PatternEntryDeclScope {{.*}}, [75:9 - 75:13] entry 0 'c'
// CHECK-EXPANDEC-NEXT:                                             |-PatternEntryInitializerScope {{.*}}, [75:13 - 75:13] entry 0 'c'
// CHECK-EXPANDEC-NEXT:                                             `-PatternEntryUseScope {{.*}}, [75:13 - 75:13] entry 0 'c'
// CHECK-EXPANDEC-NEXT:                               |-RepeatWhileScope {{.*}}, [78:3 - 78:20]
// CHECK-EXPANDEC-NEXT:                                 `-BraceStmtScope {{.*}}, [78:10 - 78:12]
// CHECK-EXPANDEC-NEXT:                               |-ForEachStmtScope {{.*}}, [80:3 - 82:3]
// CHECK-EXPANDEC-NEXT:                                 `-ForEachPatternScope, [80:52 - 82:3]
// CHECK-EXPANDEC-NEXT:                                   `-BraceStmtScope {{.*}}, [80:63 - 82:3]
// CHECK-EXPANDEC-NEXT:                               |-DoCatchStmtScope {{.*}}, [84:3 - 88:3]
// CHECK-EXPANDEC-NEXT:                                 |-BraceStmtScope {{.*}}, [84:6 - 86:3]
// CHECK-EXPANDEC-NEXT:                                 |-CatchStmtScope {{.*}}, [86:31 - 87:3]
// CHECK-EXPANDEC-NEXT:                                   `-BraceStmtScope {{.*}}, [86:54 - 87:3]
// CHECK-EXPANDEC-NEXT:                                 `-CatchStmtScope {{.*}}, [87:11 - 88:3]
// CHECK-EXPANDEC-NEXT:                                   `-BraceStmtScope {{.*}}, [87:11 - 88:3]
// CHECK-EXPANDEC-NEXT:                               |-SwitchStmtScope {{.*}}, [90:3 - 99:3]
// CHECK-EXPANDEC-NEXT:                                 |-CaseStmtScope {{.*}}, [91:29 - 92:10]
// CHECK-EXPANDEC-NEXT:                                   `-BraceStmtScope {{.*}}, [92:5 - 92:10]
// CHECK-EXPANDEC-NEXT:                                 |-CaseStmtScope {{.*}}, [95:5 - 95:10]
// CHECK-EXPANDEC-NEXT:                                   `-BraceStmtScope {{.*}}, [95:5 - 95:10]
// CHECK-EXPANDEC-NEXT:                                 `-CaseStmtScope {{.*}}, [98:5 - 98:10]
// CHECK-EXPANDEC-NEXT:                                   `-BraceStmtScope {{.*}}, [98:5 - 98:10]
// CHECK-EXPANDEC-NEXT:                               `-ForEachStmtScope {{.*}}, [100:3 - 100:38]
// CHECK-EXPANDEC-NEXT:                                 `-ForEachPatternScope, [100:36 - 100:38]
// CHECK-EXPANDEC-NEXT:                                   `-BraceStmtScope {{.*}}, [100:36 - 100:38]
// CHECK-EXPANDEC-NEXT:   |-AbstractFunctionDeclScope {{.*}}, [103:1 - 103:26] 'throwing()'
// CHECK-EXPANDEC-NEXT:     `-AbstractFunctionParamsScope {{.*}}, [103:14 - 103:26]
// CHECK-EXPANDEC-NEXT:       `-PureFunctionBodyScope {{.*}}, [103:24 - 103:26]
// CHECK-EXPANDEC-NEXT:         `-BraceStmtScope {{.*}}, [103:24 - 103:26]
// CHECK-EXPANDEC-NEXT:   |-NominalTypeDeclScope {{.*}}, [105:1 - 107:1] 'MyError'
// CHECK-EXPANDEC-NEXT:     `-NominalTypeBodyScope {{.*}}, [105:24 - 107:1] 'MyError'
// CHECK-EXPANDEC-NEXT:       `-PatternEntryDeclScope {{.*}}, [106:7 - 106:14] entry 0 'value'
// CHECK-EXPANDEC-NEXT:         `-PatternEntryUseScope {{.*}}, [106:14 - 106:14] entry 0 'value'
// CHECK-EXPANDEC-NEXT:   |-NominalTypeDeclScope {{.*}}, [109:1 - 113:1] 'MyEnum'
// CHECK-EXPANDEC-NEXT:     `-NominalTypeBodyScope {{.*}}, [109:13 - 113:1] 'MyEnum'
// CHECK-EXPANDEC-NEXT:   |-NominalTypeDeclScope {{.*}}, [115:1 - 131:1] 'StructContainsAbstractStorageDecls'
// CHECK-EXPANDEC-NEXT:     `-NominalTypeBodyScope {{.*}}, [115:43 - 131:1] 'StructContainsAbstractStorageDecls'
// CHECK-EXPANDEC-NEXT:       |-SubscriptDeclScope {{.*}}, [116:3 - 122:3] main.(file).StructContainsAbstractStorageDecls.subscript(_:_:)@SOURCE_DIR/test/NameBinding/scope_map-astscopelookup.swift:116:3
// CHECK-EXPANDEC-NEXT:         `-AbstractFunctionParamsScope {{.*}}, [116:13 - 122:3]
// CHECK-EXPANDEC-NEXT:           |-AbstractFunctionDeclScope {{.*}}, [117:5 - 118:5] '_'
// CHECK-EXPANDEC-NEXT:             `-MethodBodyScope {{.*}}, [117:9 - 118:5]
// CHECK-EXPANDEC-NEXT:               `-BraceStmtScope {{.*}}, [117:9 - 118:5]
// CHECK-EXPANDEC-NEXT:           `-AbstractFunctionDeclScope {{.*}}, [119:5 - 121:5] '_'
// CHECK-EXPANDEC-NEXT:             `-MethodBodyScope {{.*}}, [119:9 - 121:5]
// CHECK-EXPANDEC-NEXT:               `-BraceStmtScope {{.*}}, [119:9 - 121:5]
// CHECK-EXPANDEC-NEXT:       `-PatternEntryDeclScope {{.*}}, [124:7 - 130:3] entry 0 'computed'
// CHECK-EXPANDEC-NEXT:         `-PatternEntryUseScope {{.*}}, [124:17 - 130:3] entry 0 'computed'
// CHECK-EXPANDEC-NEXT:           `-VarDeclScope {{.*}}, [124:21 - 130:3] main.(file).StructContainsAbstractStorageDecls.computed@SOURCE_DIR/test/NameBinding/scope_map-astscopelookup.swift:124:7
// CHECK-EXPANDEC-NEXT:             |-AbstractFunctionDeclScope {{.*}}, [125:5 - 127:5] '_'
// CHECK-EXPANDEC-NEXT:               `-MethodBodyScope {{.*}}, [125:9 - 127:5]
// CHECK-EXPANDEC-NEXT:                 `-BraceStmtScope {{.*}}, [125:9 - 127:5]
// CHECK-EXPANDEC-NEXT:             `-AbstractFunctionDeclScope {{.*}}, [128:5 - 129:5] '_'
// CHECK-EXPANDEC-NEXT:               `-MethodBodyScope {{.*}}, [128:9 - 129:5]
// CHECK-EXPANDEC-NEXT:                 `-BraceStmtScope {{.*}}, [128:9 - 129:5]
// CHECK-EXPANDEC-NEXT:   |-NominalTypeDeclScope {{.*}}, [133:1 - 141:1] 'ClassWithComputedProperties'
// CHECK-EXPANDEC-NEXT:     `-NominalTypeBodyScope {{.*}}, [133:35 - 141:1] 'ClassWithComputedProperties'
// CHECK-EXPANDEC-NEXT:       |-PatternEntryDeclScope {{.*}}, [134:7 - 136:3] entry 0 'willSetProperty'
// CHECK-EXPANDEC-NEXT:         |-PatternEntryInitializerScope {{.*}}, [134:30 - 134:30] entry 0 'willSetProperty'
// CHECK-EXPANDEC-NEXT:         `-PatternEntryUseScope {{.*}}, [134:30 - 136:3] entry 0 'willSetProperty'
// CHECK-EXPANDEC-NEXT:           `-VarDeclScope {{.*}}, [134:32 - 136:3] main.(file).ClassWithComputedProperties.willSetProperty@SOURCE_DIR/test/NameBinding/scope_map-astscopelookup.swift:134:7
// CHECK-EXPANDEC-NEXT:             `-AbstractFunctionDeclScope {{.*}}, [135:5 - 135:15] '_'
// CHECK-EXPANDEC-NEXT:               `-MethodBodyScope {{.*}}, [135:13 - 135:15]
// CHECK-EXPANDEC-NEXT:                 `-BraceStmtScope {{.*}}, [135:13 - 135:15]
// CHECK-EXPANDEC-NEXT:       `-PatternEntryDeclScope {{.*}}, [138:7 - 140:3] entry 0 'didSetProperty'
// CHECK-EXPANDEC-NEXT:         |-PatternEntryInitializerScope {{.*}}, [138:29 - 138:29] entry 0 'didSetProperty'
// CHECK-EXPANDEC-NEXT:         `-PatternEntryUseScope {{.*}}, [138:29 - 140:3] entry 0 'didSetProperty'
// CHECK-EXPANDEC-NEXT:           `-VarDeclScope {{.*}}, [138:31 - 140:3] main.(file).ClassWithComputedProperties.didSetProperty@SOURCE_DIR/test/NameBinding/scope_map-astscopelookup.swift:138:7
// CHECK-EXPANDEC-NEXT:             `-AbstractFunctionDeclScope {{.*}}, [139:5 - 139:14] '_'
// CHECK-EXPANDEC-NEXT:               `-MethodBodyScope {{.*}}, [139:12 - 139:14]
// CHECK-EXPANDEC-NEXT:                 `-BraceStmtScope {{.*}}, [139:12 - 139:14]
// CHECK-EXPANDEC-NEXT:   |-AbstractFunctionDeclScope {{.*}}, [143:1 - 156:1] 'funcWithComputedProperties(i:)'
// CHECK-EXPANDEC-NEXT:     `-AbstractFunctionParamsScope {{.*}}, [143:32 - 156:1]
// CHECK-EXPANDEC-NEXT:       `-PureFunctionBodyScope {{.*}}, [143:41 - 156:1]
// CHECK-EXPANDEC-NEXT:         `-BraceStmtScope {{.*}}, [143:41 - 156:1]
// CHECK-EXPANDEC-NEXT:           `-PatternEntryDeclScope {{.*}}, [144:7 - 155:8] entry 0 'computed'
// CHECK-EXPANDEC-NEXT:             `-PatternEntryUseScope {{.*}}, [144:17 - 155:8] entry 0 'computed'
// CHECK-EXPANDEC-NEXT:               |-VarDeclScope {{.*}}, [144:21 - 150:3] main.(file).funcWithComputedProperties(i:).computed@SOURCE_DIR/test/NameBinding/scope_map-astscopelookup.swift:144:7
// CHECK-EXPANDEC-NEXT:                 |-AbstractFunctionDeclScope {{.*}}, [145:5 - 146:5] '_'
// CHECK-EXPANDEC-NEXT:                   `-PureFunctionBodyScope {{.*}}, [145:9 - 146:5]
// CHECK-EXPANDEC-NEXT:                     `-BraceStmtScope {{.*}}, [145:9 - 146:5]
// CHECK-EXPANDEC-NEXT:                 `-AbstractFunctionDeclScope {{.*}}, [147:5 - 149:5] '_'
// CHECK-EXPANDEC-NEXT:                   `-PureFunctionBodyScope {{.*}}, [147:9 - 149:5]
// CHECK-EXPANDEC-NEXT:                     `-BraceStmtScope {{.*}}, [147:9 - 149:5]
// CHECK-EXPANDEC-NEXT:               `-PatternEntryDeclScope {{.*}}, [150:6 - 155:8] entry 1 'stored1' 'stored2'
// CHECK-EXPANDEC-NEXT:                 |-PatternEntryInitializerScope {{.*}}, [150:31 - 150:36] entry 1 'stored1' 'stored2'
// CHECK-EXPANDEC-NEXT:                 `-PatternEntryUseScope {{.*}}, [150:36 - 155:8] entry 1 'stored1' 'stored2'
// CHECK-EXPANDEC-NEXT:                   `-PatternEntryDeclScope {{.*}}, [151:3 - 155:8] entry 2 'alsoComputed'
// CHECK-EXPANDEC-NEXT:                     `-PatternEntryUseScope {{.*}}, [151:21 - 155:8] entry 2 'alsoComputed'
// CHECK-EXPANDEC-NEXT:                       |-VarDeclScope {{.*}}, [151:25 - 153:3] main.(file).funcWithComputedProperties(i:).alsoComputed@SOURCE_DIR/test/NameBinding/scope_map-astscopelookup.swift:151:7
// CHECK-EXPANDEC-NEXT:                         `-AbstractFunctionDeclScope {{.*}}, [151:25 - 153:3] '_'
// CHECK-EXPANDEC-NEXT:                           `-PureFunctionBodyScope {{.*}}, [151:25 - 153:3]
// CHECK-EXPANDEC-NEXT:                             `-BraceStmtScope {{.*}}, [151:25 - 153:3]
// CHECK-EXPANDEC-NEXT:                       `-BraceStmtScope {{.*}}, [155:6 - 155:8]
// CHECK-EXPANDEC-NEXT:   |-AbstractFunctionDeclScope {{.*}}, [158:1 - 163:1] 'closures()'
// CHECK-EXPANDEC-NEXT:     `-AbstractFunctionParamsScope {{.*}}, [158:14 - 163:1]
// CHECK-EXPANDEC-NEXT:       `-PureFunctionBodyScope {{.*}}, [158:17 - 163:1]
// CHECK-EXPANDEC-NEXT:         `-BraceStmtScope {{.*}}, [158:17 - 163:1]
// CHECK-EXPANDEC-NEXT:           |-WholeClosureScope {{.*}}, [159:3 - 161:3]
// CHECK-EXPANDEC-NEXT:             `-ClosureParametersScope {{.*}}, [159:5 - 161:3]
// CHECK-EXPANDEC-NEXT:               `-ClosureBodyScope {{.*}}, [159:10 - 161:3]
// CHECK-EXPANDEC-NEXT:                 `-BraceStmtScope {{.*}}, [159:10 - 161:3]
// CHECK-EXPANDEC-NEXT:                   `-WholeClosureScope {{.*}}, [160:12 - 160:22]
// CHECK-EXPANDEC-NEXT:                     `-ClosureBodyScope {{.*}}, [160:12 - 160:22]
// CHECK-EXPANDEC-NEXT:                       `-BraceStmtScope {{.*}}, [160:12 - 160:22]
// CHECK-EXPANDEC-NEXT:           `-WholeClosureScope {{.*}}, [162:3 - 162:19]
// CHECK-EXPANDEC-NEXT:             `-ClosureParametersScope {{.*}}, [162:5 - 162:19]
// CHECK-EXPANDEC-NEXT:               `-ClosureBodyScope {{.*}}, [162:10 - 162:19]
// CHECK-EXPANDEC-NEXT:                 `-BraceStmtScope {{.*}}, [162:10 - 162:19]
// CHECK-EXPANDEC-NEXT:   `-TopLevelCodeScope {{.*}}, [165:1 - 195:1]
// CHECK-EXPANDEC-NEXT:     `-BraceStmtScope {{.*}}, [165:1 - 195:1]
// CHECK-EXPANDEC-NEXT:       |-WholeClosureScope {{.*}}, [165:1 - 165:14]
// CHECK-EXPANDEC-NEXT:         `-ClosureBodyScope {{.*}}, [165:1 - 165:14]
// CHECK-EXPANDEC-NEXT:           `-BraceStmtScope {{.*}}, [165:1 - 165:14]
// CHECK-EXPANDEC-NEXT:       |-AbstractFunctionDeclScope {{.*}}, [167:1 - 176:1] 'defaultArguments(i:j:)'
// CHECK-EXPANDEC-NEXT:         `-AbstractFunctionParamsScope {{.*}}, [167:22 - 176:1]
// CHECK-EXPANDEC-NEXT:           |-DefaultArgumentInitializerScope {{.*}}, [167:32 - 167:32]
// CHECK-EXPANDEC-NEXT:           |-DefaultArgumentInitializerScope {{.*}}, [168:32 - 168:48]
// CHECK-EXPANDEC-NEXT:             `-WholeClosureScope {{.*}}, [168:32 - 168:42]
// CHECK-EXPANDEC-NEXT:               `-ClosureBodyScope {{.*}}, [168:32 - 168:42]
// CHECK-EXPANDEC-NEXT:                 `-BraceStmtScope {{.*}}, [168:32 - 168:42]
// CHECK-EXPANDEC-NEXT:           `-PureFunctionBodyScope {{.*}}, [168:51 - 176:1]
// CHECK-EXPANDEC-NEXT:             `-BraceStmtScope {{.*}}, [168:51 - 176:1]
// CHECK-EXPANDEC-NEXT:               |-AbstractFunctionDeclScope {{.*}}, [170:3 - 172:3] 'localWithDefaults(i:j:)'
// CHECK-EXPANDEC-NEXT:                 `-AbstractFunctionParamsScope {{.*}}, [170:25 - 172:3]
// CHECK-EXPANDEC-NEXT:                   |-DefaultArgumentInitializerScope {{.*}}, [170:35 - 170:35]
// CHECK-EXPANDEC-NEXT:                   |-DefaultArgumentInitializerScope {{.*}}, [171:35 - 171:51]
// CHECK-EXPANDEC-NEXT:                     `-WholeClosureScope {{.*}}, [171:35 - 171:45]
// CHECK-EXPANDEC-NEXT:                       `-ClosureBodyScope {{.*}}, [171:35 - 171:45]
// CHECK-EXPANDEC-NEXT:                         `-BraceStmtScope {{.*}}, [171:35 - 171:45]
// CHECK-EXPANDEC-NEXT:                   `-PureFunctionBodyScope {{.*}}, [171:54 - 172:3]
// CHECK-EXPANDEC-NEXT:                     `-BraceStmtScope {{.*}}, [171:54 - 172:3]
// CHECK-EXPANDEC-NEXT:               `-PatternEntryDeclScope {{.*}}, [174:7 - 175:11] entry 0 'a'
// CHECK-EXPANDEC-NEXT:                 |-PatternEntryInitializerScope {{.*}}, [174:11 - 175:11] entry 0 'a'
// CHECK-EXPANDEC-NEXT:                   `-WholeClosureScope {{.*}}, [175:3 - 175:8]
// CHECK-EXPANDEC-NEXT:                     `-ClosureBodyScope {{.*}}, [175:3 - 175:8]
// CHECK-EXPANDEC-NEXT:                       `-BraceStmtScope {{.*}}, [175:3 - 175:8]
// CHECK-EXPANDEC-NEXT:                 `-PatternEntryUseScope {{.*}}, [175:11 - 175:11] entry 0 'a'
// CHECK-EXPANDEC-NEXT:       |-NominalTypeDeclScope {{.*}}, [178:1 - 181:1] 'PatternInitializers'
// CHECK-EXPANDEC-NEXT:         `-NominalTypeBodyScope {{.*}}, [178:28 - 181:1] 'PatternInitializers'
// CHECK-EXPANDEC-NEXT:           `-PatternEntryDeclScope {{.*}}, [179:7 - 180:25] entry 0 'a' 'b'
// CHECK-EXPANDEC-NEXT:             |-PatternEntryInitializerScope {{.*}}, [179:16 - 179:21] entry 0 'a' 'b'
// CHECK-EXPANDEC-NEXT:             `-PatternEntryUseScope {{.*}}, [179:21 - 180:25] entry 0 'a' 'b'
// CHECK-EXPANDEC-NEXT:               `-PatternEntryDeclScope {{.*}}, [180:7 - 180:25] entry 1 'c' 'd'
// CHECK-EXPANDEC-NEXT:                 |-PatternEntryInitializerScope {{.*}}, [180:16 - 180:25] entry 1 'c' 'd'
// CHECK-EXPANDEC-NEXT:                 `-PatternEntryUseScope {{.*}}, [180:25 - 180:25] entry 1 'c' 'd'
// CHECK-EXPANDEC-NEXT:       |-NominalTypeDeclScope {{.*}}, [183:1 - 185:1] 'ProtoWithSubscript'
// CHECK-EXPANDEC-NEXT:         `-GenericParamScope {{.*}}, [183:29 - 185:1] param 0 'Self : ProtoWithSubscript'
// CHECK-EXPANDEC-NEXT:           `-NominalTypeBodyScope {{.*}}, [183:29 - 185:1] 'ProtoWithSubscript'
// CHECK-EXPANDEC-NEXT:             `-SubscriptDeclScope {{.*}}, [184:3 - 184:43] main.(file).ProtoWithSubscript.subscript(_:)@SOURCE_DIR/test/NameBinding/scope_map-astscopelookup.swift:184:3
// CHECK-EXPANDEC-NEXT:               `-AbstractFunctionParamsScope {{.*}}, [184:12 - 184:43]
// CHECK-EXPANDEC-NEXT:                 |-AbstractFunctionDeclScope {{.*}}, [184:35 - 184:35] '_'
// CHECK-EXPANDEC-NEXT:                 `-AbstractFunctionDeclScope {{.*}}, [184:39 - 184:39] '_'
// CHECK-EXPANDEC-NEXT:       |-AbstractFunctionDeclScope {{.*}}, [187:1 - 189:1] 'localPatternsWithSharedType()'
// CHECK-EXPANDEC-NEXT:         `-AbstractFunctionParamsScope {{.*}}, [187:33 - 189:1]
// CHECK-EXPANDEC-NEXT:           `-PureFunctionBodyScope {{.*}}, [187:36 - 189:1]
// CHECK-EXPANDEC-NEXT:             `-BraceStmtScope {{.*}}, [187:36 - 189:1]
// CHECK-EXPANDEC-NEXT:               `-PatternEntryDeclScope {{.*}}, [188:7 - 188:16] entry 0 'i'
// CHECK-EXPANDEC-NEXT:                 `-PatternEntryUseScope {{.*}}, [188:7 - 188:16] entry 0 'i'
// CHECK-EXPANDEC-NEXT:                   `-PatternEntryDeclScope {{.*}}, [188:10 - 188:16] entry 1 'j'
// CHECK-EXPANDEC-NEXT:                     `-PatternEntryUseScope {{.*}}, [188:10 - 188:16] entry 1 'j'
// CHECK-EXPANDEC-NEXT:                       `-PatternEntryDeclScope {{.*}}, [188:13 - 188:16] entry 2 'k'
// CHECK-EXPANDEC-NEXT:                         `-PatternEntryUseScope {{.*}}, [188:16 - 188:16] entry 2 'k'
// CHECK-EXPANDEC-NEXT:       `-NominalTypeDeclScope {{.*}}, [191:1 - 195:1] 'LazyProperties'
// CHECK-EXPANDEC-NEXT:         `-NominalTypeBodyScope {{.*}}, [191:22 - 195:1] 'LazyProperties'
// CHECK-EXPANDEC-NEXT:           |-PatternEntryDeclScope {{.*}}, [192:7 - 192:20] entry 0 'value'
// CHECK-EXPANDEC-NEXT:             |-PatternEntryInitializerScope {{.*}}, [192:20 - 192:20] entry 0 'value'
// CHECK-EXPANDEC-NEXT:             `-PatternEntryUseScope {{.*}}, [192:20 - 192:20] entry 0 'value'
// CHECK-EXPANDEC-NEXT:           `-PatternEntryDeclScope {{.*}}, [194:12 - 194:29] entry 0 'prop'
// CHECK-EXPANDEC-NEXT:             |-PatternEntryInitializerScope {{.*}}, [194:24 - 194:29] entry 0 'prop'
// CHECK-EXPANDEC-NEXT:             `-PatternEntryUseScope {{.*}}, [194:29 - 194:29] entry 0 'prop'


// RUN: not %target-swift-frontend -dump-scope-maps 71:8,27:20,6:18,167:32,180:18,194:26 %s 2> %t.searches
// RUN: %FileCheck -check-prefix CHECK-SEARCHES %s < %t.searches

// CHECK-SEARCHES:      ***Scope at 71:8***
// CHECK-SEARCHES-NEXT: BraceStmtScope {{.*}}, [69:53 - 72:3]
// CHECK-SEARCHES-NEXT: ***Scope at 27:20***
// CHECK-SEARCHES-NEXT: AbstractFunctionParamsScope {{.*}}, [27:13 - 28:3]
// CHECK-SEARCHES-NEXT: ***Scope at 6:18***
// CHECK-SEARCHES-NEXT: NominalTypeBodyScope {{.*}}, [6:17 - 6:19] 'InnerC0'
// CHECK-SEARCHES-NEXT: {{.*}} Module name=main
// CHECK-SEARCHES-NEXT:   {{.*}} FileUnit file="SOURCE_DIR/test/NameBinding/scope_map-astscopelookup.swift"
// CHECK-SEARCHES-NEXT:     {{.*}} StructDecl name=S0
// CHECK-SEARCHES-NEXT:       {{.*}} ClassDecl name=InnerC0
// CHECK-SEARCHES-NEXT: ***Scope at 167:32***
// CHECK-SEARCHES-NEXT: DefaultArgumentInitializerScope {{.*}}, [167:32 - 167:32]
// CHECK-SEARCHES-NEXT: {{.*}} Module name=main
// CHECK-SEARCHES-NEXT:   {{.*}} FileUnit file="SOURCE_DIR/test/NameBinding/scope_map-astscopelookup.swift"
// CHECK-SEARCHES-NEXT:     {{.*}} AbstractFunctionDecl name=defaultArguments(i:j:) : (Int, Int) -> ()
// CHECK-SEARCHES-NEXT:       {{.*}} Initializer DefaultArgument index=0
// CHECK-SEARCHES-NEXT: ***Scope at 180:18***
// CHECK-SEARCHES-NEXT: PatternEntryInitializerScope {{.*}}, [180:16 - 180:25] entry 1 'c' 'd'
// CHECK-SEARCHES-NEXT: {{.*}} Module name=main
// CHECK-SEARCHES-NEXT:   {{.*}} FileUnit file="SOURCE_DIR/test/NameBinding/scope_map-astscopelookup.swift"
// CHECK-SEARCHES-NEXT:     {{.*}} StructDecl name=PatternInitializers
// CHECK-SEARCHES-NEXT:       {{.*}} Initializer PatternBinding {{.*}} #1
// CHECK-SEARCHES-NEXT: ***Scope at 194:26***
// CHECK-SEARCHES-NEXT: PatternEntryInitializerScope {{.*}}, [194:24 - 194:29] entry 0 'prop'
// CHECK-SEARCHES-NEXT: {{.*}} Module name=main
// CHECK-SEARCHES-NEXT:   {{.*}} FileUnit file="SOURCE_DIR/test/NameBinding/scope_map-astscopelookup.swift"
// CHECK-SEARCHES-NEXT:     {{.*}} ClassDecl name=LazyProperties
// CHECK-SEARCHES-NEXT:       {{.*}} Initializer PatternBinding {{.*}} #0
// CHECK-SEARCHES-NEXT: Local bindings: self


// CHECK-SEARCHES-NOT:  ***Complete scope map***
