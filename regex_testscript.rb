require './regex'

pattern =
     Repeat.new(
       Choose.new(
         Concatenate.new(Literal.new('a'), Literal.new('b')),
         Literal.new('a')
       )
     )

nfa_design = Empty.new.to_nfa_design
nfa_design.accepts?('')
nfa_design.accepts?('a')
nfa_design = Literal.new('a').to_nfa_design
nfa_design.accepts?('')
nfa_design.accepts?('a')
nfa_design.accepts?('b')

# Add 'matches?'
Empty.new.matches?('a')
Literal.new('a').matches?('a')

# Add Concatenate nfa design
pattern = Concatenate.new(Literal.new('a'), Literal.new('b'))
pattern.matches?('a')
pattern.matches?('ab')
pattern.matches?('abc')

pattern =
     Concatenate.new(
       Literal.new('a'),
       Concatenate.new(Literal.new('b'), Literal.new('c'))
     )
pattern.matches?('a')
pattern.matches?('ab')
pattern.matches?('abc')

# Add Choose nfa design
pattern = Choose.new(Literal.new('a'), Literal.new('b'))
pattern.matches?('a')
pattern.matches?('b')
pattern.matches?('c')

# Add Repeat nfa design
pattern = Repeat.new(Literal.new('a'))
pattern.matches?('')
pattern.matches?('a')
pattern.matches?('aaaa')
pattern.matches?('b')

# Test more complex cases
pattern =
     Repeat.new(
       Concatenate.new(
         Literal.new('a'),
         Choose.new(Empty.new, Literal.new('b'))
       )
     )
pattern.matches?('')
pattern.matches?('a')
pattern.matches?('ab')
pattern.matches?('aba')
pattern.matches?('abab')
pattern.matches?('abaab')
pattern.matches?('abba')
