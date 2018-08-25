# Current State

I've created tests for the first round of specs. The way the specs read, we just use the line...
```
dictionary = File.read("/usr/share/dict/words")
```
... to get our word list.

It returns a single huge string partitioned by "\n". This is the intended
input for `completion.populate(dictionary)`. We don't need to worry about that quite yet, but it seems like we'll only need the CompleteMe class, and perhaps a `Node` (or `Trie` might be better) class to start.
