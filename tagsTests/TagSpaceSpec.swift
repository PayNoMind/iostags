//
//  TagSpaceSpec.swift
//  tags
//
//  Created by Tom Clark on 2014-08-16.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

//import Tags
import UIKit
import Quick
import Nimble

class TagSpaceSpec : QuickSpec {
  override func spec() {
    let tagSpace = TagSpace(frame: CGRectZero)
    it("exists") {
      expect(tagSpace).toNot(beNil())
    }
    it("has no tags in array") {
      expect(tagSpace.getTagCardinality()).to(equal(0))
    }
    it("has 5 tags in array after adding array") {
      tagSpace.addTags(["groceries","home","work","test","stuff"])
      expect(tagSpace.getTagCardinality()).to(equal(5))
    }
  }
}