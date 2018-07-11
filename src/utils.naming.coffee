_ = require('lodash')
random = require 'utils.random'

### planet names generator http://www.fantasynamegenerators.com/ ###
p =
  nm1: ["b","c","d","f","g","h","i","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z","","","","",""];
  nm2: ["a","e","o","u"];
  nm3: ["br","cr","dr","fr","gr","pr","str","tr","bl","cl","fl","gl","pl","sl","sc","sk","sm","sn","sp","st","sw","ch","sh","th","wh"];
  nm4: ["ae","ai","ao","au","a","ay","ea","ei","eo","eu","e","ey","ua","ue","ui","uo","u","uy","ia","ie","iu","io","iy","oa","oe","ou","oi","o","oy"];
  nm5: ["turn","ter","nus","rus","tania","hiri","hines","gawa","nides","carro","rilia","stea","lia","lea","ria","nov","phus","mia","nerth","wei","ruta","tov","zuno","vis","lara","nia","liv","tera","gantu","yama","tune","ter","nus","cury","bos","pra","thea","nope","tis","clite"];
  nm6: ["una","ion","iea","iri","illes","ides","agua","olla","inda","eshan","oria","ilia","erth","arth","orth","oth","illon","ichi","ov","arvis","ara","ars","yke","yria","onoe","ippe","osie","one","ore","ade","adus","urn","ypso","ora","iuq","orix","apus","ion","eon","eron","ao","omia"];
  nm7: ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","0","1","2","3","4","5","6","7","8","9","","","","","","","","","","","","","",""];

planetNameFuns = [
  () -> _.map([p.nm1, p.nm2, p.nm3, p.nm4, p.nm5], random.element).join(""),
  () -> _.map([p.nm1, p.nm2, p.nm3, p.nm6], random.element).join(""),
  () -> _.map([p.nm1, p.nm4, p.nm5], random.element).join(""),
  () -> _.map([p.nm1, p.nm2, p.nm3, p.nm2, p.nm5], random.element).join(""),
  () -> _.map([p.nm3, p.nm6, p.nm7, p.nm7, p.nm7, p.nm7], random.element).join("")
]

module.exports.genUniqueSpawnName = () ->
  for i in [0...10]
    name = changeCase((random.element planetNameFuns)())
    return name unless Game.spawns[name]?

  throw new Error "spawn name duplicate generated: #{name} after 10 retries!"

### lovecraftian names generator http://www.fantasynamegenerators.com/ ###
lc =
  nm1: ["a","e","i","u","o","a","ai","aiu","aiue","e","i","ia","iau","iu","o","u","y","ya","yi","yo"]
  nm2: ["bh","br","c'th","cn","ct","cth","cx","d","d'","g","gh","ghr","gr","h","k","kh","kth","mh","mh'","ml","n","ng","sh","t","th","tr","v","v'","vh","vh'","vr","x","z","z'","zh"];
  nm3: ["a","e","i","u","o","a","e","i","u","o","ao","aio","ui","aa","io","ou","y"];
  nm4: ["bb","bh","br","cn","ct","dh","dhr","dr","drr","g","gd","gg","ggd","gh","gn","gnn","gr","jh","kl","l","ld","lk","ll","lp","lth","mbr","nd","p","r","rr","rv","th","thl","thr","thrh","tl","vh","x","xh","z","zh","zt"];
  nm5: ["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","'dhr","'dr","'end","'gn","'ith","'itr","'k","'kr","'l","'m","'r","'th","'vh","'x","'zh"];
  nm6: ["a","e","i","u","o"];
  nm7: ["","","","","","","","","","","d","g","h","l","lb","lbh","n","r","rc","rh","s","sh","ss","st","sz","th","tl","x","xr","xz"];

creepNamesFuns = [
  () -> _.map([lc.nm2, lc.nm3, lc.nm4, lc.nm5, lc.nm6, lc.nm7], random.element).join(""),
  () -> _.map([lc.nm1, lc.nm2, lc.nm3, lc.nm4, lc.nm5, lc.nm6, lc.nm7], random.element).join("")
]

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

### one punch man names generator http://www.fantasynamegenerators.com/ ###
opm =
  nm1: ["Aberrant","Abnormal","Absurd","Advanced","Agile","Ancient","Angry","Arrogant","Berserk","Berserker","Bitter",
    "Bizarre","Bloody","Bold","Brilliant","Broken","Careless","Cold","Corrupt","Craven","Cruel","Dapper","Dashing",
    "Defiant","Depraved","Dim","Drunk","Dull","Dynamic","Elite","Enraged","Ethereal","False","Fearless","Fierce",
    "Foolhardy","Free","Frozen","Gentle","Giant","Glum","Golden","Grand","Grave","Grim","Hallowed","Harsh","Hidden",
    "High","Hollow","Horned","Idle","Infamous","Infernal","Juvenile","Keen","Last","Lazy","Light","Little","Livid",
    "Lone","Lost","Loud","Loyal","Lucky","Mad","Majestic","Mammoth","Marked","Mellow","Mild","Monster","Mute",
    "Mysterious","Mystery","Next","Nimble","Numb","Old","One","Pale","Partial","Petty","Phony","Poison","Prime","Proud",
    "Putrid","Quick","Quiet","Rabid","Radiant","Rampant","Rebel","Reckless","Rotten","Ruthless","Second","Secret",
    "Serene","Shallow","Sharp","Sick","Silent","Silver","Simple","Skeleton","Smiling","Somber","Spirit","Stark","Steel",
    "Strange","Strong","Supreme","Swift","Tiny","True","Twin","Useless","Vacant","Vague","Venom","Vibrant","Violent",
    "Volatile","Wandering","War","Warped","Wrathful","Wicked","Wild","Wretched"]
  nm2: ["Adventure","Aftermath","Ambition","Anger","Animal","Bandana","Beam","Bear","Beast","Beetle","Bite","Blade",
    "Bomb","Bone","Bonus","Brick","Bubble","Bug","Burst","Cable","Cactus","Cannon","Chain","Chaos","Cloud","Club",
    "Creature","Crook","Crush","Earthquake","Edge","Escape","Fang","Feast","Fire","Flame","Flock","Fluke","Flux",
    "Garbage","Ghost","Gift","Gold","Gun","Hammer","Hide","Horn","Ice","Impulse","Ink","Insanity","Iron","Jewel",
    "Judge","Kite","Knife","Knot","Leaf","Light","Lightning","Lock","Luck","Mask","Master","Might","Mist","Mouth",
    "Muscle","Nail","Needle","Nerve","Night","Noise","Omen","Peace","Phase","Pitch","Poison","Pride","Quill","Rain",
    "Riddle","Risk","Rock","Root","Rose","Salt","Scale","Shift","Shock","Sky","Slice","Song","Spark","Spider","Split",
    "Sponge","Star","Steel","Stick","Stitch","Stone","Storm","Stretch","Switch","Tackle","Temper","Thunder","Tiger",
    "Toad","Tooth","Trash","Tremor","Trick","Twist","Veil","Web","Whip","Whistle","Wish","Worm"]

opmNameFun = [
  () -> random.element opm.nm2,
  () -> _.map([opm.nm1, opm.nm2], random.element).join(" ")
]

module.exports.genUniqueCreepName = (allCreeps, prefix = "", suffix = "") ->
  for i in [0...10]
    name = prefix + changeCase((random.element opmNameFun)()) + suffix
    return name unless allCreeps[name]?
  throw new Error "creep name duplicate generated: #{name} after 10 retries!"
