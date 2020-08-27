package yweak;

import haxe.iterators.ArrayIterator;
import haxe.iterators.MapKeyValueIterator;
import js.lib.Object;
import js.lib.Set;
import js.lib.Symbol;
import js.lib.WeakMap;
import js.Syntax;

/**
  Utilizes WeakRef object to enable iteration with weak reference map.
  
  Inspired by:
  IterableWeakSet.js
  https://gist.github.com/seanlinsley/bc10378fd311d75cf6b5e80394be813d
  
  IterableWeakMap.js
  https://github.com/tc39/proposal-weakrefs
 
  ES6 Symbol.iterator in haxe
  https://git.belin.io/cedx/webstorage.hx/src/branch/main/src/webstorage/WebStorage.hx
**/

@:expose("IterableWeakMap") class IterableWeakMap<K:{}, V> implements haxe.Constraints.IMap<K, V>
{
	inline static var PROPERTY_KEYS = "_keys";
	inline static var PROPERTY_VALUES = "_values";
	
	var weakMap:WeakMap<{ref:WeakRef<K>, value:V}> = new WeakMap();
	final refSet = new Set();
	
	public function new(?source:KeyValueIterator<K, V>)
	{
		if (source != null)
			for (key => value in source)
				set(key, value);
	}

	@:keep public function set(key:K, value:V)
	{
		final ref = new WeakRef<K>(key);
		refSet.add(ref);
		weakMap.set(key, {value:value, ref:ref});
	}
	
	@:keep public function get(key:K)
	{
		final entry = weakMap.get(key);
		return entry != null ? entry.value : null;
	}
	
	public function exists(key:K)
	{
		return weakMap.get(key) != null;
	}
	
	public function remove(key:K)
	{
		final entry = weakMap.get(key);
		if (entry == null)
			return false;
		
		weakMap.delete(key);
		refSet.delete(entry.ref);
		return true;
	}
	
	public function copy()
	{
		return new IterableWeakMap(keyValueIterator());
	}
	
	public function clear()
	{
		refSet.clear();
		weakMap = new WeakMap();
	}

	public function keys():ArrayIterator<K>
	{
		return new ArrayIterator(Syntax.code("[...{0}[{1}]]", this, PROPERTY_KEYS));
	}
	
	public function values():Array<V>
	{
		return Syntax.code("[...{0}[{1}]]", this, PROPERTY_VALUES);
	}
	
	public function iterator()
	{
		return new ArrayIterator(values());
	}
	
	public function keyValueIterator()
	{
		return new MapKeyValueIterator(this);
	}
	
	/**
	  Executes native iteration without arbitrary array in process.
	**/
	public function forEach(callback:K->V->Void)
	{
		Syntax.code("for(const ref of {0}){const key=ref.deref();if(key){1}(key, {2}(key))}", refSet, callback, get);
	}
	
	/**
	  Executes native iteration without arbitrary array in process.
	**/
	public function find(callback:K->V->Void)
	{
		Syntax.code("for(const ref of {0}){const key=ref.deref();if(key)if({1}(key, {2}(key)))break;}", refSet, callback, get);
	}
	
	public function toString()
	{
		var result = "{";
		for (key => value in this)
			result += Std.string(key) + " => " + Std.string(value) + ", ";
		return result + "}";
	}
	
	/**
	  Removes empty WeakRef-s from reference set.
	**/
	public function optimize()
	{
		Syntax.code("for(const ref of {0})if(!ref.deref()){0}.delete(ref);", refSet);
	}
	
	/**
	  Provides ES6 iteration and key/value array generators on prototype.
	**/
	static function __init__()
	{
		final proto = Syntax.field(IterableWeakMap, "prototype");
		
		Object.defineProperty(proto, Syntax.field(Symbol, "iterator"), {
			value: Syntax.code("function *(){for(const ref of this.refSet){const key=ref.deref();if(!key)continue;yield key;};}")});
	
		Object.defineProperty(proto, PROPERTY_KEYS, {
			get: Syntax.code("function *(){for(const key of this)yield key;}")});
	
		Object.defineProperty(proto, PROPERTY_VALUES, {
			get: Syntax.code("function *(){for(const key of this)yield this.get(key);}")});
	}
}
