// Playground - noun: a place where people can play

import UIKit

class Stack {
  var ArrayOfInts = [Int]()
  func push(item : Int) -> Int? {
    self.ArrayOfInts.append(item)
    let anInt = self.ArrayOfInts.last
    println("You added this one: \(anInt)")
    return anInt!
  }
  
  func pop() -> Int? {
    if !self.ArrayOfInts.isEmpty{
      self.ArrayOfInts.removeLast()
       let anInt = self.ArrayOfInts.last
      return anInt!
    } else {
      println("Here you go")
      return nil
    }
  }
  
  func peak() ->Int? {
    if !self.ArrayOfInts.isEmpty{
    return self.ArrayOfInts.last
  } else {
      println("You can look but not touch")
  return nil
  }
}
}

