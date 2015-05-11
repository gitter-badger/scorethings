# Criterion definitions from dictionary.com
# positive criteria
Criterion.create_system_criterion(
    {name: 'Funny',
    definition: 'providing fun; causing amusement or laughter; amusing; comical'},
    levels: [
      'Not Funny',
      'Not Very Funny',
      'Almost Funny',
      'Kind of Funny',
      'Funny',
      'Very Funny',
      'Funniest Thing Ever'
    ])
Criterion.create_system_criterion(
    {name: 'Important',
    definition: 'of much or great significance or consequence'},
    levels: [
      'Not Important',
      'Not Very Important',
      'Almost Important',
      'Important',
      'Very Important',
      'One of the Most Important Things Ever'
    ])
Criterion.create_system_criterion(
    {name: 'Fast',
    definition: 'moving or able to move, operate, function, or take effect quickly; quick; swift; rapid'},
    levels: [
      'Not Fast',
      'Not Very Fast',
      'Almost Fast',
      'Fast',
      'Very Fast',
      'Extremely Fast'
    ])
Criterion.create_system_criterion(
    {name: 'Unique',
    definition: 'having no like or equal; unparalleled; incomparable'},
    levels: [
      'Not Unique',
      'Not Very Unique',
      'Sort of Unique',
      'Unique',
      'Very Unique',
      'Extremely Unique'
    ])

# negative criteria
Criterion.create_system_criterion(
    {name: 'Boring',
    sign: -1,
    definition: 'causing or marked by the state of being bored; tedium; ennui.'},
    levels: [
      'A Little Boring',
      'Boring',
      'Very Boring',
      'Extremely Boring'
    ])
Criterion.create_system_criterion(
    {name: 'Weak',
    sign: -1,
    definition: 'lacking in force, potency, or efficacy; impotent, ineffectual, or inadequate'},
    levels: [
      'A Little Bit Weak',
      'Almost Weak',
      'Weak',
      'Very Weak',
      'Totally Weak'
    ])
Criterion.create_system_criterion(
    {name: 'Slow',
    sign: -1,
    definition: 'moving or proceeding with little or less than usual speed or velocity'},
    levels: [
      'The Slowest Thing Ever',
      'Very Slow',
      'Slow',
      'Almost Slow',
      'A Little Bit Slow'
    ])
Criterion.create_system_criterion(
    {name: 'Common',
    sign: -1,
    definition: 'of frequent occurrence; usual; familiar'},
    levels: [
      'A Little Bit Common',
      'Almost Common',
      'Common',
      'Very Common',
      'Basic'
    ])
