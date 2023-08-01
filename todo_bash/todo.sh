#!/bin/bash

TODO_FILE="todo.txt"

function add_task() {
    echo "$1 | $2" >> "$TODO_FILE"
    echo "Görev eklendi: $1"
}

function complete_task() {
    sed -i "/$1 |/ s/^/#/" "$TODO_FILE"
    echo "Görev tamamlandı: $1"
}

function delete_task() {
    sed -i "/$1 |/d" "$TODO_FILE"
    echo "Görev silindi: $1"
}

function list_all_tasks() {
    cat "$TODO_FILE"
}

function list_completed_tasks() {
    grep -e '^[#]' "$TODO_FILE"
}

function save_tasks() {
    cp "$TODO_FILE" "todo_backup.txt"
    echo "Görevler yedeklendi."
}

function load_tasks() {
    cp "todo_backup.txt" "$TODO_FILE"
    echo "Görevler geri yüklendi."
}

function show_help() {
    echo "To-Do List Terminal Uygulaması"
    echo "Kullanım:"
    echo "  ./todo.sh add 'başlık' 'açıklama'  => Görev ekler"
    echo "  ./todo.sh complete 'başlık'      => Görevi tamamlar"
    echo "  ./todo.sh delete 'başlık'        => Görevi siler"
    echo "  ./todo.sh list                  => Tüm görevleri listeler"
    echo "  ./todo.sh completed             => Tamamlanmış görevleri listeler"
    echo "  ./todo.sh save                  => Görevleri dosyaya kaydeder"
    echo "  ./todo.sh load                  => Görevleri dosyadan yükler"
}

# Ana program

if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

case $1 in
    "add")
        if [ $# -lt 3 ]; then
            echo "Hata: Başlık ve açıklama eksik."
            exit 1
        fi
        add_task "$2" "$3"
        ;;
    "complete")
        if [ $# -lt 2 ]; then
            echo "Hata: Tamamlanacak görevin başlığı eksik."
            exit 1
        fi
        complete_task "$2"
        ;;
    "delete")
        if [ $# -lt 2 ]; then
            echo "Hata: Silinecek görevin başlığı eksik."
            exit 1
        fi
        delete_task "$2"
        ;;
    "list")
        list_all_tasks
        ;;
    "completed")
        list_completed_tasks
        ;;
    "save")
        save_tasks
        ;;
    "load")
        load_tasks
        ;;
    *)
        echo "Geçersiz komut. Yardım için './todo.sh'"
        exit 1
        ;;
esac
