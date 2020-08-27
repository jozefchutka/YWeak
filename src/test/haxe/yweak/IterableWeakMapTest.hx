package yweak;

import haxe.Timer;

class IterableWeakMapTest
{
	public static function all()
	{
		final test = new IterableWeakMapTest();
		test.testSetGetExists();
		test.testRemove();
		test.testCopy();
		test.testClear();
		test.testKeys();
		test.testValues();
		test.testIterator();
		test.testKeyValueIterator();
		test.testForEach();
		test.testFind();
		test.testWeakness();
	}

	function new()
	{
	}
	
	function assert(result:Bool)
	{
		trace(result);
	}
	
	function testSetGetExists()
	{
		trace("testSetGetExists");
		final k1 = new MyKey("1");
		final k2 = new MyKey("2");
		final k3 = new MyKey("3");
		final map1 = new IterableWeakMap<MyKey, String>();
		final map2 = new IterableWeakMap<MyKey, String>();
		map1.set(k1, "1");
		map1.set(k2, "2");
		map1.set(k3, "3");
		map2.set(k1, "1");
		map2.set(k2, "2");
		assert(map1.get(k2) == "2");
		assert(map1.get(k1) == "1");
		assert(map1.get(k3) == "3");
		assert(map1.get(k2) == "2");
		assert(map2.get(k1) == "1");
		assert(map2.get(k2) == "2");
		assert(map2.get(k3) == null);
		assert(map2.exists(k1));
		assert(map2.exists(k2));
		assert(!map2.exists(k3));
	}
	
	function testRemove()
	{
		trace("testRemove");
		final k1 = new MyKey("1");
		final k2 = new MyKey("2");
		final k3 = new MyKey("3");
		final map = new IterableWeakMap<MyKey, String>();
		map.set(k1, "1");
		map.set(k2, "2");
		map.set(k3, "3");
		map.remove(k1);
		map.remove(k3);
		assert(!map.exists(k1));
		assert(map.exists(k2));
		assert(!map.exists(k3));
	}
	
	function testCopy()
	{
		trace("testCopy");
		final k1 = new MyKey("1");
		final k2 = new MyKey("2");
		final k3 = new MyKey("3");
		final map = new IterableWeakMap<MyKey, String>();
		map.set(k1, "1");
		map.set(k2, "2");
		map.set(k3, "3");
		map.remove(k3);
		final copy = map.copy();
		assert(copy.exists(k1));
		assert(copy.exists(k2));
		assert(!copy.exists(k3));
	}
	
	function testClear()
	{
		trace("testClear");
		final k1 = new MyKey("1");
		final k2 = new MyKey("2");
		final k3 = new MyKey("3");
		final map = new IterableWeakMap<MyKey, String>();
		map.set(k1, "1");
		map.set(k2, "2");
		map.set(k3, "3");
		map.clear();
		assert(!map.exists(k1));
		assert(!map.exists(k2));
		assert(!map.exists(k3));
		
		// clear recreates weakMap, so better check further apis
		map.set(k1, "1");
		map.set(k2, "2");
		final keys:Array<MyKey> = [];
		for(key in map.keys())
			keys.push(key);
		assert(keys.contains(k1));
		assert(keys.contains(k2));
		assert(!keys.contains(k3));
	}
	
	function testKeys()
	{
		trace("testKeys");
		final k1 = new MyKey("1");
		final k2 = new MyKey("2");
		final k3 = new MyKey("3");
		final k4 = new MyKey("4");
		final map = new IterableWeakMap<MyKey, String>();
		map.set(k1, "1");
		map.set(k2, "2");
		map.set(k3, "3");
		map.set(k4, "4");
		map.remove(k3);
		final keys:Array<MyKey> = [];
		for(key in map.keys())
			keys.push(key);
		assert(keys.contains(k1));
		assert(keys.contains(k2));
		assert(!keys.contains(k3));
		assert(keys.contains(k4));
	}
	
