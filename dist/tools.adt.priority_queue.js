// Generated by CoffeeScript 2.3.2
var PriorityQueue;

module.exports = PriorityQueue = class PriorityQueue {
  constructor(scoreFunction, content = []) {
    this.scoreFunction = scoreFunction;
    this.content = content;
    if (typeof this.scoreFunction !== "function") {
      throw new Error("undefined scoring function!");
    }
  }

  push(element) {
    // Add the new element to the end of the array.
    this.content.push(element);
    return this._bubbleUp(this.content.length - 1);
  }

  top() {
    if (this.content.length === 0) {
      throw new Error();
    }
    return this.content[0];
  }

  pop() {
    var end, result;
    if (this.content.length === 0) {
      throw new Error();
    }
    // Store the first element so we can return it later.
    result = this.content[0];
    // Get the element at the end of the array.
    end = this.content.pop();
    // If there are any elements left, put the end element at the start, and let it sink down.
    if (this.content.length > 0) {
      this.content[0] = end;
      this._sinkDown(0);
    }
    return result;
  }

  remove(element) {
    var end, i, j, length, ref, results;
    length = this.content.length;
    results = [];
    for (i = j = 0, ref = length; (0 <= ref ? j < ref : j > ref); i = 0 <= ref ? ++j : --j) {
      if (this.content[i] !== element) {
        continue;
      }
      // When it is found, the process seen in 'pop' is repeated to fill up the hole.
      end = this.content.pop();
      if (i < length - 1) {
        // Otherwise, we replace the removed element with the popped one, and allow it to float up or sink down as appropriate.
        this.content[i] = end;
        this._bubbleUp(i);
        this._sinkDown(i);
      }
      break;
    }
    return results;
  }

  size() {
    return this.content.length;
  }

  _bubbleUp(n) {
    var element, parent, parentN, results, score;
    //   Fetch the element that has to be moved.
    element = this.content[n];
    score = this.scoreFunction(element);
    results = [];
    //   When at 0, an element can not go up any further.
    while (n > 0) {
      // Compute the parent element's index, and fetch it.
      parentN = Math.floor((n + 1) / 2) - 1;
      parent = this.content[parentN];
      if (score >= this.scoreFunction(parent)) {
        // If the parent has a lesser score, things are in order and we
        // are done.
        break;
      }
      // Otherwise, swap the parent with the current element and continue.
      this.content[parentN] = element;
      this.content[n] = parent;
      results.push(n = parentN);
    }
    return results;
  }

  _sinkDown(n) {
    var child1, child1N, child1Score, child2, child2N, child2Score, elemScore, element, length, results, swap;
    // Look up the target element and its score.
    length = this.content.length;
    element = this.content[n];
    elemScore = this.scoreFunction(element);
    results = [];
    while (true) {
      // Compute the indices of the child elements.
      child2N = (n + 1) * 2;
      child1N = child2N - 1;
      // This is used to store the new position of the element, if any.
      swap = null;
      // If the first child exists (is inside the array)...
      if (child1N < length) {
        // Look it up and compute its score.
        child1 = this.content[child1N];
        child1Score = this.scoreFunction(child1);
        //     If the score is less than our element's, we need to swap.
        if (child1Score < elemScore) {
          swap = child1N;
        }
      }
      // Do the same checks for the other child.
      if (child2N < length) {
        child2 = this.content[child2N];
        child2Score = this.scoreFunction(child2);
        if (child2Score < (swap === null ? elemScore : child1Score)) {
          swap = child2N;
        }
      }
      if (swap === null) {
        // No need to swap further, we are done.
        break;
      }
      // Otherwise, swap and continue.
      this.content[n] = this.content[swap];
      this.content[swap] = element;
      results.push(n = swap);
    }
    return results;
  }

  static test(n) {
    var h, j, ref, results, v, y;
    h = new Heap(function(a) {
      return a;
    });
    for (v = j = 1, ref = n; (1 <= ref ? j <= ref : j >= ref); v = 1 <= ref ? ++j : --j) {
      h.push(Math.floor(Math.random() * n));
    }
    if (n !== h.size()) {
      throw new Error(`wrong size! ${n} != ${h.size()}`);
    }
    v = -100;
    results = [];
    while (h.size() > 0) {
      y = h.pop();
      if (!(v <= y)) {
        // console.log v, y
        throw new Error(`${v} > ${y}`);
      }
      results.push(v = y);
    }
    return results;
  }

};
