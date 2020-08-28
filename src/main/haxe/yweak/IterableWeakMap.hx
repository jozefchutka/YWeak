package yweak;

import js.lib.HaxeIterator;
import js.lib.Iterator;
import js.lib.KeyValue;
import js.lib.Object;
import js.lib.Set;
import js.lib.Symbol;
import js.lib.WeakMap;
import js.Syntax;

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

	/** Function content is declared on prototype (inside `__init__()`) **/
	public function keys():Iterator<K> return null;
	
	/** Function content is declared on prototype (inside `__init__()`) **/
	public function values():Iterator<V> return null;
	
	/** Function content is declared on prototype (inside `__init__()`) **/
	public function entries():Iterator<KeyValue<K, V>> return null;
	
	public function keyIterator():HaxeIterator<K>
	{
		return new HaxeIterator(keys());
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
		Syntax.code("for(const [key, value] of {0}){1}(value, key, {0});", this, callback);
	}
	
	public function find(callback:(value:V,key:K,map:IterableWeakMap<K,V>)->Bool):K
	{
		Syntax.code("for(const [key, value] of {0})if({1}(value, key, {0}))return key;", this, callback);
		return null;
	}
	
	/** Removes empty WeakRef-s from reference set. **/
	public function optimize()
	{
		Syntax.code("for(const ref of {0})if(!ref.deref()){0}.delete(ref);", refSet);
	}
	
	/** Declares ES6 iteration and key/value/entries array generators on prototype. **/
	static function __init__()
	{
		final proto = Syntax.field(IterableWeakMap, "prototype");
		
		Object.defineProperty(proto, Syntax.field(Symbol, "iterator"), {
			value: Syntax.code("function *(){for(const ref of this.refSet){const key=ref.deref();if(key)yield [key,this.get(key)];};}")});
			
		Object.defineProperty(proto, "keys", {
			value: Syntax.code("function *(){for(const ref of this.refSet){const key=ref.deref();if(key)yield key;};}")});
	
		Object.defineProperty(proto, "values", {
			value: Syntax.code("function *(){for(const ref of this.refSet){const key=ref.deref();if(key)yield this.get(key);};}")});
		
		Object.defineProperty(proto, "entries", {
			value: Syntax.code("function (){return this[Symbol.iterator]();}")});
	}
}
