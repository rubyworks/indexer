## Validator#install_message

The `install_message` field holds the <i>post install message</i>,
which is displayed after a package is installed to provide users
with important information about their newly installed application
or library.

The `install_message` fields SHOULD not be used to convey unimportant
and trival statements. You do not need to thank people for installing
your software in the install message!

The `install_message` field can only contain a string.

    no 100
    no :symbol
    no Object.new

Other than that the string can contain nay text desired, but the string
SHOULD be less that 1,000 characters.

