package yweak;

import haxe.Timer;
import js.lib.KeyValue;
import js.Syntax;

class IterableWeakSetTest
{
	public static function all()
	{
		final test = new IterableWeakSetTest();
		test.testAddHas();
		test.testSize();
		test.testDelete();
		test.testClear();
		test.testKeys();
		test.testValues();
		test.testEntries();
		test.testIterator();
		test.testForEach();
		test.testFind();
		test.testWeakness();
		test.testOptimize();
	}

	function new()
	{
	}
	
	function assert(result:Bool)
	{
		trace(result);
	}
	
	function testAddHas()
	{
		trace("testAddHas");
		final k1 = new MySetKey("1");
		final k2 = new MySetKey("2");
		final k3 = new MySetKey("3");
		final set1 = new IterableWeakSet<MySetKey>();
		final set2 = new IterableWeakSet<MySetKey>();
		set1.add(k1);
		set1.add(k2);
		set1.add(k3);
		set2.add(k1);
		set2.add(k2);
		assert(set1.has(k2));
		assert(set1.has(k1));
		assert(set1.has(k3));
		assert(set1.has(k2));
		assert(set2.has(k1));
		assert(set2.has(k2));
		assert(!set2.has(k3));
		assert(set2.has(k1));
	}
	
	function testSize()
	{
		trace("testSize");
		final k1 = new MySetKey("1");
		final k2 = new MySetKey("2");
		final k3 = new MySetKey("3");
		final set = new IterableWeakSet<MySetKey>();
		set.add(k1);
		set.add(k2);
		set.add(k3);
		assert(set.size == 3);
		set.delete(k2);
		assert(set.size == 2);
		set.clear();
		assert(set.size == 0);
	}
	
	function testDelete()
	{
		trace("testDelete");
		final k1 = new MySetKey("1");
		final k2 = new MySetKey("2");
		final k3 = new MySetKey("3");
		final set = new IterableWeakSet<MySetKey>();
		set.add(k1);
		set.add(k2);
		set.add(k3);
		set.delete(k1);
		set.delete(k3);
		assert(!set.has(k1));
		assert(set.has(k2));
		assert(!set.has(k3));
	}
	
	function testClear()
	{
		trace("testClear");
		final k1 = new MySetKey("1");
		final k2 = new MySetKey("2");
		final k3 = new MySetKey("3");
		final set = new IterableWeakSet<MySetKey>();
		set.add(k1);
		set.add(k2);
		set.add(k3);
		set.clear();
		assert(!set.has(k1));
		assert(!set.has(k2));
		assert(!set.has(k3));
		
		// clear recreates weakMap, so better check further apis
		set.add(k1);
		set.add(k2);
		final keys:Array<MySetKey> = [];
		for(key in set)
			keys.push(key);
		assert(keys.contains(k1));
		assert(keys.contains(k2));
		assert(!keys.contains(k3));
	}
	
	function testKeys()
	{
		trace("testKeys");
		final k1 = new MySetKey("1");
		final k2 = new MySetKey("2");
		final k3 = new MySetKey("3");
		final k4 = new MySetKey("4");
		final set = new IterableWeakSet<MySetKey>();
		set.add(k1);
		set.add(k2);
		set.add(k3);
		set.add(k4);
		set.delete(k3);
		final keys:Array<MySetKey> = Syntax.code("[...{0}()]", set.keys);
		assert(keys.length == 3);
		assert(keys.contains(k1));
		assert(keys.contains(k2));
		assert(!keys.contains(k3));
		assert(keys.contains(k4));
	}
	
	function testValues()
	{
		trace("testValues");
		final k1 = new MySetKey("1");
		final k2 = new MySetKey("2");
		final k3 = new MySetKey("3");
		final k4 = new MySetKey("4");
		final set = new IterableWeakSet<MySetKey>();
		set.add(k1);
		set.add(k2);
		set.add(k3);
		set.add(k4);
		set.delete(k2);
		final values:Array<MySetKey> = Syntax.code("[...{0}()]", set.values);
		assert(values.length == 3);
		assert(values.contains(k1));
		assert(!values.contains(k2));
		assert(values.contains(k3));
		assert(values.contains(k4));
	}
	
