#!/bin/bash

# Переходим в директорию с APK файлами
cd /Users/aleksandrburaev/Desktop/AutoUpdater/Apks

# Убедимся что мы в правильной ветке (main)
git checkout -b main 2>/dev/null || git checkout main 2>/dev/null || echo "Already on main or cannot switch"

# Настраиваем Git LFS для APK файлов
git lfs track "*.apk" 2>/dev/null || echo "APK tracking already configured"

# Добавляем изменения в .gitattributes
git add .gitattributes

# Добавляем APK файлы, если они существуют
if ls *.apk 1> /dev/null 2>&1; then
    git add *.apk
    # Пытаемся сделать коммит, но не прерываем скрипт если нечего коммитить
    git commit -m "Add APK files to Git LFS" || true
else
    echo "No APK files found to add"
fi

# Декомпилируем APK файлы с перезаписью существующих
if ls *.apk 1> /dev/null 2>&1; then
    for apk_file in *.apk; do
        output_dir="/Users/aleksandrburaev/Desktop/AutoUpdater/Trashers/$(basename "$apk_file" .apk)"
        # Удаляем существующую директорию и декомпилируем заново
        rm -rf "$output_dir"
        apktool d "$apk_file" -o "$output_dir" -f
    done
else
    echo "No APK files found to decompile"
fi

# ДОБАВЛЕНО: Пушим изменения в удаленный репозиторий
echo "Pushing APK files to remote..."
git push -u origin main || git push --set-upstream origin main --force

# Возвращаем код успеха
exit 0