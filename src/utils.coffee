names1 = ["Jackson", "Aiden", "Liam", "Lucas", "Noah", "Mason", "Jayden", "Ethan", "Jacob", "Jack", "Caden",
  "Logan", "Benjamin", "Michael", "Caleb", "Ryan", "Alexander", "Elijah", "James", "William", "Oliver", "Connor",
  "Matthew", "Daniel", "Luke", "Brayden", "Jayce", "Henry", "Carter", "Dylan", "Gabriel", "Joshua", "Nicholas", "Isaac",
  "Owen", "Nathan", "Grayson", "Eli", "Landon", "Andrew", "Max", "Samuel", "Gavin", "Wyatt", "Christian", "Hunter",
  "Cameron", "Evan", "Charlie", "David", "Sebastian", "Joseph", "Dominic", "Anthony", "Colton", "John", "Tyler",
  "Zachary", "Thomas", "Julian", "Levi", "Adam", "Isaiah", "Alex", "Aaron", "Parker", "Cooper", "Miles", "Chase",
  "Muhammad", "Christopher", "Blake", "Austin", "Jordan", "Leo", "Jonathan", "Adrian", "Colin", "Hudson", "Ian",
  "Xavier", "Camden", "Tristan", "Carson", "Jason", "Nolan", "Riley", "Lincoln", "Brody", "Bentley", "Nathaniel",
  "Josiah", "Declan", "Jake", "Asher", "Jeremiah", "Cole", "Mateo", "Micah", "Elliot"]
names2 = ["Sophia", "Emma", "Olivia", "Isabella", "Mia", "Ava", "Lily", "Zoe", "Emily", "Chloe", "Layla",
  "Madison", "Madelyn", "Abigail", "Aubrey", "Charlotte", "Amelia", "Ella", "Kaylee", "Avery", "Aaliyah", "Hailey",
  "Hannah", "Addison", "Riley", "Harper", "Aria", "Arianna", "Mackenzie", "Lila", "Evelyn", "Adalyn", "Grace",
  "Brooklyn", "Ellie", "Anna", "Kaitlyn", "Isabelle", "Sophie", "Scarlett", "Natalie", "Leah", "Sarah", "Nora", "Mila",
  "Elizabeth", "Lillian", "Kylie", "Audrey", "Lucy", "Maya", "Annabelle", "Makayla", "Gabriella", "Elena", "Victoria",
  "Claire", "Savannah", "Peyton", "Maria", "Alaina", "Kennedy", "Stella", "Liliana", "Allison", "Samantha", "Keira",
  "Alyssa", "Reagan", "Molly", "Alexandra", "Violet", "Charlie", "Julia", "Sadie", "Ruby", "Eva", "Alice", "Eliana",
  "Taylor", "Callie", "Penelope", "Camilla", "Bailey", "Kaelyn", "Alexis", "Kayla", "Katherine", "Sydney", "Lauren",
  "Jasmine", "London", "Bella", "Adeline", "Caroline", "Vivian", "Juliana", "Gianna", "Skyler", "Jordyn"]

nameGenSimple = () -> randUn(randUn([names1, names2]))

module.exports.getRandomCreepName = (prefix = "") ->
  tries = 0
  loop
    name = nameGen()
    name += " " + nameGen() if tries > 3

    break unless Game.creeps[name]?

    tries++
  return prefix + name

module.exports.cton = (pos) -> pos.x * 50 + pos.y
module.exports.ntoc = (n) ->
  y = n % 50
  return {x: (n-y) // 50, y: y}


nm1 = ["a","e","i","u","o","a","ai","aiu","aiue","e","i","ia","iau","iu","o","u","y","ya","yi","yo"]
nm2 = ["bh","br","c'th","cn","ct","cth","cx","d","d'","g","gh","ghr","gr","h","k","kh","kth","mh","mh'","ml","n","ng","sh","t","th","tr","v","v'","vh","vh'","vr","x","z","z'","zh"];
nm3 = ["a","e","i","u","o","a","e","i","u","o","ao","aio","ui","aa","io","ou","y"];
nm4 = ["bb","bh","br","cn","ct","dh","dhr","dr","drr","g","gd","gg","ggd","gh","gn","gnn","gr","jh","kl","l","ld","lk","ll","lp","lth","mbr","nd","p","r","rr","rv","th","thl","thr","thrh","tl","vh","x","xh","z","zh","zt"];
nm5 = ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","'dhr","'dr","'end","'gn","'ith","'itr","'k","'kr","'l","'m","'r","'th","'vh","'x","'zh"];
nm6 = ["a","e","i","u","o"];
nm7 = ["","","","","","","","","","","d","g","h","l","lb","lbh","n","r","rc","rh","s","sh","ss","st","sz","th","tl","x","xr","xz"];

randUn = (arr) -> arr[Math.floor(Math.random() * arr.length)]
nameGen = () -> _.startCase((randUn nameGens)())

nameGens = [
  () -> _.map([nm2, nm3, nm4, nm5, nm6, nm7], randUn).join(""),
  () -> _.map([nm1, nm2, nm3, nm4, nm5, nm6, nm7], randUn).join("")
]