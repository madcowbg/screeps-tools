_ = require 'lodash'
random = require 'utils.random'

test 'test shuffling', () ->
  nmax = 10

  for i in [0..10]
    emax = Math.floor(Math.random() * 100)
    els = ((if Math.random() * 4 < 1 then null else Math.floor(Math.random() * nmax)) for i in [0..emax])

    shuffled = _.sortBy random.shuffle els
    expect(els).not.toEqual shuffled if emax > 20  # TODO this can still randomly fail...
    expect(_.sortBy els).toEqual(_.sortBy shuffled)

    expect(els).toContain(random.element els) for i in [0..20]
  return