	function testValues()
	{
		trace("testValues");
		final k1 = new MyKey("1");
		final k2 = new MyKey("2");
		final k3 = new MyKey("3");
		final k4 = new MyKey("4");
		final map = new IterableWeakMap<MyKey, String>();
		map.set(k1, "1");
		map.set(k2, "2");
		map.set(k3, "3");
		map.set(k4, "4");
		map.remove(k2);
		final values = map.values();
		assert(values.length == 3);
		assert(values[0] == "1");
		assert(values[1] == "3");
		assert(values[2] == "4");
	}
	
	function testIterator()
	{
		trace("testIterator");
		final k1 = new MyKey("1");
		final k2 = new MyKey("2");
		final k3 = new MyKey("3");
		final k4 = new MyKey("4");
		final map = new IterableWeakMap<MyKey, String>();
		map.set(k1, "1");
		map.set(k2, "2");
		map.set(k3, "3");
		map.set(k4, "4");
		map.remove(k2);
		final values:Array<String> = [];
		for (value in map)
			values.push(value);
		assert(values.length == 3);
		assert(values[0] == "1");
		assert(values[1] == "3");
		assert(values[2] == "4");
	}
	
	function testKeyValueIterator()
	{
		trace("testKeyValueIterator");
		final k1 = new MyKey("1");
		final k2 = new MyKey("2");
		final k3 = new MyKey("3");
		final k4 = new MyKey("4");
		final map = new IterableWeakMap<MyKey, String>();
		map.set(k1, "1");
		map.set(k2, "2");
		map.set(k3, "3");
		map.set(k4, "4");
		map.remove(k1);
		final values:Array<String> = [];
		for (key => value in map)
		{
			assert(key.name == value);
			values.push(value);
		}
		assert(values.length == 3);
		assert(values[0] == "2");
		assert(values[1] == "3");
		assert(values[2] == "4");
	}
	
	function testForEach()
	{
		trace("testForEach");
		final k1 = new MyKey("1");
		final k2 = new MyKey("2");
		final k3 = new MyKey("3");
		final k4 = new MyKey("4");
		final map = new IterableWeakMap<MyKey, String>();
		map.set(k1, "1");
		map.set(k2, "2");
		map.set(k3, "3");
		map.set(k4, "4");
		map.remove(k1);
		final values:Array<String> = [];
		map.forEach(function(key, value){
			assert(key.name == value);
			values.push(value);
		});
		assert(values.length == 3);
		assert(values[0] == "2");
		assert(values[1] == "3");
		assert(values[2] == "4");
	}
	
	function testFind()
	{
		trace("testFind");
		final k1 = new MyKey("1");
		final k2 = new MyKey("2");
		final k3 = new MyKey("3");
		final k4 = new MyKey("4");
		final map = new IterableWeakMap<MyKey, String>();
		map.set(k1, "1");
		map.set(k2, "2");
		map.set(k3, "3");
		map.set(k4, "4");
		final values:Array<String> = [];
		map.find(function(key, value){
			assert(key.name == value);
			values.push(value);
			return value == "3";
		});
		assert(values.length == 3);
		assert(values[0] == "1");
		assert(values[1] == "2");
		assert(values[2] == "3");
	}
	
	function testWeakness()
	{
		trace("testWeakness");
		final map = new IterableWeakMap<MyKey, String>();
		final init = function(){
			final k1 = new MyKey("1");
			final k2 = new MyKey("2");
			map.set(k1, "1");
			map.set(k2, "2");
		}
		init();
		assert(map.values().length == 2);
		final timer = new haxe.Timer(1000);
		timer.run = function(){
			final count = map.values().length;
			if(count == 2)
				return trace("testWeakness: Waiting for GC. Enforce GC via dev tools.");
			assert(count == 0);
			timer.stop();
		};
	}
}

class MyKey
{
	public var name:String;
	public function new(name:String)
	{
		this.name = name;
	}
}