	function testEntries()
	{
		trace("testEntries");
		final k1 = new MySetKey("1");
		final k2 = new MySetKey("2");
		final k3 = new MySetKey("3");
		final k4 = new MySetKey("4");
		final set = new IterableWeakSet<MySetKey>();
		set.add(k1);
		set.add(k2);
		set.add(k3);
		set.add(k4);
		set.delete(k2);
		final values:Array<KeyValue<MySetKey, MySetKey>> = Syntax.code("[...{0}()]", set.entries);
		assert(values.length == 3);
		assert(values[0].key == k1);
		assert(values[0].value == k1);
		assert(values[1].key == k3);
		assert(values[1].value == k3);
		assert(values[2].key == k4);
		assert(values[2].value == k4);
	}
	
	function testIterator()
	{
		trace("testIterator");
		final k1 = new MySetKey("1");
		final k2 = new MySetKey("2");
		final k3 = new MySetKey("3");
		final k4 = new MySetKey("4");
		final set = new IterableWeakSet<MySetKey>();
		set.add(k1);
		set.add(k2);
		set.add(k3);
		set.add(k4);
		set.delete(k2);
		final values:Array<MySetKey> = [];
		for (value in set)
			values.push(value);
		assert(values.length == 3);
		assert(values.contains(k1));
		assert(values.contains(k3));
		assert(values.contains(k4));
	}
	
	function testForEach()
	{
		trace("testForEach");
		final k1 = new MySetKey("1");
		final k2 = new MySetKey("2");
		final k3 = new MySetKey("3");
		final k4 = new MySetKey("4");
		final set = new IterableWeakSet<MySetKey>();
		set.add(k1);
		set.add(k2);
		set.add(k3);
		set.add(k4);
		set.delete(k1);
		final values:Array<MySetKey> = [];
		set.forEach(function(value, key, set){
			values.push(value);
		});
		assert(values.length == 3);
		assert(values.contains(k2));
		assert(values.contains(k3));
		assert(values.contains(k4));
	}
	
	function testFind()
	{
		trace("testFind");
		final k1 = new MySetKey("1");
		final k2 = new MySetKey("2");
		final k3 = new MySetKey("3");
		final k4 = new MySetKey("4");
		final set = new IterableWeakSet<MySetKey>();
		set.add(k1);
		set.add(k2);
		set.add(k3);
		set.add(k4);
		final values:Array<MySetKey> = [];
		final result = set.find(function(value, key, set){
			values.push(value);
			return value == k3;
		});
		assert(values.length == 3);
		assert(values.contains(k1));
		assert(values.contains(k2));
		assert(values.contains(k3));
		assert(result == k3);
	}
	
	function testWeakness()
	{
		trace("testWeakness");
		final set = new IterableWeakSet<MySetKey>();
		final init = function(){
			final k1 = new MySetKey("1");
			final k2 = new MySetKey("2");
			set.add(k1);
			set.add(k2);
		}
		init();
		final k3 = new MySetKey("2");
		set.add(k3);
		final values:Array<MySetKey> = Syntax.code("[...{0}()]", set.values);
		assert(values.length == 3);
		assert(values.length == set.size);
		final timer = new haxe.Timer(1000);
		timer.run = function(){
			final keepK3 = k3; // hopefully k3 will not get GCed
			final values:Dynamic = Syntax.code("[...{0}()]", set.values);
			final count = values.length;
			if(count == 3)
				return trace("testWeakness: Waiting for GC. Enforce GC via dev tools.");
			trace("testWeakness timer");
			assert(count == 1);
			assert(set.size == count);
			timer.stop();
		};
	}
	
	function testOptimize()
	{
		trace("testOptimize");
		
		final set = new MySet<MySetKey>();
		final init = function(){
			final k1 = new MySetKey("1");
			final k2 = new MySetKey("2");
			final k3 = new MySetKey("3");
			final k4 = new MySetKey("4");
			set.add(k1);
			set.add(k2);
			set.add(k3);
			set.add(k4);
		}
		init();
		assert(set.refSetCount() == 4);
		final timer = new haxe.Timer(1000);
		timer.run = function(){
			final before = set.refSetCount();
			set.optimize();
			final after = set.refSetCount();
			if(before == 4 && after == 4)
				return trace("testOptimize: Waiting for GC. Enforce GC via dev tools.");
			trace("testOptimize timer");
			assert(before == 4 && after == 0);
			timer.stop();
		};
	}
}

class MySetKey
{
	public var name:String;
	public function new(name:String)
	{
		this.name = name;
	}
}

class MySet<T:{}> extends IterableWeakSet<T>
{
	public function refSetCount()
	{
		var count = 0;
		for (ref in refSet)
			count++;
		return count;
	}
}
