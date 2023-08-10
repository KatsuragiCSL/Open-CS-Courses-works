### A Pluto.jl notebook ###
# v0.14.9

using Markdown
using InteractiveUtils

# ╔═╡ b3eb38b7-9747-4c31-a792-ebd4c9dcec73
import Pkg; Pkg.add("Colors");Pkg.add("Compose"); Pkg.add("Unicode")

# ╔═╡ 89dc129c-36c6-11ee-3426-c721c653eb2f
begin
	using Colors
	using PlutoUI
	using Compose
	using LinearAlgebra
	using Unicode
end

# ╔═╡ dfd90685-5153-403a-807c-2c2f997ec2dc
# Exercise 1

# ╔═╡ 8b853310-a8c4-4920-9665-56ab150564a6
alphabet = ['a':'z' ; ' ']

# ╔═╡ 3cfd10ab-d6f7-48b7-bed7-068248ebbdc1
samples = 
(English = "Although the word forest is commonly used, there is no universally recognised precise definition, with more than 800 definitions of forest used around the world.[4] Although a forest is usually defined by the presence of trees, under many definitions an area completely lacking trees may still be considered a forest if it grew trees in the past, will grow trees in the future,[9] or was legally designated as a forest regardless of vegetation type.[10][11] The word forest derives from the Old French forest (also forès), denoting \"forest, vast expanse covered by trees\"; forest was first introduced into English as the word denoting wild land set aside for hunting[14] without the necessity in definition of having trees on the land.[15] Possibly a borrowing, probably via Frankish or Old High German, of the Medieval Latin foresta, denoting \"open wood\", Carolingian scribes first used foresta in the Capitularies of Charlemagne specifically to denote the royal hunting grounds of the King. The word was not endemic to Romance languages, e. g. native words for forest in the Romance languages derived from the Latin silva, which denoted \"forest\" and \"wood(land)\" (confer the English sylva and sylvan); confer the Italian, Spanish, and Portuguese selva; the Romanian silvă; and the Old French selve, and cognates in Romance languages, e. g. the Italian foresta, Spanish and Portuguese floresta, etc., are all ultimately derivations of the French word.",
	
Spanish = "Un bosque es un ecosistema donde la vegetacion predominante la constituyen los arboles y matas.1\u200b Estas comunidades de plantas cubren grandes areas del globo terraqueo y funcionan como habitats para los animales, moduladores de flujos hidrologicos y conservadores del suelo, constituyendo uno de los aspectos mas importantes de la biosfera de la Tierra. Aunque a menudo se han considerado como consumidores de dioxido de carbono atmosferico, los bosques maduros son practicamente neutros en cuanto al carbono, y son solamente los alterados y los jovenes los que actuan como dichos consumidores.2\u200b3\u200b De cualquier manera, los bosques maduros juegan un importante papel en el ciclo global del carbono, como reservorios estables de carbono y su eliminacion conlleva un incremento de los niveles de dioxido de carbono atmosferico.\n\nLos bosques pueden hallarse en todas las regiones capaces de mantener el crecimiento de arboles, hasta la linea de arboles, excepto donde la frecuencia de fuego natural es demasiado alta, o donde el ambiente ha sido perjudicado por procesos naturales o por actividades humanas. Los bosques a veces contienen muchas especies de arboles dentro de una pequena area (como la selva lluviosa tropical y el bosque templado caducifolio), o relativamente pocas especies en areas grandes (por ejemplo, la taiga y bosques aridos montanosos de coniferas). Los bosques son a menudo hogar de muchos animales y especies de plantas, y la biomasa por area de unidad es alta comparada a otras comunidades de vegetacion. La mayor parte de esta biomasa se halla en el subsuelo en los sistemas de raices y como detritos de plantas parcialmente descompuestos. El componente lenoso de un bosque contiene lignina, cuya descomposicion es relativamente lenta comparado con otros materiales organicos como la celulosa y otros carbohidratos. Los bosques son areas naturales y silvestre \n")

# ╔═╡ df5fd294-0c14-46b2-af55-7e60ddf31406
function isinalphabet(text)
	return text in alphabet
end

# ╔═╡ bc95af69-578c-4046-b87d-90c2b304c107
isinalphabet('a'), isinalphabet('+')

# ╔═╡ 944c45a7-62e6-460e-bbd2-b1678ea58dbf
messy_sentence_1 = "#wow 2020 ¥500 (blingbling!)"

