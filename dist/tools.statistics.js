// Generated by CoffeeScript 2.3.2
var MAX_TICKS_STORED_STATISTIC, Writer, log;

log = require('tools.log');

MAX_TICKS_STORED_STATISTIC = 10;

if (Memory.stats == null) {
  Memory.stats = {};
}

module.exports.gc = function() {
  var results, s, statisticTimes, time;
  if (Memory.stats == null) {
    return;
  }
  statisticTimes = (function() {
    var ref, results;
    ref = Memory.stats;
    results = [];
    for (time in ref) {
      s = ref[time];
      results.push(parseInt(time, 10));
    }
    return results;
  })();
  // console.log statisticTimes.length
  if (statisticTimes.length < MAX_TICKS_STORED_STATISTIC) {
    return;
  }
  statisticTimes = statisticTimes.sort();
// console.log "cleaning #{statisticTimes[statisticTimes.length - MAX_TICKS_STORED_STATISTIC]}!"
  results = [];
  for (time in Memory.stats) {
    if (parseInt(time, 10) <= statisticTimes[statisticTimes.length - MAX_TICKS_STORED_STATISTIC + 1]) {
      results.push(delete Memory.stats[time]);
    }
  }
  return results;
};

Writer = class Writer {
  constructor(thisName, parentObject = null) {
    var base, base1, name;
    this.statisticsValuesObject = parentObject != null ? parentObject[thisName] != null ? parentObject[thisName] : parentObject[thisName] = {} : (base = ((base1 = Memory.stats)[name = Game.time] != null ? base1[name] : base1[name] = {}))[thisName] != null ? base[thisName] : base[thisName] = {};
  }

  write(statName, value) {
    this.statisticsValuesObject[statName] = value;
    // log.info? "#{@totalPath}.#{statName}", value
    return this;
  }

  sub(childName) {
    return new Writer(childName, this.statisticsValuesObject);
  }

};

module.exports.root = function(rootName) {
  return new Writer(rootName);
};
