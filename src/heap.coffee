module.exports = class Heap
  constructor: (@scoreFunction, @content = []) ->
    throw new Error("undefined scoring function!") unless typeof @scoreFunction == "function"

  push: (element) ->
    # Add the new element to the end of the array.
    @content.push(element);
    # Allow it to bubble up.
    @_bubbleUp(@content.length - 1);

  top: () ->
    throw new Error() if @content.length == 0
    return @content[0]

  pop: () ->
    throw new Error() if @content.length == 0

    # Store the first element so we can return it later.
    result = @content[0]
    # Get the element at the end of the array.
    end = @content.pop()
    # If there are any elements left, put the end element at the start, and let it sink down.
    if @content.length > 0
      @content[0] = end
      @_sinkDown(0)

    return result

  remove: (element) ->
    length = @content.length;
    # To remove a value, we must search through the array to find it.
    for i in [0...length]
      continue if (@content[i] != element)
      # When it is found, the process seen in 'pop' is repeated to fill up the hole.
      end = @content.pop();
      # If the element we popped was the one we needed to remove, we're done.
      if (i < length - 1)
        # Otherwise, we replace the removed element with the popped one, and allow it to float up or sink down as appropriate.
        @content[i] = end;
        @_bubbleUp(i);
        @_sinkDown(i);
      break

  size: () -> @content.length

  _bubbleUp: (n) ->
#   Fetch the element that has to be moved.
    element = @content[n]
    score = @scoreFunction(element)
    #   When at 0, an element can not go up any further.
    while (n > 0)
# Compute the parent element's index, and fetch it.
      parentN = Math.floor((n + 1) / 2) - 1
      parent = @content[parentN]
      # If the parent has a lesser score, things are in order and we
      # are done.
      break if score >= @scoreFunction(parent)

      # Otherwise, swap the parent with the current element and continue.
      @content[parentN] = element;
      @content[n] = parent;
      n = parentN

  _sinkDown: (n) ->
    # Look up the target element and its score.
    length = @content.length
    element = @content[n]
    elemScore = @scoreFunction(element)

    loop
      # Compute the indices of the child elements.
      child2N = (n + 1) * 2
      child1N = child2N - 1
      # This is used to store the new position of the element, if any.
      swap = null
      # If the first child exists (is inside the array)...
      if child1N < length
      # Look it up and compute its score.
        child1 = @content[child1N]
        child1Score = @scoreFunction(child1)
        #     If the score is less than our element's, we need to swap.
        if (child1Score < elemScore)
          swap = child1N

      # Do the same checks for the other child.
      if child2N < length
        child2 = @content[child2N]
        child2Score = @scoreFunction(child2)
        if (child2Score < (if swap == null then elemScore else child1Score))
          swap = child2N

      # No need to swap further, we are done.
      break if swap == null

      # Otherwise, swap and continue.
      @content[n] = @content[swap]
      @content[swap] = element
      n = swap

  @test: (n) ->
    h = new Heap((a) -> a)
    for v in [1..n]
      h.push(Math.floor(Math.random() * n))

    throw new Error("wrong size! #{n} != #{h.size()}") unless n == h.size()
    v = -100
    while h.size() > 0
      y = h.pop()
      # console.log v, y
      throw new Error("#{v} > #{y}") unless v <= y
      v = y
