## Data#message

The `message` field holds the <i>post install message</i>, which is
be diplayed after a package is installed to provide users with 
important information about their newly installed application or
library.

The message fields SHOULD not be used to convey unimportant trival
statements. You do not need to thank people for installing your
software in the post install message.

The `message` field can only contain a string.

    no 100
    no :symbol
    no Object.new

Other than that the string can contain nay text desiredm but the string
SHOULD be less that 1,000 characters.

