### A Pluto.jl notebook ###
# v0.14.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ f576f987-1cc0-467c-a758-dc6455b1c6fa
import Pkg; Pkg.add("PlutoUI"); Pkg.add("HypertextLiteral");

# ╔═╡ c1d53d59-78d1-46e4-a9db-53de75babd0d
begin
	import ImageMagick
	using Images
	using PlutoUI
	using HypertextLiteral
end

# ╔═╡ 4af13574-68d3-48c1-9be7-bc8fc25923ad
# Exeercise 1

# ╔═╡ 8e81a7df-91f3-4e0a-9e1e-0e47a6bfb17c
example_vector = 
[
0.5
0.4
0.3
0.2
0.1
0.0
0.7
0.0
0.7
0.9
]

# ╔═╡ f5122881-37b6-40c6-b2a3-d10201eb0732
random_vect = rand(Float64, 10)

# ╔═╡ 77d24198-1a31-4345-b23a-1d83789005db
function my_sum(xs)
	# your code here!
	sum = 0
	for x in xs
		sum += x
	end
	return sum
end

# ╔═╡ a62a49d9-2a2f-40b5-b5f0-e9e2f912098b
function mean(xs)
	# your code here!
	sum = my_sum(xs)
	l = length(xs)
	return sum / l
end

# ╔═╡ 0c6e7622-776f-464e-946c-8f18107bbb28
m = mean(random_vect)

# ╔═╡ e22f3fb1-72dc-4609-8468-b43e0deb2e09
function demean(xs)
	# your code here!
	m = mean(xs)
	new_arr = [x-m for x in xs]
	return new_arr
end

# ╔═╡ 9094fb02-b878-40ed-9394-4524556475b2
test_vect = 
[-1.0
-1.5
8.5]


# ╔═╡ 9abdf36a-c39b-4a75-a90e-2f4a09662a0e
demeaned_test_vect = demean(test_vect)

# ╔═╡ 51cb0236-2f81-4bd9-8e96-e32d6d75964a
mean(demeaned_test_vect)

# ╔═╡ 3b59b485-bcd5-4950-a599-d7720e6a5208
function create_bar()
	# your code here!
	arr = zeros(Int64, 100)
	arr[40:60] .= 1
	return arr
end

# ╔═╡ c6f24716-3f83-4e93-a10c-6bef320f33a7
create_bar()

# ╔═╡ 2fcf950d-9e0b-4f87-bffa-254ee20e7146
# Exercise 2

# ╔═╡ 1e2ef986-489e-423a-af2e-e70a7a47a347
url = "https://user-images.githubusercontent.com/6933510/107239146-dcc3fd00-6a28-11eb-8c7b-41aaf6618935.png" 

# ╔═╡ 4e59aab3-e15e-410a-80ee-0d31473ce526
philip_filename = download(url)

# ╔═╡ cb47d58f-90c0-4a4f-9444-120b25f98d30
philip = load(philip_filename)

# ╔═╡ 500712f6-211d-4ed5-9f87-1a617efc0352
philip_head = philip[470:800, 140:410]

# ╔═╡ 8dab739c-3171-412b-8c73-8232a17fa08f
typeof(philip)

# ╔═╡ 91d3432a-92fd-4d18-ab05-ed8709df03df
philip_pixel = philip[100,100]

# ╔═╡ eefcd2d5-3910-4832-8fba-f9a31bd1dab5
typeof(philip_pixel)

# ╔═╡ 12601666-a842-4cef-aeb4-6df0ec7a3ec8
philip_pixel.r, philip_pixel.g, philip_pixel.b

# ╔═╡ c810f703-e608-439d-bb4b-ccc7b8627d14
RGB(0.1, 0.4, 0.7)

# ╔═╡ ecddcdd8-9e34-4913-8c71-40571ccbbe49
function get_red(pixel::AbstractRGB)
	# your code here!
	return pixel.r
end

# ╔═╡ e877e004-56d3-4fd3-adc7-39611cc5fd58
get_red(RGB(0.8, 0.1, 0.0))

# ╔═╡ c0b9dd9d-3a1f-4e83-adc3-4f4ebc7540ef
function get_reds(image::AbstractMatrix)
	# your code here!
	new_arr = get_red.(image)
	return new_arr
end

# ╔═╡ acd8550d-ef0a-494a-b044-e1f0c1809cd6
function value_as_color(x)
	
	return RGB(x, 0, 0)
end

# ╔═╡ 69b647fe-86ed-4603-9a69-285bbb672a5e
value_as_color(0.0), value_as_color(0.6), value_as_color(1.0)

# ╔═╡ 73d839ce-070a-44d4-b3f8-65c22474a78a
value_as_color.(get_reds(philip_head))

# ╔═╡ 09e8e627-183b-47ec-ae6b-43c7507e571e
function get_green(pixel::AbstractRGB)
	# your code here!
	return pixel.g
end

# ╔═╡ d568a628-48b5-47d9-9a20-9174c651ab8e
function get_greens(image::AbstractMatrix)
	# your code here!
	new_arr = get_green.(image)
	return new_arr
end

