// REQUIRES: enable-astscope-lookup
// RUN: %target-swift-emit-silgen %s -verify

/// We emit an invalid forward capture as an 'undef'; make sure
/// we cover the various possible cases.

public func captureBeforeDefLet(amount: Int) -> () -> Int {
  func getter() -> Int {
    return modifiedAmount // expected-error {{use of unresolved identifier 'modifiedAmount'}}
  }
  let closure = getter
  let modifiedAmount = amount
  // FIXME: Bogus warning!
  // expected-warning@-2 {{initialization of immutable value 'modifiedAmount' was never used; consider replacing with assignment to '_' or removing it}}
  return closure
}

public func captureBeforeDefVar(amount: Int) -> () -> Int {
  func incrementor() -> Int {
    currentTotal += amount // expected-error {{use of unresolved identifier 'currentTotal'}}
    return currentTotal // expected-error {{use of unresolved identifier 'currentTotal'}}
  }
  let closure = incrementor
  var currentTotal = 0
  // FIXME: Bogus warning!
  // expected-warning@-2 {{variable 'currentTotal' was written to, but never read}}
  currentTotal = 1
  return closure
}

public func captureBeforeDefWeakVar(obj: AnyObject) -> () -> AnyObject? {
  func getter() -> AnyObject? {
    return weakObj // expected-error {{use of unresolved identifier 'weakObj'}}
  }
  let closure = getter
  weak var weakObj: AnyObject? = obj
  // FIXME: Bogus warning!
  // expected-warning@-2 {{variable 'weakObj' was written to, but never read}}
  return closure
}

public func captureBeforeDefUnownedLet(obj: AnyObject) -> () -> AnyObject? {
  func getter() -> AnyObject? {
    return unownedObj // expected-error {{use of unresolved identifier 'unownedObj'}}
  }
  let closure = getter
  unowned let unownedObj: AnyObject = obj
  // FIXME: Bogus warning!
  // expected-warning@-2 {{immutable value 'unownedObj' was never used; consider replacing with '_' or removing it}}
  return closure
}

public func captureBeforeDefUnownedVar(obj: AnyObject) -> () -> AnyObject? {
  func getter() -> AnyObject? {
    return unownedObj // expected-error {{use of unresolved identifier 'unownedObj'}}
  }
  let closure = getter
  unowned var unownedObj: AnyObject = obj
  // FIXME: Bogus warning!
  // expected-warning@-2 {{variable 'unownedObj' was never used; consider replacing with '_' or removing it}}
  return closure
}

/// Examples of transitive capture

func pingpong() {
  func ping() -> Int {
    return pong()
  }
  func pong() -> Int {
    return ping()
  }
  _ = ping()
}

func transitiveForwardCapture() {
  func ping() -> Int {
    return pong()
  }
  _ = ping()
  var x = 1
  func pong() -> Int {
    x += 1
    return ping()
  }
}

func transitiveForwardCapture2() {
  func ping() -> Int {
    _ = pong()
  }
  _ = ping()
  var x = 1
  func pong() -> Int {
    _ = pung()
  }
  func pung() -> Int {
    x += 1
    return ping()
  }
}

func transitiveForwardCapture3() {
  var y = 2
  func ping() -> Int {
    _ = pong()
  }
  _ = ping()
  var x = 1
  func pung() -> Int {
    x += 1
    return ping()
  }
  func pong() -> Int {
    y += 2
    _ = pung()
  }
}

func captureInClosure() {
  let x = { (i: Int) in
    currentTotal += i // expected-error {{use of unresolved identifier 'currentTotal'}}
  }

  var currentTotal = 0

  _ = x
}

/// Regression tests

func sr3210_crash() {
  defer {
    print("\(b)") // expected-error {{use of unresolved identifier 'b'}}
  }

  return

  let b = 2
  // expected-warning@-1 {{initialization of immutable value 'b' was never used; consider replacing with assignment to '_' or removing it}}
}

func sr3210() {
  defer {
    print("\(b)") // expected-error {{use of unresolved identifier 'b'}}
  }

  let b = 2
  // FIXME: Bogus warning!
  // expected-warning@-2 {{initialization of immutable value 'b' was never used; consider replacing with assignment to '_' or removing it}}
}

class SR4812 {
  public func foo() {
    let bar = { [weak self] in
      bar2()
    }
    func bar2() {
      bar()
    }
    bar()
  }
}

func timeout(_ f: @escaping () -> Void) {
  f()
}

func sr10687() {
  timeout {
    proc()
  }
  
  let x = 0
  
  func proc() {
    _ = x
  }
}

class rdar40600800 {
  func foo() {
    let callback = {
      innerFunction()
    }

    func innerFunction() {
      let closure = {
      // FIXME: Bogus warning!
      // expected-warning@-2 {{initialization of immutable value 'closure' was never used; consider replacing with assignment to '_' or removing it}}
        callback()
      }
    }
  }
}
