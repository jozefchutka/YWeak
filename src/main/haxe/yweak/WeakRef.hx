package yweak;

/**
	https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakRef
**/
@:native("WeakRef")
extern class WeakRef<T> {
	@:pure function new(?iterable:Any);

	/**
		Returns the `WeakRef` object's target object, or `undefined` if the target object has been reclaimed.
	**/
	@:pure function deref():T;
}
