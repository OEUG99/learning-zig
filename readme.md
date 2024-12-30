# This is a repo fior all the basic code I write while trying to learn zig.

- much of these notes are taken from: https://zig.guide/language-basics/defer
- ## Syntax
	- ### Assignment
		- You can assign with `const` or `var`, and type is defined after the variable name, as such:
			-
			  ```zig
			  const x: i32 = 5;
			  var y: i32 = 2;
			  ```
			- `const`  and `var` must always have a value. If no value can be given, the `undefined` value can be used, it coerces to any type. See example:
				-
				  ```zig
				  const a: i32 = undefined;
				  var b: u32 = undefined;
				  ```
			- Where possible, `const` values are preffered over `var`
	- ## Arrays
		- Arrays are denoted as `[N]T` where `N` is the number of elements, and `T` is the type of those elements.
		- We can use `_` when we define an array with elements inside of it IF we want to define the size of the array based on the initial number of elements.
			-
			  ```zig
			  const a = [5]u8{ 'H', 'I'};
			  const b = [_]u8{'B', 'Y', 'E'};
			  ```
		- To get the size of any array, we can use the `len` field.
			-
			  ```zig
			  const array = [_]u8{ 'h', 'e', 'l', 'l', 'o' };
			  const length = array.len; // 5
			  ```
	- ## If-Expressions
		- If statements in zig work as you would expect, except they must resolve to `bool` meaning no implicity is possible.
			-
			  ```zig
			  const expect = @import("std").testing.expect;

			  test "if statement" {
			      const a = true;
			      var x: u16 = 0;
			      if (a) {
			          x += 1;
			      } else {
			          x += 2;
			      }
			      try expect(x == 1);
			  }
			  ```
		- If statements can also be used as expressions:
			-
			  ```zig
			  test "if statement expression" {
			      const a = true;
			      var x: u16 = 0;
			      x += if (a) 1 else 2;
			      try expect(x == 1);
			  }
			  ```
	- ## While Loops
		- while loops in zig have three parts - a condition, a block, and a continue expression
			- with out a continue expression:
			  ```zig
			  test "while" {
			      var i: u8 = 2;
			      while (i < 100) {
			          i *= 2;
			      }
			      try expect(i == 128);
			  }
			  ```
			- with a continue expression:
			  ```zig
			  test "while with continue expression" {
			      var sum: u8 = 0;
			      var i: u8 = 1;
			      while (i <= 10) : (i += 1) {
			          sum += i;
			      }
			      try expect(sum == 55);
			  }
			  ```
			- with a break:
			  ```zig
			  test "while with break" {
			      var sum: u8 = 0;
			      var i: u8 = 0;
			      while (i <= 3) : (i += 1) {
			          if (i == 2) break;
			          sum += i;
			      }
			      try expect(sum == 1);
			  }
			  ```
	- ## For Loops
		- For loops are very similar to other languages in Zig.
			- ### Simple Range Loops
				-
				  ```zig
				  const std = @import("std");

				  pub fn main() void {
				      for (1..5) |i| {
				          std.debug.print("{}\n", .{i});
				      }
				  }
				  ```
			- ### Iterating Over an Array
				-
				  ```zig
				  const std = @import("std");

				  pub fn main() void {
				      var arr = [_]i32{10, 20, 30, 40};
				      for (arr) |val| {
				          std.debug.print("{}\n", .{val});
				      }
				  }
				  ```
			- ### Custom Step Size
				-
				  ```zig
				  const std = @import("std");

				  pub fn main() void {
				      for (0..10:2) |i| {
				          std.debug.print("{}\n", .{i});
				      }
				  }
				  ```
			- ### Iterating With Index
				-
				  ```zig
				  const std = @import("std");

				  pub fn main() void {
				      const arr = [_]i32{1, 2, 3, 4};
				      for (arr) |val, idx| {
				          std.debug.print("index: {}, value: {}\n", .{idx, val});
				      }
				  }
				  ```
	- ## Functions
		- All function arguments are immutable. if a copy is needed the user must explicityly make one.
			- example:
			  ```zig
			  fn calculateNewPrice(price: u32, discount: u32) u32 {
			      let mut discounted_price = price; // Make a local mutable copy
			      discounted_price -= discount;    // Modify the local copy
			      return discounted_price;         // Return the new value
			  }

			  fn main() {
			      let original_price = 100; // Immutable by default
			      let discount_amount = 20;

			      let new_price = calculateNewPrice(original_price, discount_amount);

			      println!("Original Price: {}", original_price); // Outputs: 100
			      println!("Discounted Price: {}", new_price);    // Outputs: 80
			  }
			  ```
		- It is also possible to use recursion, though when recursion is used the compiler is no longer able to determine the maximum stack size, which may result in unstable behavior and potential buffer overflows.
			-
			  ```zig
			  fn fibonacci(n: u16) u16 {
			      if (n == 0 or n == 1) return n;
			      return fibonacci(n - 1) + fibonacci(n - 2);
			  }

			  test "function recursion" {
			      const x = fibonacci(10);
			      try expect(x == 55);
			  }
			  ```
		- Variables are snake_case, functions are camelCase
		- only in a function can values be ignored using `_`.
			- Example:
			  ```zig
			  _ = 10;
			  ```
	- ## Defer
		- Defer is used to execute a statement upon exiting the current block.
			- example:
			  ```zig
			  defer x += 2;
			  ```
		- When multiple defers are used in the same code block, upon statement execution, the defers are then executed in **reverse order.**
			- This reflects/mimics the behavior of the stack for resource management, and uses a LIFO (Last in, First Out) paradigm.
			- Example:
			  ```zig
			          defer x += 2;  // Deferred action 1
			          defer x /= 2;  // Deferred action 2

			  // action 2 will run before action 1
			  ```
		- Defers are useful for clearing up resources when they are no longer needed. Instead of remembering to manually free them up, you can defer the clean up statement right next to the statement that allocates the resources.
	-

