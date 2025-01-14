type O1 = {+foo: number, bar?: string};
type O2 = {foo: string, baz: number};

// Pick is semi-homomorphic, so property modifiers should be preserved...
type PickO1 = Pick<O1, 'foo' | 'bar'>;
declare const pickedO1: PickO1;
(pickedO1: {+foo: number, bar?: string}); // OK
pickedO1.foo = 3; // ERROR: foo is read-only 
(pickedO1.bar: string); // ERROR bar is optional
// ... and we should also distribute over unions
type PickFooUnion = Pick<O1 | O2, 'foo'> ;
declare const pickedFooUnion: PickFooUnion;
(pickedFooUnion: {+foo: number} | {foo: string}); // OK!
