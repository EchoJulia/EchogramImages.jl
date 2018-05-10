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


"""
function echogram(A;
                  vmin = nothing,
                  vmax = nothing,
                  color=EK500_COLOURS,
                  size=(640,480))


    if vmax != nothing && vmin != nothing
        A = clamp.(A,vmin,vmax)
    end

    x = convert(AbstractFloat, minimum(A)) # Force floating point arithmetic
    y = maximum(A)
    A = (A .- x) ./ (y - x)
    n = length(color)
    f = s->clamp(round(Int, (n-1)*s)+1, 1, n)  # safely convert 0-1 to 1:n
    Ai = mappedarray(f, A)       # like f.(A) but does not allocate significant memory
    IndirectArray(Ai, color)      # colormap array

end

end # module
