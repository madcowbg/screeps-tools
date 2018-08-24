###
current =
  label: str
  adjacent: () -> [] of nbrs
###

module.exports.bfs = (edge, parent = {}, isVisited = {}) ->
  parent[edge.label] = undefined
  queue = [edge] # FIXME has slow shift operation
  while queue.length > 0
    current = queue.shift()
    if isVisited[current.label]
      continue

    for neighbour in current.adjacent()
      unless parent.hasOwnProperty neighbour.label
        queue.push neighbour
        parent[neighbour.label] = current

    yield current
    isVisited[current.label] = true

module.exports.path = (edge, parent) ->
  unless parent.hasOwnProperty edge.label
    throw new Error "invalid edge: #{JSON.stringify edge}"

  visited = {}
  result = []
  while edge?
    if visited[edge.label]
      throw new Error "duplicate visit of edge #{edge.label}: [#{JSON.stringify result}]"
    visited[edge.label] = true
    result.push edge
    edge = parent[edge.label]
  return result