# ╔═╡ dc01dcf8-0428-4b42-b71c-80ae4d1fc04b
function get_blue(pixel::AbstractRGB)
	# your code here!
	return pixel.b
end

# ╔═╡ d757a859-92bf-4184-b33e-896ef0855aa3
function get_blues(image::AbstractMatrix)
	# your code here!
	new_arr = get_blue.(image)
	return new_arr
end

# ╔═╡ 4e786989-69f0-4bd2-857a-3a8ae8925397
function mean_color(image)
	# your code here!
	r = get_reds(image)
	b = get_blues(image)
	g = get_greens(image)
	r_avg = mean(r)
	b_avg = mean(b)
	g_avg = mean(g)
	return RGB(r_avg, g_avg, b_avg)
end

# ╔═╡ 0f9669ec-6eac-4c3d-9c8e-b3eb38add584
# Exercise 3

# ╔═╡ f556cce4-ea55-419e-b30c-933866586181
function invert(color::AbstractRGB)
	# your code here!
	return RGB(1-color.r, 1-color.g, 1-color.b)
end

# ╔═╡ 42eb04af-a22d-4aca-8434-d78e5d8ba771
color_black = RGB(0.0, 0.0, 0.0)

# ╔═╡ 4b17d9a7-c1a0-4b30-9356-27c55bb37a3a
invert(color_black)

# ╔═╡ 9455c53b-b457-4aab-970e-7cf76190829f
color_red = RGB(0.8, 0.1, 0.1)

# ╔═╡ b3e7c505-f9cb-4938-aab6-04377e5ca60c
invert(color_red)

# ╔═╡ 87bbde31-ebd4-4fd7-935b-ac502b1f7dc3
philip_inverted = invert.(philip)

# ╔═╡ ec62f192-037a-4928-86ad-408f00ddadf9
function quantize(x::Number)
	# your code here!
	return floor(x, digits=1)
end

# ╔═╡ fa024b0a-aa8a-4fd5-aafe-c7f7c2e3aac3
function quantize(color::AbstractRGB)
	# your code here!
	return RGB(quantize(color.r), quantize(color.g), quantize(color.b))
end

# ╔═╡ bf5b82e1-08be-4df1-b893-1656cfcbb4cc
function quantize(image::AbstractMatrix)
	# your code here!
	return quantize.(image)
end

# ╔═╡ d9e5fc4c-31a3-43d7-b983-9162fbe5901b
quantize(0.267), quantize(0.91)

# ╔═╡ adf006ab-904e-497f-9e5a-4e772ee755c9
quantize(philip)

# ╔═╡ fb83850e-a6aa-4d9c-a994-5504e440e4bb
function noisify(x::Number, s)
	# your code here!
	return x + s*(2rand() - 1)
end

# ╔═╡ edc19a72-2275-461f-9722-33d56093f8c2
function noisify(color::AbstractRGB, s)
	# your code here!
	return RGB(noisify(color.r, s), noisify(color.g, s), noisify(color.b, s))
end

# ╔═╡ 6b1efede-bef9-4c46-8a80-4b0d5a7e476b
@bind color_noise Slider(0:0.01:1, show_value=true)

# ╔═╡ c21eb808-0b73-46b6-a368-cb64452dabf0
function noisify(image::AbstractMatrix, s)
	# your code here!
	return noisify.(image, s)
end

# ╔═╡ 89385db8-bcab-42bf-bf63-ce86602e67bf
noisify(0.5, 0.1)

# ╔═╡ 6d7f56bc-050a-4bd1-ae9e-b375b32c04ae
(original=color_red, with_noise=noisify(color_red, color_noise))

# ╔═╡ 420673b5-6014-423d-9d20-90c75eacd818
[
	noisify(color_red, strength)
	for 
		strength in 0 : 0.05 : 1,
		row in 1:10
]'

# ╔═╡ 88ea7769-34c9-4d81-92b3-da43b4dd61c4
@bind philip_noise Slider(0:0.01:1, show_value=true)

# ╔═╡ ad2a5824-418f-45aa-ac4a-354dae6bc311
noisify(philip_head, philip_noise)

# ╔═╡ 9a86a593-ae94-43e4-a080-799ccf657705
answer_about_noise_intensity = md"""
The image is unrecognisable with intensity ...
"""

# ╔═╡ 37a75f5d-627f-4fc7-9b98-97510d61c288
# Camera input skipped

# ╔═╡ 9d575a35-4df0-40db-821e-a41cbfeb2b52
function custom_filter(pixel::AbstractRGB, m::AbstractRGB)
	
	# your code here!
	# "making the image less contrast, i.e. towards mean"
	new_pixel = RGB((pixel.r + m.r)/ 2, (pixel.g + m.g)/ 2, (pixel.b + m.b)/ 2)
	
	return new_pixel
end

# ╔═╡ 47cc7404-67b7-4426-84bd-ce3c02ae212a
function custom_filter(image::AbstractMatrix)
	
	return custom_filter.(image, mean_color(image))
end

# ╔═╡ 5218c4a7-94aa-49bb-ad55-c08a8d755be0
custom_filter(philip)