# ╔═╡ 598c5a02-58ac-428e-9692-2f0575dc555d
cleaned_sentence_1 = filter(isinalphabet, messy_sentence_1)

# ╔═╡ 1ed85c83-f882-4070-804b-4c3ce7e4c587
messy_sentence_2 = "Awesome! 😍"

# ╔═╡ dd84a1e2-a412-40bd-9e11-e71785c817c9
cleaned_sentence_2 = filter(isinalphabet, map(lowercase, messy_sentence_2))

# ╔═╡ 69fcfb4a-bac3-4fa2-b55e-3e13441c285e
function unaccent(str)
	return Unicode.normalize(str, stripmark=true)
end

# ╔═╡ 7a28027c-e35d-4b4b-b169-1b062f7ea82d
french_word = "Égalité!"

# ╔═╡ 994a1255-b881-42b2-83d9-b1ff8108e70c
unaccent(french_word)

# ╔═╡ 8ee63ee1-d634-4cbb-9a95-5ad9e00f1686
function clean(text)
	
	return filter(isinalphabet, map(lowercase, unaccent(text)))
end

# ╔═╡ 481ae6a5-542f-4e03-b923-2e3fb8145100
clean("Crème brûlée est mon plat préféré.")

# ╔═╡ 8a91bd85-91b1-4c13-9d68-611f59aecd31
first_sample = clean(first(samples))

# ╔═╡ d4c61044-9de3-4025-9be5-c24cc94e8299
function letter_frequencies(txt)
	ismissing(txt) && return missing
	f = count.(string.(alphabet), txt)
	f ./ sum(f)
end

# ╔═╡ aab90ec8-ee11-4b7c-8be0-e4e84d018dfb
sample_freqs = letter_frequencies(first_sample)

# ╔═╡ ba304903-c919-49c8-8329-d7e68f7fa0e0
index_of_letter(letter) = findfirst(isequal(letter), alphabet)

# ╔═╡ 93864e29-3e19-4d3f-9a23-b27b84ce475f
unused_letters = filter((letter) -> sample_freqs[index_of_letter(letter)] == 0, alphabet)

# ╔═╡ 6c98bee1-6506-4970-9075-f7a5d93d542c
function transition_counts(cleaned_sample)
	[count(string(a, b), cleaned_sample)
		for a in alphabet,
			b in alphabet]
end

# ╔═╡ fd3daad0-6ec2-4e70-9d67-39d131067ff2
normalize_array(x) = x ./ sum(x)

# ╔═╡ 72183e42-9b5d-448a-84ae-49540e905e93
transition_frequencies = normalize_array ∘ transition_counts;

# ╔═╡ b992bf65-d0cb-4c78-aa51-79cfe08c365a
transition_frequencies(first_sample)

# ╔═╡ d39204f3-151f-4d2c-b6b9-512608a35bc8
th_frequency = transition_frequencies(first_sample)[index_of_letter('t'), index_of_letter('h')]

# ╔═╡ 73f2688a-00fb-4e90-9aed-3132888087a4
ht_frequency = transition_frequencies(first_sample)[index_of_letter('h'), index_of_letter('t')]

# ╔═╡ 0f40a4b8-a560-4b87-a123-48e0a7c6189a
double_letters = filter((letter) -> transition_frequencies(first_sample)[index_of_letter(letter), index_of_letter(letter)] > 0, alphabet)

# ╔═╡ 38660813-f117-4c3d-8598-896f43c3bd18
mystery_sample = "Small boats are typically found on inland waterways such as rivers and lakes, or in protected coastal areas. However, some boats, such as the whaleboat, were intended for use in an offshore environment. In modern naval terms, a boat is a vessel small enough to be carried aboard a ship. Anomalous definitions exist, as lake freighters 1,000 feet (300 m) long on the Great Lakes are called \"boats\". \n"

# ╔═╡ 40ca2fca-9183-476a-a2cb-19ca4dae6ade
transition_frequencies(mystery_sample)

# ╔═╡ 955fd755-5793-4e72-8f60-5f6f9eeedc9a
function matrix_distance(A, B)
	
	return sum(abs.(A.-B))
end

# ╔═╡ c506faea-e073-492c-912e-29667fc12d2c
distances = (English = matrix_distance(transition_frequencies(samples[1]), transition_frequencies(mystery_sample)), Spanish = matrix_distance(transition_frequencies(samples[2]), transition_frequencies(mystery_sample)))

# ╔═╡ 8f846cad-ddb5-4e26-ac1e-e4118c169775
# Exercise 2

