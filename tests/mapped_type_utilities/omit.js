// Unlike Pick, omit is not homomorphic and has no special behavior for
// modifier preservation or distributivity
type O = {foo: string, bar: number, baz: number};

type OmitFoo = Omit<O, 'foo'>;
declare const noFoo: OmitFoo;
noFoo.foo; // ERROR
(noFoo: {bar: number, baz: number}); // OK

type OmitFooAndBar = Omit<O, 'foo' | 'bar'>;
declare const noFooOrBar: OmitFooAndBar;
noFooOrBar.foo; // ERROR
noFooOrBar.bar; // ERROR
noFooOrBar.baz; // OK
(noFooOrBar:{baz: number}); // OK
