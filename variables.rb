$numbers = ["0","1","2","3","4","5","6","7","8","9", "I", "?"]
$decimals = [".", ":", " "]
$letters = ('a'..'zz').to_a
$app_phone_number = "+15164505983"
$correct_breakdown_string = "\n
Here is the breakdown of your meal.\n\n
#######\n
If you would like to add a missing item, text the name of item, followed by a colon, followed by the price of the item.  If there is more than one missing items, place each missing item on a new line.  Here is an example:\n\n
Pasta:10.00\n\n
#######\n
If you would like to correct an item's price, type it's letter assignment, followed by colon, followed by it's correct price.  Here is an example:\n\n
a:6.00\n\n
#######\n
If you would like to correct an item's name, type it's letter assignment, followed by colon, followed by it's correct name.  Here is an example:\n\n
a:Meatloaf\n\n
#######\n
If you would like to correct BOTH an item's price and name, type it's letter assignment, followed by colon, followed by it's correct name, followed by a colon, followed by it's correct price.  Here is an example:\n\n
a:Coffee:6.00\n\n
#######\n
If there are multiple entries to correct, place the next item on a new line:\n\n
Steak:20.00\n
g:7.50\n
a:Ice Cream\n
g:Hamburger:7.50\n
After sending all of you corrections, send an OK to this number.
"
