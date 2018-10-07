###
current =
  label: str
  adjacent: () -> [] of nbrs
###
_ = require 'lodash'

module.exports.bfs = (vertex, parent = {}, isVisited = {}) ->
  parent[vertex.label] = undefined
  queue = [vertex] # FIXME has slow shift operation
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

module.exports.dijstraSlowDynamic = (source, costFun, isTerminalNode, dist = {}, prev = {}) ->
  prev[source.label] = undefined
  dist[source.label] = 0

  queue = [source]

  considered = {}
  considered[source.label] = true

  consider = (el) ->
    if not considered[el.label]
      queue.push el
      dist[el.label] = Infinity
      considered[el.label] = true

  while queue.length > 0
    current = _.min queue, (v) -> dist[v.label]
    _.pull queue, current

    if isTerminalNode current
      return current

    for neighbour in current.adjacent()
      consider neighbour

      alt = (costFun current, neighbour) + dist[current.label]

      if not dist[neighbour.label]? or alt < dist[neighbour.label]
        dist[neighbour.label] = alt
        prev[neighbour.label] = current

  return undefined

module.exports.path = (vertex, parent) ->
  unless parent.hasOwnProperty vertex.label
    throw new Error "vertex without parent: #{JSON.stringify vertex}"

  visited = {}
  result = []
  while vertex?
    if visited[vertex.label]
      throw new Error "duplicate visit of vertex #{vertex.label}: [#{JSON.stringify result}]"
    visited[vertex.label] = true
    result.push vertex
    vertex = parent[vertex.label]
  return result
