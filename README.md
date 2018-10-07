# screeps-tools
Various useful tools for my Screeps AI.

## Installation
This package is developed in Coffeescript. To simplify the installation, a precompiled JS version is provided in ```dist/```.

Package tests are supplied, using the JEST framework.

## Usage
Below are listed some useful modules.

### tools.log
Provides beatified logs. Examples:
 * `log.info` - must be enabled to actually use - mostly use for dumps.
 * `log.warn` - signifies some worrying behavior, but nothing fatal.
 * `log.error` - serious errors - usually throws exception afterwards.

### tools.body
Creep designers and other tools.

### tools.cache
Memoization tools that can memoize function call results per tick or completely static.

Note that JS is somewhat slow in method calling, so use this only when it makes sense.

### tools.naming
Randomized creep and spawn naming schemes, based on http://www.fantasynamegenerators.com/.

### tools.coordinates
Simple conversion from `{x, y}` to number representation and back.

Useful for optimized storage of coordinates, for example in room planning.

### tools.statistics
Utilities to support statistics dumps per tick, with in-build GC.

Can be used to log to Graphite and Grafana visualization.
