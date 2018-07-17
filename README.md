# EchogramImages


[![Build Status](https://travis-ci.org/EchoJulia/EchogramImages.jl.svg?branch=master)](https://travis-ci.org/EchoJulia/EchogramImages.jl)

[![Coverage Status](https://coveralls.io/repos/EchoJulia/EchogramImages.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/EchoJulia/EchogramImages.jl?branch=master)

[![codecov.io](http://codecov.io/github/EchoJulia/EchogramImages.jl/coverage.svg?branch=master)](http://codecov.io/github/EchoJulia/EchogramImages.jl?branch=master)




Simple echogram images of arbitrary matrices in Julia.

Works in IJulia or any Julia development environment.

A bit like EchogramPlots.jl but generates Images instead of graphs.

A bit like imagesc in MATLAB.

## Simple example

```
using EchogramImages
imagesc(rand(100,100))
```

## EK60 example

A useful companion to the SimradEK60.jl package.

```
using EchogramImages
using SimradEK60TestData
using SimradEK60
ps =collect(pings(EK60_SAMPLE));
ps38 = [p for p in ps if p.frequency == 38000];
Sv38 = Sv(ps38);
img = imagesc(Sv38,vmin=-95,vmax=-50)

```

You can also use other color schemes

```
using ColorSchemes
img = imagesc(Sv38,color=ColorSchemes.plasma)
```

## Acknowledgements

My thanks to Tim Holy for [sample code](https://discourse.julialang.org/t/how-to-convert-a-matrix-to-an-rgb-image-using-images-jl/7265/8).
