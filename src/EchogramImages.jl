module EchogramImages

using Images
using MappedArrays
using IndirectArrays

export EK500_COLOURS, echogram

const EK500_COLOURS = [RGB(1, 1, 1),
                             RGB(159/255, 159/255, 159/255),
                             RGB(95/255, 95/255, 95/255),
                             RGB(0, 0, 1),
                             RGB(0, 0, 127/255),
                             RGB(0, 191/255, 0),
                             RGB(0, 127/255, 0),
                             RGB(1, 1, 0),
                             RGB(1, 127/255, 0),
                             RGB(1, 0, 191/255),
                             RGB(1, 0, 0),
                             RGB(166/255, 83/255, 60/255),
                             RGB(120/255, 60/255, 40/255)]



"""
    echogram(A;
             vmin = nothing,
             vmax = nothing,
             color=EK500_COLOURS,
             size=(480,640))

A is any numeric array

color can be a list of Color or come from ColorSchemes.jl or
PerceptualColourMaps.

Set size = nothing for full resolution.

vmin and vmax are minimum and maximum values.

"""
function echogram(A;
                  vmin = nothing,
                  vmax = nothing,
                  color=EK500_COLOURS,
                  size=(480,640))


    if size != nothing
        A = imresize(A, size)
    end

    if vmin == nothing
        vmin = minimum(A[.!isnan.(A)])
    end

    if vmax == nothing
        vmax = maximum(A[.!isnan.(A)])
    end

    vmin = convert(AbstractFloat, vmin)
    vmax = convert(AbstractFloat, vmax)

    n = length(color)

    g = x -> (clamp(isnan(x)? vmin : x, vmin, vmax) - vmin) / (vmax - vmin)
    f = s->clamp(round(Int, (n-1)*g(s))+1, 1, n)

    Ai = mappedarray(f, A)       # like f.(A) but does not allocate significant memory
    IndirectArray(Ai, color)     # colormap array

end

end # module
