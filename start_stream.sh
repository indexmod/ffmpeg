#!/bin/bash

# Задайте переменные для подключения
ICECAST_URL="icecast://source:ваш_пароль@localhost:8000/stream"
AUDIO_PATH="assets/audio"

# Бесконечный цикл для автоматического вещания
while true; do
    # Определяем текущий час (от 0 до 23)
    current_hour=$(date +"%H")

    # Формируем имя файла для текущего часа
    audio_file="${AUDIO_PATH}/hour${current_hour}.mp3"

    # Проверка на существование файла перед запуском
    if [[ -f "$audio_file" ]]; then
        echo "Playing $audio_file"

        # Запуск ffmpeg с выбранным файлом
        ffmpeg -re -i "$audio_file" -f mp3 "$ICECAST_URL" || {
            echo "Ошибка при воспроизведении $audio_file. Повтор через минуту."
            sleep 60  # Ждем минуту перед повтором
            continue
        }
    else
        echo "File $audio_file does not exist. Skipping."
    fi

    # Ждем до следующего часа
    sleep $((60 * 60))
done
