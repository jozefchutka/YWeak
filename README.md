# YWeak

Utilizes WeakRef object to enable iteration with weak reference map.

Required ES6 & WeakRef, WeakMap, WeakSet objects available in runtime;

Inspired by:
- [IterableWeakSet.js](https://gist.github.com/seanlinsley/bc10378fd311d75cf6b5e80394be813d)
- [IterableWeakMap.js](https://github.com/tc39/proposal-weakrefs)
- [ES6 Symbol.iterator in haxe](https://git.belin.io/cedx/webstorage.hx/src/branch/main/src/webstorage/WebStorage.hx)

## Implementations

### [IterableWeakMap](src/main/haxe/yweak/IterableWeakMap.hx)

Usage:
```
final map = new IterableWeakMap<MyObject, AnyType>();
```

1. Best performance with keyIterator
```
for (key in map.keyIterator())
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


### [IterableWeakSet](src/main/haxe/yweak/IterableWeakSet.hx)

Usage:
```
final set = new IterableWeakSet<MyObject>();
```

1. Best performance with keyIterator
```
for (key in set)
```

2. Extra arbitrarty key/value pair/array object overhead for key/value iterator
```
for (key => value in set)
set.forEach(...)
set.find(...) // can be halted
```

## Test

Primitive unit tests are available to run in browser console. Execute `haxe text.hxml` and open [src/test/resources/index.html](src/test/resources/index.html) in browser.

## Release

1. update version in [haxelib.json](src/main/haxe/haxelib.json)
2. commit
3. navigate to `src/main/haxe`
3. execute `haxelib submit` , enter package "." if requested
