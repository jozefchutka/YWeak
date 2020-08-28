# YWeak

Utilizes WeakRef object to enable iteration with weak reference map.

Inspired by:
- [IterableWeakSet.js](https://gist.github.com/seanlinsley/bc10378fd311d75cf6b5e80394be813d)
- [IterableWeakMap.js](https://github.com/tc39/proposal-weakrefs)
- [ES6 Symbol.iterator in haxe](https://git.belin.io/cedx/webstorage.hx/src/branch/main/src/webstorage/WebStorage.hx)

## IterableWeakMap

Usage:
```
final map = new IterableWeakMap<MyObject, AnyType>();
```

1. Best performance with keyIterator
```
for(key in map.keyIterator())
```

2. Extra `get()` overhead for value iterator
```
for (value in map)
```

3. Extra `get()` and arbitrarty key/value pair/array object overhead for key/value iterator
```
for (key => value in map)
map.forEach(...)
map.find(...) // can be halted
```