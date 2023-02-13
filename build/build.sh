function buildBooks() {
# Find book directories by searching for book.toml
# run from project root

    BOOKLIST="$(find . -type f -name "book.toml" -exec realpath {} \; )"

    if [[ $BOOKLIST == "" ]]; then
        echo Found no books!
        exit 2
    fi

    echo Found the following books:
    echo ---------------------------
    for BOOK in $BOOKLIST; do
        echo $( echo $BOOK | sed -e s~/book.toml~~g -e s~/.*/~~g)
    done
    echo

    for BOOK in $BOOKLIST; do
        BOOK_DIR=$( echo $BOOK | sed -e s~/book.toml~~g  )
        buildBook $BOOK_DIR
    done
}

function buildBook(){
    # run mdBook from path in $1

    BOOK_DIR=$1

    cd $BOOK_DIR
    echo Building from $BOOK_DIR
    echo ---------------------------

    # Can't seem to redirect output for this command. Generation
    # is very fast so it's not very worth to put this to background
    # in case of failure
    mdbook build

    echo Done $BOOK_DIR
    echo
}

function main() {
    buildBooks
}

main