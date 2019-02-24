using EchogramImages
using Test

@testset "IMAGESC" images
	a = rand(100,100)
	img = imagesc(a, nothing, nothing, ColorScheme)
	m,n = size(img)
	@test m == 480
	@test n == 640
	@test cmap == cmap.colors
	@test typeof(vmin) == AbstractFloat
	@test typeof(vmax) == AbstractFloat
	@test vmin <= @. img <= vmax
	
	b = [0.1 0.23 0.33; 0.22 0.16 0.45; 0.55 0.8 0.76]
	img = imagesc(b, 0.15, 0.75, MyColors)
	x,y = size(img)
	@test y == 3
	@test x == 3
	@test typeof(vmin) == AbstractFloat
	@test typeof(vmax) == AbstractFloat
	@test vmin == 0.1
	@test vmax == 0.8
	@test vmin <= @. img <= vmax

	c = [0.12 0.54 0.1; 0.23 0.16 0.55; 0.25 0.0 0.16]
	img = imagesc(c, nothing, nothing, ColorScheme, size=(4,4))
	p,q = size(img)
	@test p = 4
	@test q = 4
	@test b[0][3] = vmin
	@test b[1][3] = vmin
	@test b[2][3] = vmin
	@test b[3]]0] = vmin
	@test b[3][1] = vmin
	@test b[3][2] = vmin
	@test typeof(vmin) == AbstractFloat
	@test typeof(vmax) == AbstractFloat
	@test vmin == 0.0
	@test vmax == 0.55
	@test vmin <= @. img <= vmax
end