# ╔═╡ 62a72e43-2a5e-4330-a2b2-9cecd4cddc9e
custom_filter(custom_filter(philip))

# ╔═╡ Cell order:
# ╠═4af13574-68d3-48c1-9be7-bc8fc25923ad
# ╠═c1d53d59-78d1-46e4-a9db-53de75babd0d
# ╠═8e81a7df-91f3-4e0a-9e1e-0e47a6bfb17c
# ╠═f576f987-1cc0-467c-a758-dc6455b1c6fa
# ╠═f5122881-37b6-40c6-b2a3-d10201eb0732
# ╠═77d24198-1a31-4345-b23a-1d83789005db
# ╠═a62a49d9-2a2f-40b5-b5f0-e9e2f912098b
# ╠═0c6e7622-776f-464e-946c-8f18107bbb28
# ╠═e22f3fb1-72dc-4609-8468-b43e0deb2e09
# ╠═9094fb02-b878-40ed-9394-4524556475b2
# ╠═9abdf36a-c39b-4a75-a90e-2f4a09662a0e
# ╠═51cb0236-2f81-4bd9-8e96-e32d6d75964a
# ╠═3b59b485-bcd5-4950-a599-d7720e6a5208
# ╠═c6f24716-3f83-4e93-a10c-6bef320f33a7
# ╠═2fcf950d-9e0b-4f87-bffa-254ee20e7146
# ╠═1e2ef986-489e-423a-af2e-e70a7a47a347
# ╠═4e59aab3-e15e-410a-80ee-0d31473ce526
# ╠═cb47d58f-90c0-4a4f-9444-120b25f98d30
# ╠═500712f6-211d-4ed5-9f87-1a617efc0352
# ╠═8dab739c-3171-412b-8c73-8232a17fa08f
# ╠═91d3432a-92fd-4d18-ab05-ed8709df03df
# ╠═eefcd2d5-3910-4832-8fba-f9a31bd1dab5
# ╠═12601666-a842-4cef-aeb4-6df0ec7a3ec8
# ╠═c810f703-e608-439d-bb4b-ccc7b8627d14
# ╠═ecddcdd8-9e34-4913-8c71-40571ccbbe49
# ╠═e877e004-56d3-4fd3-adc7-39611cc5fd58
# ╠═c0b9dd9d-3a1f-4e83-adc3-4f4ebc7540ef
# ╠═acd8550d-ef0a-494a-b044-e1f0c1809cd6
# ╠═69b647fe-86ed-4603-9a69-285bbb672a5e
# ╠═73d839ce-070a-44d4-b3f8-65c22474a78a
# ╠═09e8e627-183b-47ec-ae6b-43c7507e571e
# ╠═d568a628-48b5-47d9-9a20-9174c651ab8e
# ╠═dc01dcf8-0428-4b42-b71c-80ae4d1fc04b
# ╠═d757a859-92bf-4184-b33e-896ef0855aa3
# ╠═4e786989-69f0-4bd2-857a-3a8ae8925397
# ╠═0f9669ec-6eac-4c3d-9c8e-b3eb38add584
# ╠═f556cce4-ea55-419e-b30c-933866586181
# ╠═42eb04af-a22d-4aca-8434-d78e5d8ba771
# ╠═4b17d9a7-c1a0-4b30-9356-27c55bb37a3a
# ╠═9455c53b-b457-4aab-970e-7cf76190829f
# ╠═b3e7c505-f9cb-4938-aab6-04377e5ca60c
# ╠═87bbde31-ebd4-4fd7-935b-ac502b1f7dc3
# ╠═ec62f192-037a-4928-86ad-408f00ddadf9
# ╠═d9e5fc4c-31a3-43d7-b983-9162fbe5901b
# ╠═fa024b0a-aa8a-4fd5-aafe-c7f7c2e3aac3
# ╠═bf5b82e1-08be-4df1-b893-1656cfcbb4cc
# ╠═adf006ab-904e-497f-9e5a-4e772ee755c9
# ╠═fb83850e-a6aa-4d9c-a994-5504e440e4bb
# ╠═89385db8-bcab-42bf-bf63-ce86602e67bf
# ╠═edc19a72-2275-461f-9722-33d56093f8c2
# ╠═6b1efede-bef9-4c46-8a80-4b0d5a7e476b
# ╠═6d7f56bc-050a-4bd1-ae9e-b375b32c04ae
# ╠═420673b5-6014-423d-9d20-90c75eacd818
# ╠═c21eb808-0b73-46b6-a368-cb64452dabf0
# ╠═88ea7769-34c9-4d81-92b3-da43b4dd61c4
# ╠═ad2a5824-418f-45aa-ac4a-354dae6bc311
# ╠═9a86a593-ae94-43e4-a080-799ccf657705
# ╠═37a75f5d-627f-4fc7-9b98-97510d61c288
# ╠═9d575a35-4df0-40db-821e-a41cbfeb2b52
# ╠═47cc7404-67b7-4426-84bd-ce3c02ae212a
# ╠═5218c4a7-94aa-49bb-ad55-c08a8d755be0
# ╠═62a72e43-2a5e-4330-a2b2-9cecd4cddc9e
