Nonterminals E.
Terminals add mult open close number.
Rootsymbol E.
Left 100 add.
Left 100 mult.
E -> E add E : {'$2', '$1', '$3'}.
E -> E mult E : {'$2', '$1', '$3'}.
E -> open E close : '$2'.
E -> number : '$1'.
