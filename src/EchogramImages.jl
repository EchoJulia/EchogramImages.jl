module EchogramImages

using Images
using MappedArrays
using IndirectArrays

export EK80_COLOURS, EK500_COLOURS, imagesc, mat2gray, equalizedbins, quantize

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

const EK80_COLOURS = reverse([RGB(155/255, 7/255, 11/255),
                      RGB(154/255, 15/255, 22/255),
                      RGB(153/255, 23/255, 33/255),
                      RGB(151/255, 31/255, 45/255),
                      RGB(150/255, 39/255, 56/255),
                      RGB(153/255, 44/255, 58/255),
                      RGB(159/255, 47/255, 56/255),
                      RGB(165/255, 51/255, 54/255),
                      RGB(170/255, 54/255, 51/255),
                      RGB(176/255, 57/255, 49/255),
                      RGB(184/255, 57/255, 48/255),
                      RGB(198/255, 51/255, 49/255),
                      RGB(212/255, 44/255, 50/255),
                      RGB(226/255, 37/255, 51/255),
                      RGB(240/255, 30/255, 52/255),
                      RGB(255/255, 24/255, 54/255),
                      RGB(254/255, 36/255, 75/255),
                      RGB(253/255, 48/255, 96/255),
                      RGB(253/255, 61/255, 118/255),
                      RGB(252/255, 73/255, 139/255),
                      RGB(252/255, 85/255, 160/255),
                      RGB(252/255, 93/255, 153/255),
                      RGB(252/255, 99/255, 130/255),
                      RGB(252/255, 105/255, 108/255),
                      RGB(252/255, 110/255, 85/255),
                      RGB(252/255, 116/255, 63/255),
                      RGB(252/255, 128/255, 47/255),
                      RGB(252/255, 153/255, 46/255),
                      RGB(253/255, 179/255, 45/255),
                      RGB(253/255, 204/255, 44/255),
                      RGB(254/255, 229/255, 43/255),
                      RGB(255/255, 255/255, 42/255),
                      RGB(208/255, 231/255, 52/255),
                      RGB(161/255, 208/255, 62/255),
                      RGB(114/255, 185/255, 72/255),
                      RGB(68/255, 162/255, 82/255),
                      RGB(21/255, 139/255, 92/255),
                      RGB(10/255, 141/255, 99/255),
                      RGB(17/255, 156/255, 105/255),
                      RGB(24/255, 171/255, 111/255),
                      RGB(30/255, 185/255, 116/255),
                      RGB(37/255, 200/255, 122/255),
                      RGB(41/255, 197/255, 129/255),
                      RGB(40/255, 160/255, 138/255),
                      RGB(39/255, 123/255, 147/255),
                      RGB(38/255, 86/255, 156/255),
                      RGB(37/255, 49/255, 165/255),
                      RGB(36/255, 12/255, 174/255),
                      RGB(29/255, 30/255, 189/255),
                      RGB(22/255, 48/255, 204/255),
                      RGB(15/255, 66/255, 219/255),
                      RGB(9/255, 84/255, 234/255),
                      RGB(9/255, 102/255, 249/255),
                      RGB(9/255, 103/255, 232/255),
                      RGB(24/255, 96/255, 197/255),
                      RGB(39/255, 90/255, 163/255),
                      RGB(53/255, 83/255, 129/255),
                      RGB(68/255, 76/255, 94/255),
                      RGB(82/255, 76/255, 78/255),
                      RGB(97/255, 88/255, 96/255),
                      RGB(112/255, 100/255, 114/255),
                      RGB(126/255, 113/255, 132/255),
                      RGB(141/255, 125/255, 150/255),
                      RGB(156/255, 138/255, 168/255),
                      RGB(255/255, 255/255, 255/255)])



"""
    imagesc(A;
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
function imagesc(A;
                  vmin = nothing,
                  vmax = nothing,
                  color=EK80_COLOURS,
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

    g = x -> (clamp(isnan(x) ? vmin : x, vmin, vmax) - vmin) / (vmax - vmin)
    f = s->clamp(round(Int, (n-1)*g(s))+1, 1, n)

    Ai = mappedarray(f, A)       # like f.(A) but does not allocate significant memory
    IndirectArray(Ai, color)     # colormap array

end


"""
    mat2gray(A; amin=nothing, amax=nothing)

Convert matrix `A` to grayscale with pixel values in the range 0.0
(black) to 1.0 (white).

NB Intentionally, NaNs get replaced by 0.0 to facilitate the use of
the wider Julia Images ecosystem.

"""
function mat2gray(A; amin=nothing, amax=nothing)

    B = A[.!isnan.(A)]
    
    if amin == nothing
        amin = minimum(B)
    end
    if amax == nothing
        amax = maximum(B)
    end
    f = scaleminmax(amin, amax)
    C = f.(A)
    C[isnan.(C)] .= 0.0
    return C
end


"""
    equalizedbins(A; nbins = 256, amin=nothing, amax=nothing)

Using histogram equalisation, return the bin edges (the cut off
points) that would allow `A` to be quantized into `nbins`.

"""
function equalizedbins(A; nbins = 256, amin=nothing, amax=nothing)
    a = sort(vec(A))
    if amin != nothing
        filter!(x-> x>amin , a)
        # Reserve a bin for everything below minA
        nbins = nbins -1
    end
    if amax != nothing
        filter!(x-> x<amax , a)
        # Reserve a bin for everything above maxA
        nbins = nbins -1
    end

    # Equalise bin spacing
    d = length(a) / nbins
    r = [a[ceil(Int,i)] for i in d:d:d*(nbins-1)]
    
    if amin != nothing
        # if specified, minA is the first bin dimension
        r = vcat([amin],r)
    end
    if amax != nothing
        # if specified, maxA is the last bin dimension
        r = vcat(r, [amax])
    end
    return r
        
end

"""

    quantize(A, edges)

Quantise the 2D array`A` into `length(edges)` levels where `edges` is
the list of bin cut-off points.

Quantization, in mathematics and digital signal processing, is the
process of mapping input values from a large set (often a continuous
set) to output values in a (countable) smaller set, often with a
finite number of elements.

"""
function quantize(A, edges)
    m,n = size(A)
    if length(edges) < 256
        B= Matrix{UInt8}(undef,m,n)
    else
        B= Matrix(undef,m,n)
    end
    B .= 0
    for i in 1:length(edges)
        B[A .> edges[i]] .= i
    end
    return B
end


end # module
