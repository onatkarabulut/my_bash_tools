#!/bin/bash

function analyze_code() {
    local project_dir="$1"
    local code_extensions=("c" "cpp" "h" "hpp" "py" "js")

    local total_lines=0
    local total_comment_lines=0
    local total_blank_lines=0
    local total_code_files=0
    local language_lines=()

    while IFS= read -r -d '' file; do
        if [ -f "$file" ]; then
            local extension="${file##*.}"
            if [[ " ${code_extensions[*]} " =~ " $extension " ]]; then
                local code_lines=$(cat "$file" | grep -vE '^\s*$|^\s*//|^\s*/\*|^\s*\*/' | wc -l)
                local comment_lines=$(cat "$file" | grep -E '^\s*//|^\s*/\*' | wc -l)
                local blank_lines=$(cat "$file" | grep -E '^\s*$' | wc -l)

                total_lines=$((total_lines + code_lines + comment_lines + blank_lines))
                total_comment_lines=$((total_comment_lines + comment_lines))
                total_blank_lines=$((total_blank_lines + blank_lines))
                total_code_files=$((total_code_files + 1))

                if [ "${language_lines[$extension]}" ]; then
                    language_lines["$extension"]=$((language_lines["$extension"] + code_lines + comment_lines + blank_lines))
                else
                    language_lines["$extension"]=$((code_lines + comment_lines + blank_lines))
                fi
            fi
        fi
    done < <(find "$project_dir" -type f -print0)

    echo "Toplam kod satırı: $total_lines"
    echo "Toplam yorum satırı: $total_comment_lines"
    echo "Toplam boş satır: $total_blank_lines"
    echo "Toplam kod dosyaları: $total_code_files"

    echo "Dil bazında satır sayıları:"
    for lang in "${!language_lines[@]}"; do
        echo "$lang: ${language_lines[$lang]}"
    done

    echo "En uzun kod dosyaları:"
    find "$project_dir" -type f -exec wc -l {} + | sort -rn | head -n 5

    echo "En kısa kod dosyaları:"
    find "$project_dir" -type f -exec wc -l {} + | sort -n | head -n 5
}

function show_help() {
    echo "Kod Analiz Aracı Terminal Uygulaması"
    echo "Kullanım:"
    echo "  ./code_analyzer.sh 'proje_dizini'  => Proje dizinini tarar ve kod istatistikleri verir"
}

# Ana program

if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

analyze_code "$1"
