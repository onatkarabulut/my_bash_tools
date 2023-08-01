#!/bin/bash

SNIPPET_FILE="snippets.txt"

function add_snippet() {
    echo "$1 | $2 | $3" >> "$SNIPPET_FILE"
    echo "Kod parçası eklendi: $1"
}

function edit_snippet() {
    sed -i "/$1 |/ {s/[^|]*| [^|]*| [^|]*/$2 | $3 | $4/}" "$SNIPPET_FILE"
    echo "Kod parçası güncellendi: $2"
}

function delete_snippet() {
    sed -i "/$1 |/d" "$SNIPPET_FILE"
    echo "Kod parçası silindi: $1"
}

function list_all_snippets() {
    cat "$SNIPPET_FILE"
}

function list_snippets_by_tag() {
    grep "$1" "$SNIPPET_FILE"
}

function copy_snippet_to_clipboard() {
    local snippet=$(grep "$1" "$SNIPPET_FILE")
    echo "$snippet" | xclip -sel clip
    echo "Kod parçası panoya kopyalandı: $1"
}

function show_help() {
    echo "Kod Snippet Yöneticisi Terminal Uygulaması"
    echo "Kullanım:"
    echo "  ./snippet.sh add 'başlık' 'açıklama' 'etiketler'          => Yeni kod parçası ekler"
    echo "  ./snippet.sh edit 'eski_başlık' 'yeni_başlık' 'açıklama' 'etiketler' => Kod parçasını günceller"
    echo "  ./snippet.sh delete 'başlık'                           => Kod parçasını siler"
    echo "  ./snippet.sh list                                      => Tüm kod parçalarını listeler"
    echo "  ./snippet.sh list 'etiket'                            => Etikete göre kod parçalarını listeler"
    echo "  ./snippet.sh copy 'başlık'                            => Kod parçasını panoya kopyalar"
}

# Ana program

if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

case $1 in
    "add")
        if [ $# -lt 4 ]; then
            echo "Hata: Başlık, açıklama ve etiketler eksik."
            exit 1
        fi
        add_snippet "$2" "$3" "$4"
        ;;
    "edit")
        if [ $# -lt 5 ]; then
            echo "Hata: Eski başlık, yeni başlık, açıklama ve etiketler eksik."
            exit 1
        fi
        edit_snippet "$2" "$3" "$4" "$5"
        ;;
    "delete")
        if [ $# -lt 2 ]; then
            echo "Hata: Silinecek kod parçasının başlığı eksik."
            exit 1
        fi
        delete_snippet "$2"
        ;;
    "list")
        if [ $# -eq 1 ]; then
            list_all_snippets
        else
            list_snippets_by_tag "$2"
        fi
        ;;
    "copy")
        if [ $# -lt 2 ]; then
            echo "Hata: Kopyalanacak kod parçasının başlığı eksik."
            exit 1
        fi
        copy_snippet_to_clipboard "$2"
        ;;
    *)
        echo "Geçersiz komut. Yardım için './snippet.sh'"
        exit 1
        ;;
esac
