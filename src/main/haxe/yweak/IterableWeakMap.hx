package yweak;

import js.lib.HaxeIterator;
import js.lib.Iterator;
import js.lib.KeyValue;
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

@:expose("IterableWeakMap") class IterableWeakMap<K:{}, V>
{
	var weakMap:WeakMap<{ref:WeakRef<K>, value:V}> = new WeakMap();
	final refSet = new Set();
	
	public function new(?source:HaxeIterator<KeyValue<K, V>>)
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
	
	public function has(key:K)
	{
		return weakMap.get(key) != null;
	}
	
	public function delete(key:K)
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

	/**
	  Function content is declared on prototype (inside `__init__()`)
	**/
	public function keys():Iterator<K>
	{
		return null;
	}
	
	/**
	  Function content is declared on prototype (inside `__init__()`)
	**/
	public function values():Iterator<V>
	{
		return null;
	}
	
	/**
	  Function content is declared on prototype (inside `__init__()`)
	**/
	public function entries():Iterator<KeyValue<K, V>>
	{
		return null;
	}
	
	public function iterator():HaxeIterator<V>
	{
		return new HaxeIterator(values());
	}
	
	public function keyValueIterator():HaxeIterator<KeyValue<K, V>>
	{
		return new HaxeIterator(entries());
	}
	
	public function forEach(callback:(value:V,key:K,map:IterableWeakMap<K,V>)->Void)
	{
		for (key => value in this)
			callback(value, key, this);
	}
	
	public function find(callback:(value:V,key:K,map:IterableWeakMap<K,V>)->Bool)
	{
		for (key => value in this)
			if (callback(value, key, this))
				break;
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
		for (ref in refSet)
			if(ref.deref() == null)
				refSet.delete(ref);
		//Syntax.code("for(const ref of {0})if(!ref.deref()){0}.delete(ref);", refSet);
	}
	
	/**
	  Provides ES6 iteration and key/value/entries array generators on prototype.
	**/
	static function __init__()
	{
		final proto = Syntax.field(IterableWeakMap, "prototype");
		
		Object.defineProperty(proto, Syntax.field(Symbol, "iterator"), {
			value: Syntax.code("function *(){for(const ref of this.refSet){const key=ref.deref();if(!key)continue;yield [key,this.get(key)];};}")});
			
		Object.defineProperty(proto, "keys", {
			value: Syntax.code("function *(){for(const ref of this.refSet){const key=ref.deref();if(!key)continue;yield key;};}")});
	
		Object.defineProperty(proto, "values", {
			value: Syntax.code("function *(){for(const ref of this.refSet){const key=ref.deref();if(!key)continue;yield this.get(key);};}")});
		
		Object.defineProperty(proto, "entries", {
			value: Syntax.code("function (){return this[Symbol.iterator]();}")});
	}
}