# ╔═╡ 91b560d5-100e-4525-a363-85f6783ce8e9
emma = let
	raw_text = read(download("https://ia800303.us.archive.org/24/items/EmmaJaneAusten_753/emma_pdf_djvu.txt"), String)
	
	first_words = "Emma Woodhouse"
	last_words = "THE END"
	start_index = findfirst(first_words, raw_text)[1]
	stop_index = findlast(last_words, raw_text)[end]
	
	raw_text[start_index:stop_index]
end;

# ╔═╡ 2b9dee35-8097-4eb0-8afd-ebdd2053c706
function splitwords(text)
	# clean up whitespace
	cleantext = replace(text, r"\s+" => " ")
	
	# split on whitespace or other word boundaries
	tokens = split(cleantext, r"(\s|\b)")
end

# ╔═╡ 59fffa37-4505-443d-94dc-373cf3147760
emma_words = splitwords(emma)

# ╔═╡ 0059572c-30f5-44eb-be62-75d6f259d5cd
forest_words = splitwords(samples.English)

# ╔═╡ 977d382d-bf7f-4358-a484-134af26f5585
function bigrams(words)
	starting_positions = 1:length(words)-1
	
	map(starting_positions) do i
		words[i:i+1]
	end
end

# ╔═╡ 60786c52-a538-4bd1-ae8d-0f021856a679
function ngrams(words, n)
	
	starting_positions = 1:length(words)-(n-1)
	
	map(starting_positions) do i
		words[i:i+(n-1)]
	end
end

# ╔═╡ 8edd98a8-6b97-408e-a85f-628c9a827698
ngrams([1, 2, 3, 42], 3)

# ╔═╡ 2d597d51-ecb9-45b1-a452-963352237339
ngrams([1, 2, 3, 42], 2) == bigrams([1, 2, 3, 42])

# ╔═╡ 6e00b822-9a4e-44e4-b8a0-83604fc0e6ab
ngrams([1, 2, 3, 42], 3)

# ╔═╡ 8d44c859-3b71-49ab-bf0f-ca6306325b80
ngrams(forest_words, 4)

# ╔═╡ 0a43c80c-2042-477e-addc-9afa4d401722
healthy = Dict("fruits" => ["🍎", "🍊"], "vegetables" => ["🌽", "🎃", "🍕"])

# ╔═╡ d8bfc089-2601-4ccb-80f3-56fb9a1120d6
healthy["fruits"]

# ╔═╡ 1360d965-085e-4050-8e54-b2418f8cc93d
function word_counts(words::Vector)
	counts = Dict()
	
	# your code here
	for word in words
		if haskey(counts, word)
			counts[word] += 1
		else
			counts[word] = 1
		end
	end
	return counts
end

# ╔═╡ 7641bd5c-ded8-456f-9378-5188a54b6982
word_counts(["to", "be", "or", "not", "to", "be"])

# ╔═╡ 1969bd6c-2ff1-461a-bd43-7754a143dad3
function completion_cache(grams)
	cache = Dict()
	
	# your code here
	n = length(grams[1])
	for ngram in grams
		if haskey(cache, ngram[1:n-1])
			if !(ngram[n] in cache[ngram[1:n-1]])
				push!(cache[ngram[1:n-1]], ngram[n])
			end
		else
			cache[ngram[1:n-1]] = [ngram[n]]
		end
	end
	cache
end

# ╔═╡ 2c0dbda2-e149-4dec-88bb-61e32ef06971
let
	trigrams = ngrams(split("to be or not to be that is the question", " "), 3)
	completion_cache(trigrams)
end

# ╔═╡ aadb2b1c-bbf4-4c76-980a-0eef2d3f80a5


# ╔═╡ da99d265-e110-41c6-bb15-4622441eb957
function generate_from_ngrams(grams, num_words)
	n = length(first(grams))
	cache = completion_cache(grams)
	
	# we need to start the sequence with at least n-1 words.
	# a simple way to do so is to pick a random ngram!
	sequence = [rand(grams)...]
	
	# we iteratively add one more word at a time
	for i ∈ n+1:num_words
		# the previous n-1 words
		tail = sequence[end-(n-2):end]
		
		# possible next words
		completions = cache[tail]
		
		choice = rand(completions)
		push!(sequence, choice)
	end
	sequence
end

