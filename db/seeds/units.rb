puts "UNITA"

units = [
  "Bq m-3",
  "KBq h m-3",
  "Bq h m-3",
  "%",
  "Bq",
  "Bq l-1",
  "Bq kg-1",
  "Bq m-2",
  "mBq m-3",
  "mBq l-1",
  "mBq kg-1",
  "mBq m-2",
  "Bq g-1",
  "µBq m-3",
  "cps",
  "Bq cm-2",
  "Sv h-1",
  "mSv h-1",
  "µSv h-1",
  "nSv h-1",
  "KBq m-3"
]


units.map{ |a| Unit.create( title: a, author: 'System' ) }