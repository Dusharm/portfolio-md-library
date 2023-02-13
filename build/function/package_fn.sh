
source ./build/function/build_fn.sh

function packageBooks() {
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
        verifyBuild $BOOK_DIR
        packageBook $BOOK_DIR
    done
}

function packageBook() {

    BOOK_DIR=$1
    BOOK_NAME=$(echo $BOOK_DIR | sed -e s~/book.toml~~g -e s~/.*/~~g)
    cp -r $BOOK_DIR/book $TARGET_PATH/$BOOK_NAME

    echo /$BOOK_NAME/index.html >> $TARGET_PATH/paths.txt

}

function verifyBuild() {
# check for book at $1
    BOOK_DIR=$1

    if [[ ! -d $BOOK_DIR/book ]]; then
        echo No packaged book found at $BOOK_DIR
        echo packaging book
        echo

        buildBook $BOOK_DIR
    fi
}

function stageTarget() {
# Staget target directory
    if [[ ! -d ./build/target ]]; then
        mkdir ./build/target
    fi
    rm -rf ./build/target/*

    TARGET_PATH="$(realpath build/target)"
}