# ╔═╡ ba6b9a54-a25b-4faa-81c5-9a4fef5d77bf
function generate(source_text::AbstractString, s; n=3, use_words=true)
	preprocess = if use_words
		splitwords
	else
		collect
	end
	
	words = preprocess(source_text)
	if length(words) < n
		""
	else
		grams = ngrams_circular(words, n)
		result = generate_from_ngrams(grams, s)
		if use_words
			join(result, " ")
		else
			String(result)
		end
	end
end

# ╔═╡ Cell order:
# ╠═89dc129c-36c6-11ee-3426-c721c653eb2f
# ╠═b3eb38b7-9747-4c31-a792-ebd4c9dcec73
# ╠═dfd90685-5153-403a-807c-2c2f997ec2dc
# ╠═8b853310-a8c4-4920-9665-56ab150564a6
# ╠═3cfd10ab-d6f7-48b7-bed7-068248ebbdc1
# ╠═df5fd294-0c14-46b2-af55-7e60ddf31406
# ╠═bc95af69-578c-4046-b87d-90c2b304c107
# ╠═944c45a7-62e6-460e-bbd2-b1678ea58dbf
# ╠═598c5a02-58ac-428e-9692-2f0575dc555d
# ╠═1ed85c83-f882-4070-804b-4c3ce7e4c587
# ╠═dd84a1e2-a412-40bd-9e11-e71785c817c9
# ╠═69fcfb4a-bac3-4fa2-b55e-3e13441c285e
# ╠═7a28027c-e35d-4b4b-b169-1b062f7ea82d
# ╠═994a1255-b881-42b2-83d9-b1ff8108e70c
# ╠═8ee63ee1-d634-4cbb-9a95-5ad9e00f1686
# ╠═481ae6a5-542f-4e03-b923-2e3fb8145100
# ╠═8a91bd85-91b1-4c13-9d68-611f59aecd31
# ╠═d4c61044-9de3-4025-9be5-c24cc94e8299
# ╠═aab90ec8-ee11-4b7c-8be0-e4e84d018dfb
# ╠═ba304903-c919-49c8-8329-d7e68f7fa0e0
# ╠═93864e29-3e19-4d3f-9a23-b27b84ce475f
# ╠═6c98bee1-6506-4970-9075-f7a5d93d542c
# ╠═fd3daad0-6ec2-4e70-9d67-39d131067ff2
# ╠═72183e42-9b5d-448a-84ae-49540e905e93
# ╠═b992bf65-d0cb-4c78-aa51-79cfe08c365a
# ╠═d39204f3-151f-4d2c-b6b9-512608a35bc8
# ╠═73f2688a-00fb-4e90-9aed-3132888087a4
# ╠═0f40a4b8-a560-4b87-a123-48e0a7c6189a
# ╠═38660813-f117-4c3d-8598-896f43c3bd18
# ╠═40ca2fca-9183-476a-a2cb-19ca4dae6ade
# ╠═955fd755-5793-4e72-8f60-5f6f9eeedc9a
# ╠═c506faea-e073-492c-912e-29667fc12d2c
# ╠═8f846cad-ddb5-4e26-ac1e-e4118c169775
# ╠═91b560d5-100e-4525-a363-85f6783ce8e9
# ╠═2b9dee35-8097-4eb0-8afd-ebdd2053c706
# ╠═59fffa37-4505-443d-94dc-373cf3147760
# ╠═0059572c-30f5-44eb-be62-75d6f259d5cd
# ╠═977d382d-bf7f-4358-a484-134af26f5585
# ╠═60786c52-a538-4bd1-ae8d-0f021856a679
# ╠═8edd98a8-6b97-408e-a85f-628c9a827698
# ╠═2d597d51-ecb9-45b1-a452-963352237339
# ╠═6e00b822-9a4e-44e4-b8a0-83604fc0e6ab
# ╠═8d44c859-3b71-49ab-bf0f-ca6306325b80
# ╠═0a43c80c-2042-477e-addc-9afa4d401722
# ╠═d8bfc089-2601-4ccb-80f3-56fb9a1120d6
# ╠═1360d965-085e-4050-8e54-b2418f8cc93d
# ╠═7641bd5c-ded8-456f-9378-5188a54b6982
# ╠═1969bd6c-2ff1-461a-bd43-7754a143dad3
# ╠═2c0dbda2-e149-4dec-88bb-61e32ef06971
# ╠═aadb2b1c-bbf4-4c76-980a-0eef2d3f80a5
# ╠═ba6b9a54-a25b-4faa-81c5-9a4fef5d77bf
# ╠═da99d265-e110-41c6-bb15-4622441eb957
