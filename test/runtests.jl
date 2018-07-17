using EchogramImages
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

a = rand(100,100)
img = imagesc(a)
m,n = size(img)
@test m == 480
@test n == 640
