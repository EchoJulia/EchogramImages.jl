# EchogramImages

Simple echogram displays of arbitrary matrices in Julia.

Works in IJulia or any Julia development environment.

A bit like EchogramPlots.jl but generates Images instead of graphs.

A bit like imagesc in MATLAB.

## Simple example

```
using EchogramImages
echogram(rand(100,100))
```

## EK60 example

A useful companion to the SimradEK60.jl package.

```
using EchogramImages
using SimradRaw
using SimradEK60
using Images
ps =collect(pings(EK60_SAMPLE));
ps38 = [p for p in ps if p.frequency == 38000];
Sv38 = Sv(ps38);
r = R(ps38);
img = echogram(Sv38,vmin=-95,vmax=-50)
imresize(img,(480,640))
```

You can also use other color schemes

```
using ColorSchemes
img = echogram(Sv38,color=ColorSchemes.plasma)
imresize(img,(480,640))
```

## Acknowledgements

My thanks to Tim Holy for [sample code](https://discourse.julialang.org/t/how-to-convert-a-matrix-to-an-rgb-image-using-images-jl/7265/8).
