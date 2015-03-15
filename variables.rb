$numbers = ["0","1","2","3","4","5","6","7","8","9", "I", "?"]
$decimals = [".", ":", " "]
$letters = ('a'..'zz').to_a
$app_phone_number = "+15164505983"
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
