// Generated by CoffeeScript 2.3.2
/*
current =
  label: str
  adjacent: () -> [] of nbrs
*/
var _;

_ = require('lodash');

module.exports.bfs = function*(vertex, parent = {}, isVisited = {}) {
  var current, i, len, neighbour, queue, ref, results;
  parent[vertex.label] = void 0;
  queue = [vertex]; // FIXME has slow shift operation
  results = [];
  while (queue.length > 0) {
    current = queue.shift();
    if (isVisited[current.label]) {
      continue;
    }
    ref = current.adjacent();
    for (i = 0, len = ref.length; i < len; i++) {
      neighbour = ref[i];
      if (!parent.hasOwnProperty(neighbour.label)) {
        queue.push(neighbour);
        parent[neighbour.label] = current;
      }
    }
    yield current;
    results.push(isVisited[current.label] = true);
  }
  return results;
};

module.exports.dijstraSlowDynamic = function(source, costFun, isTerminalNode, dist = {}, prev = {}) {
  var alt, consider, considered, current, i, len, neighbour, queue, ref;
  prev[source.label] = void 0;
  dist[source.label] = 0;
  queue = [source];
  considered = {};
  considered[source.label] = true;
  consider = function(el) {
    if (!considered[el.label]) {
      queue.push(el);
      dist[el.label] = 2e308;
      return considered[el.label] = true;
    }
  };
  while (queue.length > 0) {
    current = _.min(queue, function(v) {
      return dist[v.label];
    });
    _.pull(queue, current);
    if (isTerminalNode(current)) {
      return current;
    }
    ref = current.adjacent();
    for (i = 0, len = ref.length; i < len; i++) {
      neighbour = ref[i];
      consider(neighbour);
      alt = (costFun(current, neighbour)) + dist[current.label];
      if ((dist[neighbour.label] == null) || alt < dist[neighbour.label]) {
        dist[neighbour.label] = alt;
        prev[neighbour.label] = current;
      }
    }
  }
  return void 0;
};

module.exports.path = function(vertex, parent) {
  var result, visited;
  if (!parent.hasOwnProperty(vertex.label)) {
    throw new Error(`vertex without parent: ${JSON.stringify(vertex)}`);
  }
  visited = {};
  result = [];
  while (vertex != null) {
    if (visited[vertex.label]) {
      throw new Error(`duplicate visit of vertex ${vertex.label}: [${JSON.stringify(result)}]`);
    }
    visited[vertex.label] = true;
    result.push(vertex);
    vertex = parent[vertex.label];
  }
  return result;
};
