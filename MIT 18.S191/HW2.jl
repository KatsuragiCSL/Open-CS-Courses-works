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

# ╔═╡ b93ae1b0-3509-11ee-3f5f-635e962fa71a
begin
	using Images, ImageIO, FileIO
	using PlutoUI
	using HypertextLiteral
	using OffsetArrays
end

# ╔═╡ ac8feb55-060a-43d1-bdb5-418116d1f1cf
n = 60

# ╔═╡ 46042aa5-f24e-4727-b4f8-60ff363cfdf2
v = rand(n)

# ╔═╡ b3b68f8f-a025-42da-a96e-becee9a179f0
function extend(v::AbstractVector, i)
	if (i <= length(v) && i >= 1)
		return v[i]
	elseif i < 1
		return v[1]
	else
		return v[length(v)]
	end
end

# ╔═╡ c21406be-dcff-48c4-848a-526d575a4df9
example_vector = [0.8, 0.2, 0.1, 0.7, 0.6, 0.4]

# ╔═╡ 79cb0a7e-2edc-42a0-8ff0-14b0eba41b8e
Gray.(example_vector)

# ╔═╡ 7a5b4eb3-a0ed-4664-b5a9-c38378df1473
function my_sum(xs)
	# your code here!
	sum = 0
	for x in xs
		sum += x
	end
	return sum
end

# ╔═╡ 67b260db-997d-4ae8-8ab8-659935b4be27
function mean(xs)
	# your code here!
	sum = my_sum(xs)
	l = length(xs)
	return sum / l
end

# ╔═╡ c0e9aa6e-d837-464f-b1e5-e91966294181
Gray.(v)

# ╔═╡ 0e8e4c7c-d863-45e9-beb5-1b340cb7ccb3
function box_blur_kernel(l)
	window = (l - 1) ÷ 2
	k = [1/l for _ in 1:l]
	offset_k = OffsetArray(k, -window:window)
	return offset_k
end

# ╔═╡ a7da6019-ef3b-4a35-a3e8-82307626f8f6
box_blur_kernel_test = box_blur_kernel(3)

# ╔═╡ e47a1f8a-75fd-4e84-a3d9-2572657092e7
function gauss(x, s)
	return 1 / sqrt(2π*s^2) * exp(-x^2 / (2 * s^2))
end

# ╔═╡ d0a494e9-86c1-44da-b364-c0dba0c32306
@bind gaussian_kernel_size_1D Slider(0:6)

# ╔═╡ 587558a3-5b07-4062-a0b4-1b369d618605
# Exercise 2

# ╔═╡ 15bbd0df-8cf2-45f4-b6e2-fdf2e99b1abe
function extend(M::AbstractMatrix, i, j)
	num_rows, num_columns = size(M)
	
	if i < 1
		if j < 1
			return M[1, 1]
		elseif j > num_columns
			return M[1,num_columns]
		else
			return M[1, j]
		end
	elseif i > num_rows
		if j < 1
			return M[num_rows, 1]
		elseif j > num_columns
			return M[num_rows, num_columns]
		else
			return M[num_rows, j]
		end
	else
		if j < 1
			return M[i, 1]
		elseif j > num_columns
			return M[i, num_columns]
		else
			return M[i, j]
		end
		
	end
	return missing
end

# ╔═╡ 94c3ceb2-0144-42bb-88c3-11b535a51c1e
extend([5,6,7], 1)

# ╔═╡ 4899cd48-945c-47f7-a3b6-c36cff27d80f
extend([5,6,7], -8)

# ╔═╡ cb31a9be-e1df-42c6-8fc4-58993eb25ce5
extend([5,6,7], 10)

# ╔═╡ e05e9e0a-5bd9-44e9-898d-4d0963e5cbd4
function box_blur(v::AbstractArray, l)
	new_arr = [mean([extend(v, i+k) for k in -l:l]) for i in 1:length(v)]
	return new_arr
end

# ╔═╡ be37137c-e5fb-4155-a1d7-db23b09a8994
Gray.(box_blur(example_vector, 1))

# ╔═╡ f96ab514-eb28-4de2-b15b-51cc2354f53f
Gray.(box_blur(v, 1))

# ╔═╡ f5d05a98-38a9-49ef-a861-1d3e7f24c5fe
function convolve(v::AbstractVector, k)
	l = length(k)
	window = (l - 1) ÷ 2
	offset_k = OffsetArray(k, -window:window)
	new_arr = [sum([extend(v, i+j) * offset_k[j] for j in -window:window]) for i in 1:length(v)]
	return new_arr
