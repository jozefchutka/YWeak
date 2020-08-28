package yweak;

import js.lib.HaxeIterator;
import js.lib.Iterator;
import js.lib.KeyValue;
import js.lib.Object;
import js.lib.Set;
import js.lib.Symbol;
import js.lib.WeakMap;
import js.Syntax;

@:expose("IterableWeakSet") class IterableWeakSet<T:{}>
{
	public var size(get, never):Int;
	
	var weakMap:WeakMap<WeakRef<T>> = new WeakMap();
	final refSet:Set<WeakRef<T>> = new Set();
	
	public function new()
	{
	}
	
	function get_size()
	{
		Syntax.code("let c=0;for(const ref of {0})if(ref.deref())c++;return c;", refSet);
		return 0;
	}

	@:keep public function add(value:T)
	{
		final ref = new WeakRef<T>(value);
		refSet.add(ref);
		weakMap.set(value, ref);
	}
	
	public function has(value:T)
	{
		return weakMap.get(value) != null;
	}
	
	public function delete(value:T)
	{
		final ref = weakMap.get(value);
		if (ref == null)
			return false;
		
		weakMap.delete(value);
		refSet.delete(ref);
		return true;
	}
	
	public function clear()
	{
		refSet.clear();
		weakMap = new WeakMap();
	}

	/** Function content is declared on prototype (inside `__init__()`) **/
	public function keys():Iterator<T> return null;
	
	/** Function content is declared on prototype (inside `__init__()`) **/
	public function values():Iterator<T> return keys();
	
	/** Function content is declared on prototype (inside `__init__()`) **/
	public function entries():Iterator<KeyValue<T, T>> return null;
	
	public function iterator():HaxeIterator<T>
	{
		return new HaxeIterator(values());
	}
	
	public function forEach(callback:(value:T,key:T,map:IterableWeakSet<T>)->Void)
	{
		Syntax.code("for(const key of {0}()){1}(key, key, {0});", keys, callback);
	}
	
	public function find(callback:(value:T,key:T,map:IterableWeakSet<T>)->Bool):T
	{
		Syntax.code("for(const key of {0}())if({1}(key, key, {0}))return key;", keys, callback);
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
		Object.defineProperty(
			Syntax.field(IterableWeakSet, "prototype"),
			Syntax.field(Symbol, "iterator"),
			{value: Syntax.code("function *(){for(const ref of this.refSet){const key=ref.deref();if(key)yield [key,key];};}")});
			
		Object.defineProperty(
			Syntax.field(IterableWeakSet, "prototype"),
			"keys",
			{value: Syntax.code("function *(){for(const ref of this.refSet){const key=ref.deref();if(key)yield key;};}")});
		
		Object.defineProperty(
			Syntax.field(IterableWeakSet, "prototype"),
			"entries",
			{value: Syntax.code("function (){return this[Symbol.iterator]();}")});
	}
}
