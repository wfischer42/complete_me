# Complete Me: A Ruby Autocomplete
#### Preston and William

This autocomplete class can hold multiple dictionaries in different Tries, allowing the user to contextually select from a variety of types of information. For instance, a single instance can be used to autocomplete either words or addresses depending on your needs. Or it could be used to separate addresses in different areas, and load suggestions from the list closest to the client.

An instance has "words" and "addresses" tries by default (though un-populated initially)

To setup a new instance of the class from the default dictionary on MacOS, use:
```
completion = CompleteMe.new
completion.populate
```

Here's how you would create a trie of addresses (data provided) in Denver from a CSV file.
```
file = "./data/addresses.csv"
header = "FULL_ADDRESS"
completion.populate(file, csv_header: header, trie_name: "addresses")
```

Operations are performed on the @default trie unless otherwise specified with `(trie_name: "some trie)` as a parameter. The default trie, (which is "words" by default) can be set upon initializing with
```
completion = CompleteMe.new("addresses")
```
It can also be changed with...

```
completion.default = "actor names"
```

To get a list of suggestions from a snippet of text...
```
suggestions = @completion.suggest("piz")
```
This will return a list of strings with 'piz' present.

To register a selection so future suggestions can be ranked based on historical choices, use...

```
completion.select("piz", "pizza")
```
After that, pizza will be a priority result for the snippet "piz".

Words can also be deleted (which doesn't truly delete them from the data-set) and deletions can be reset/undone (in case you change your mind).