end

# ╔═╡ 51d2bbe6-e76b-4053-ac5a-bd98590b8ed3
small_image = Gray.(rand(5,5))

# ╔═╡ bf7157fa-e5b3-44a4-8bb8-c3714809a609
url = "https://user-images.githubusercontent.com/6933510/107239146-dcc3fd00-6a28-11eb-8c7b-41aaf6618935.png" 

# ╔═╡ e0a0ffb6-9c0d-44a4-8fa1-c96812e95251
philip_filename = download(url)

# ╔═╡ b2a929a8-ec6a-4d68-9f4e-905bcc20364e
philip = load(philip_filename);

# ╔═╡ a5658d09-eb83-421e-92c0-83f045c2b845
philip_head = philip[470:800, 140:410];

# ╔═╡ 9dcd3da6-75bc-461e-8a29-d12d33fbdc5d
[
	extend(philip_head, i, j) for 
		i in -50:size(philip_head,1)+51,
		j in -50:size(philip_head,2)+51
]

# ╔═╡ dff5051c-ee85-4105-9d2a-672e5385b431
function convolve(M::AbstractMatrix, K::AbstractMatrix)
	R, C = size(M)
	num_rows, num_columns = size(K)
	window_rows = (num_rows-1)÷2
	window_columns = (num_columns-1)÷2
	new_arr = 
	[
		sum([
				extend(M, i, j) for 
				i in r-window_rows:r+window_rows,
				j in c-window_columns:c+window_columns
			] .* K)
		for r in 1:R,
			c in 1:C
	]

	return new_arr
end

# ╔═╡ f3b0b72f-8d97-4dda-901d-ebafc51b60dd
test_convolution = let
	v = [1, 10, 100, 1000, 10000]
	k = [1, 1, 0]
	convolve(v, k)
end

# ╔═╡ 73555f64-8074-4978-9acf-8e8ce4a6109c
let
	result = convolve(v, box_blur_kernel_test)
	Gray.(result)
end

# ╔═╡ 72f48470-b658-4553-ab5e-f36111544861
K_test = [
	0   0  0
	1/2 0  1/2
	0   0  0
]

# ╔═╡ 1b64b436-c19b-4d81-a625-b9f9e02f3647
convolve(philip_head, K_test)

# ╔═╡ c8c66b3b-c108-49fd-9d19-f763662520c9
function gauss(x, y, σ=1)
	return 2π*σ^2 * gauss(x; σ=σ) * gauss(y; σ=σ)
end

# ╔═╡ e9b09af7-c5c8-4b5b-959c-820444558a42
function gaussian_kernel_1D(n, σ)
	gauss_arr = [gauss(i, σ) for i in -n:n]
	gauss_arr = gauss_arr ./ sum(gauss_arr)
	offset_gauss = OffsetArray(gauss_arr, -n:n)
	return gauss_arr
end

# ╔═╡ 087a3416-321f-4921-96e3-350f80c47205
Gray.(gaussian_kernel_1D(4, 1))

# ╔═╡ 720912ba-b4cb-4d2b-9fc8-a08dc6edd546
test_gauss_1D_a = let
	k = gaussian_kernel_1D(gaussian_kernel_size_1D, 1)
	
	if k !== missing
		convolve(v, k)
	end
end

# ╔═╡ 0ea9ffd2-7e56-4ea2-88c8-6232895b6827
Gray.(test_gauss_1D_a)

# ╔═╡ e4ba39cb-f4ed-4dac-af7e-62dcd4e0e59c
function gaussian_kernel_2D(σ, l)
	gauss_arr = [gauss(i, j, σ) for i in -l:l, j in -l:l]
	gauss_arr = gauss_arr ./ sum(gauss_arr)
	offset_gauss = OffsetArray(gauss_arr, -l:l)
	return gauss_arr
end

# ╔═╡ 547fafa9-a91d-41bc-b379-36847aba15d6
function with_gaussian_blur(image; σ=3, l=5)
	gauss_kernel = gaussian_kernel_2D(σ, l)
	return convolve(image, gauss_kernel)
end

# ╔═╡ 0375c621-d752-45c1-b226-1ee84f0067c4
sobel_x = [1 0 -1; 2 0  -2; 1 0 -1]

