random = require 'utils.random'
log = require 'log'

### planet names generator http://www.fantasynamegenerators.com/ ###
nm1 = ["b","c","d","f","g","h","i","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z","","","","",""];
nm2 = ["a","e","o","u"];
nm3 = ["br","cr","dr","fr","gr","pr","str","tr","bl","cl","fl","gl","pl","sl","sc","sk","sm","sn","sp","st","sw","ch","sh","th","wh"];
nm4 = ["ae","ai","ao","au","a","ay","ea","ei","eo","eu","e","ey","ua","ue","ui","uo","u","uy","ia","ie","iu","io","iy","oa","oe","ou","oi","o","oy"];
nm5 = ["turn","ter","nus","rus","tania","hiri","hines","gawa","nides","carro","rilia","stea","lia","lea","ria","nov","phus","mia","nerth","wei","ruta","tov","zuno","vis","lara","nia","liv","tera","gantu","yama","tune","ter","nus","cury","bos","pra","thea","nope","tis","clite"];
nm6 = ["una","ion","iea","iri","illes","ides","agua","olla","inda","eshan","oria","ilia","erth","arth","orth","oth","illon","ichi","ov","arvis","ara","ars","yke","yria","onoe","ippe","osie","one","ore","ade","adus","urn","ypso","ora","iuq","orix","apus","ion","eon","eron","ao","omia"];
nm7 = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","0","1","2","3","4","5","6","7","8","9","","","","","","","","","","","","","",""];

planetNameFuns = [
  () -> _.map([nm1, nm2, nm3, nm4, nm5], random.element).join(""),
  () -> _.map([nm1, nm2, nm3, nm6], random.element).join(""),
  () -> _.map([nm1, nm4, nm5], random.element).join(""),
  () -> _.map([nm1, nm2, nm3, nm2, nm5], random.element).join(""),
  () -> _.map([nm3, nm6, nm7, nm7, nm7, nm7], random.element).join("")
]

module.exports.genUniqueSpawnName = () ->
  loop
    name = changeCase((random.element planetNameFuns)())
    return name unless Game.spawns[name]?
    log.error "spawn name duplicate generated: #{name}"

### lovecraftian names generator http://www.fantasynamegenerators.com/ ###
nm1 = ["a","e","i","u","o","a","ai","aiu","aiue","e","i","ia","iau","iu","o","u","y","ya","yi","yo"]
nm2 = ["bh","br","c'th","cn","ct","cth","cx","d","d'","g","gh","ghr","gr","h","k","kh","kth","mh","mh'","ml","n","ng","sh","t","th","tr","v","v'","vh","vh'","vr","x","z","z'","zh"];
nm3 = ["a","e","i","u","o","a","e","i","u","o","ao","aio","ui","aa","io","ou","y"];
nm4 = ["bb","bh","br","cn","ct","dh","dhr","dr","drr","g","gd","gg","ggd","gh","gn","gnn","gr","jh","kl","l","ld","lk","ll","lp","lth","mbr","nd","p","r","rr","rv","th","thl","thr","thrh","tl","vh","x","xh","z","zh","zt"];
nm5 = ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","'dhr","'dr","'end","'gn","'ith","'itr","'k","'kr","'l","'m","'r","'th","'vh","'x","'zh"];
nm6 = ["a","e","i","u","o"];
nm7 = ["","","","","","","","","","","d","g","h","l","lb","lbh","n","r","rc","rh","s","sh","ss","st","sz","th","tl","x","xr","xz"];

creepNamesFuns = [
  () -> _.map([nm2, nm3, nm4, nm5, nm6, nm7], random.element).join(""),
  () -> _.map([nm1, nm2, nm3, nm4, nm5, nm6, nm7], random.element).join("")
]

module.exports.genUniqueCreepName = (prefix = "", suffix = "") ->
  loop
    name = prefix + changeCase((random.element creepNamesFuns)()) + suffix
    return name unless Game.creeps[name]?
    log.error "creep name duplicate generated: #{name}"

changeCase = (str) ->
  vs = str.split("")
  prevIsLetter = false
  for v, i in vs
    isLetter = (v.match(/[a-z]/i))
    if isLetter and not prevIsLetter
      vs[i] = v.toUpperCase()
    prevIsLetter = isLetter
  return vs.join("")

### simple naming ###
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

nameGenSimple = () -> random.element random.element [names1, names2]
