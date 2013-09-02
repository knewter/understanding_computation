require './simple'

Add.new(
  Multiply.new(Number.new(1), Number.new(2)),
  Multiply.new(Number.new(3), Number.new(4))
)
Number.new(5)

# Test reducible
Number.new(1).reducible?
Add.new(Number.new(1), Number.new(2)).reducible?

# Test reduce
expression =
     Add.new(
       Multiply.new(Number.new(1), Number.new(2)),
       Multiply.new(Number.new(3), Number.new(4))
     )
expression.reducible?
expression = expression.reduce
expression.reducible?
expression = expression.reduce
expression.reducible?
expression = expression.reduce
expression.reducible?

# Machine
Machine.new(
     Add.new(
       Multiply.new(Number.new(1), Number.new(2)),
       Multiply.new(Number.new(3), Number.new(4))
     )
   ).run

# LessThan, Boolean
Machine.new(
     LessThan.new(Number.new(5), Add.new(Number.new(2), Number.new(2)))
   ).run

# Variables, Environment
Machine.new(
     Add.new(Variable.new(:x), Variable.new(:y)),
     { x: Number.new(3), y: Number.new(4) }
   ).run

# Statements, Assignment
Machine.new(
     Assign.new(:x, Add.new(Variable.new(:x), Number.new(1))),
     { x: Number.new(2) }
   ).run

# If
Machine.new(
     If.new(
       Variable.new(:x),
       Assign.new(:y, Number.new(1)),
       Assign.new(:y, Number.new(2))
     ),
     { x: Boolean.new(true) }
   ).run

Machine.new(
     If.new(Variable.new(:x), Assign.new(:y, Number.new(1)), DoNothing.new),
     { x: Boolean.new(false) }
   ).run

# Sequence
Machine.new(
     Sequence.new(
       Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
       Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
     ),
     {}
   ).run

# While
Machine.new(
     While.new(
       LessThan.new(Variable.new(:x), Number.new(5)),
       Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
     ),
     { x: Number.new(1) }
   ).run

# Testing syntactically-valid but logically-flawed statements
Machine.new(
     Sequence.new(
       Assign.new(:x, Boolean.new(true)),
       Assign.new(:x, Add.new(Variable.new(:x), Number.new(1)))
     ),
     {}
   ).run

# Big Step semantics
Number.new(23).evaluate({})
Variable.new(:x).evaluate({ x: Number.new(23) })
LessThan.new(
     Add.new(Variable.new(:x), Number.new(2)),
     Variable.new(:y)
   ).evaluate({ x: Number.new(2), y: Number.new(5) })

statement =
     Sequence.new(
       Assign.new(:x, Add.new(Number.new(1), Number.new(1))),
       Assign.new(:y, Add.new(Variable.new(:x), Number.new(3)))
     )
statement.evaluate({})

# Big-Step while
statement =
     While.new(
       LessThan.new(Variable.new(:x), Number.new(5)),
       Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
     )
statement.evaluate({ x: Number.new(1) })

# Initially define to_ruby for Boolean, Number
Number.new(5).to_ruby
Boolean.new(false).to_ruby

proc = eval(Number.new(5).to_ruby)
proc.call({})
proc = eval(Boolean.new(false).to_ruby)
proc.call({})

# Testing variables
expression = Variable.new(:x)
expression.to_ruby
proc = eval(expression.to_ruby)
proc.call({ x: 7 })

# Testing boolean expressions
Add.new(Variable.new(:x), Number.new(1)).to_ruby
LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(3)).to_ruby
environment = { x: 3 }
proc = eval(Add.new(Variable.new(:x), Number.new(1)).to_ruby)
proc.call(environment)
proc = eval(
     LessThan.new(Add.new(Variable.new(:x), Number.new(1)), Number.new(3)).to_ruby
   )
proc.call(environment)

# Assign
statement = Assign.new(:y, Add.new(Variable.new(:x), Number.new(1)))
statement.to_ruby
proc = eval(statement.to_ruby)
proc.call({ x: 3 })

# While
statement =
     While.new(
       LessThan.new(Variable.new(:x), Number.new(5)),
       Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
     )
statement.to_ruby
proc = eval(statement.to_ruby)
proc.call({ x: 1 })
