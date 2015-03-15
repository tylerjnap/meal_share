$numbers = ["0","1","2","3","4","5","6","7","8","9", "I", "?"]
$decimals = [".", ":", " "]
$letters = ('a'..'zz').to_a
$app_phone_number = "+15164505983"
# string = "Lnluss\n. @\n\"ixi'i;i&5 V NG\nLONE'S HONE CENTERS LLC\nzoo n1seLE£ uR1vÉ\nGARDEN CITY, NY 11530 (516) ?94-653I\n* SALE -\nSNLESN: FSILANEI 13 TRANSN: 5204425 11-28-14\nI58890 IsA I25V NHITE GFCI I2 58\n104033 IsA I20V WHITE sF DECO 5N 4:96\n2 O 2.48\nX\n802?I 2-GANG WALL PLATE TF262NC 1 58\n1*\n356351 7 DAY BASIC PROGRANHABLE 34:98\n49.99 DISCOUNT EACH -I5.OI\n344556 FS 2-LIGHT BN FALLSBROOK I5.97\n17.97 DISCOUNT EACH -2.00\n28630 BATH DRAIN 2OGA TRIFLEVER 58.99\nSUBTOTAL: I29.06\nINN: I1.13\nW TOTNL: NBAS\nVISA: NBAS\nI; *,:1 .\"NT; 1Ll7..()\"1.\n;;;NHOUNT:I4O.19 NUTNCD:DO79BB\né;CIL•!•.,. ; is 11/28/ IN ,14 ;53159\nAM f ' ! *\n;\"T, €; 11/28714 14:54:06\nPURCHASED: 7\nIN S AND SPECIAL ORDER ITEMS\nIT INTINlNNI\n1"
$correct_breakdown_string = "\n
Here is the breakdown of your meal.\n\n
#######\n
If you would like to add a missing item, text the name of item, followed by a colon, followed by the price of the item. Here is an example:\n\n
Pasta:10.00\n
#######\n
If you would like to correct an item's price, type it's letter assignment, followed by colon, followed by it's correct price.  Here is an example:\n\n
a:6.00\n
#######\n
If you would like to correct an item's name, type it's letter assignment, followed by colon, followed by it's correct name.  Here is an example:\n\n
a:Meatloaf\n
#######\n
If you would like to correct BOTH an item's price and name, type it's letter assignment, followed by colon, followed by it's correct name, followed by a colon, followed by it's correct price.  Here is an example:\n\n
a:Coffee:6.00\n
#######\n
If you would like to delete an entry entirely, type it's letter assignment, followed by colon, by the word 'delete'.  Here is an example:\n\n
c:delete\n
#######\n
If there are multiple entries to correct, place the next item on a new line:\n\n
Steak:20.00
g:7.50
a:Ice Cream
g:Hamburger:7.50
e:delete
After sending all of you corrections, send an OK to this number.
"
$send_eaters_string = "\n
Thank you for the corrections.

Please send the names of peole you are dining with.  If there are multiple people, add them on a new line.  Here is an example:\n\n
Bob
Henry
Amanda
Stephanie
"

$send_eaters_breakdown_string = "\n
Your friends have been added.

Time to figure out who ate what.  Write the name of your friend, followed by a colon, followed by the letter key of what they ate, seperated by commas.  If there is more than one person dining, place them on a new line.  Here is an example:\n\n

Bob:a,e,g
Henry:s,b,c
Amanda:y,o,z,k
Stephanie:i,p

"