# ╔═╡ 499b2d70-a10f-4949-ba40-05986e79f6e1
sobel_y = sobel_x'

# ╔═╡ f915b5e9-2b9d-47e8-8753-e855b14c6d7e
sobel_kernel = sqrt.(sobel_x.^2 + sobel_y.^2)

# ╔═╡ 77cee19d-3949-4a8c-aa95-d17dda408943
function with_sobel_edge_detect(image)
	return convolve(image, sobel_kernel)
end

# ╔═╡ 53a2ddce-8ba2-49e9-b7ec-ba28e8ec1be1
Gray.(with_sobel_edge_detect(philip_head))

# ╔═╡ Cell order:
# ╠═b93ae1b0-3509-11ee-3f5f-635e962fa71a
# ╠═ac8feb55-060a-43d1-bdb5-418116d1f1cf
# ╠═46042aa5-f24e-4727-b4f8-60ff363cfdf2
# ╠═b3b68f8f-a025-42da-a96e-becee9a179f0
# ╠═94c3ceb2-0144-42bb-88c3-11b535a51c1e
# ╠═4899cd48-945c-47f7-a3b6-c36cff27d80f
# ╠═cb31a9be-e1df-42c6-8fc4-58993eb25ce5
# ╠═c21406be-dcff-48c4-848a-526d575a4df9
# ╠═79cb0a7e-2edc-42a0-8ff0-14b0eba41b8e
# ╠═7a5b4eb3-a0ed-4664-b5a9-c38378df1473
# ╠═67b260db-997d-4ae8-8ab8-659935b4be27
# ╠═e05e9e0a-5bd9-44e9-898d-4d0963e5cbd4
# ╠═be37137c-e5fb-4155-a1d7-db23b09a8994
# ╠═c0e9aa6e-d837-464f-b1e5-e91966294181
# ╠═f96ab514-eb28-4de2-b15b-51cc2354f53f
# ╠═f5d05a98-38a9-49ef-a861-1d3e7f24c5fe
# ╠═f3b0b72f-8d97-4dda-901d-ebafc51b60dd
# ╠═0e8e4c7c-d863-45e9-beb5-1b340cb7ccb3
# ╠═a7da6019-ef3b-4a35-a3e8-82307626f8f6
# ╠═73555f64-8074-4978-9acf-8e8ce4a6109c
# ╠═e47a1f8a-75fd-4e84-a3d9-2572657092e7
# ╠═e9b09af7-c5c8-4b5b-959c-820444558a42
# ╠═087a3416-321f-4921-96e3-350f80c47205
# ╠═d0a494e9-86c1-44da-b364-c0dba0c32306
# ╠═0ea9ffd2-7e56-4ea2-88c8-6232895b6827
# ╠═720912ba-b4cb-4d2b-9fc8-a08dc6edd546
# ╠═587558a3-5b07-4062-a0b4-1b369d618605
# ╠═15bbd0df-8cf2-45f4-b6e2-fdf2e99b1abe
# ╠═51d2bbe6-e76b-4053-ac5a-bd98590b8ed3
# ╠═bf7157fa-e5b3-44a4-8bb8-c3714809a609
# ╠═e0a0ffb6-9c0d-44a4-8fa1-c96812e95251
# ╠═b2a929a8-ec6a-4d68-9f4e-905bcc20364e
# ╠═a5658d09-eb83-421e-92c0-83f045c2b845
# ╠═9dcd3da6-75bc-461e-8a29-d12d33fbdc5d
# ╠═dff5051c-ee85-4105-9d2a-672e5385b431
# ╠═72f48470-b658-4553-ab5e-f36111544861
# ╠═1b64b436-c19b-4d81-a625-b9f9e02f3647
# ╠═c8c66b3b-c108-49fd-9d19-f763662520c9
# ╠═e4ba39cb-f4ed-4dac-af7e-62dcd4e0e59c
# ╠═547fafa9-a91d-41bc-b379-36847aba15d6
# ╠═0375c621-d752-45c1-b226-1ee84f0067c4
# ╠═499b2d70-a10f-4949-ba40-05986e79f6e1
# ╠═f915b5e9-2b9d-47e8-8753-e855b14c6d7e
# ╠═77cee19d-3949-4a8c-aa95-d17dda408943
# ╠═53a2ddce-8ba2-49e9-b7ec-ba28e8ec1be1
