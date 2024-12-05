В этом файле вы найдете инструкции по настройке и запуску `golangci-lint` в вашем проекте. Инструкции протестированы на `Ubuntu 22.04`, на Linux и Mac они должны работать.

Если вы работаете на Windows, то рекомендую вам начать использовать WSL (https://learn.microsoft.com/en-us/windows/wsl/install).

# Зависимости

Перед началом работы убедитесь, что у вас установлены локально:
- Docker: https://docs.docker.com/get-docker/
- jq: https://jqlang.github.io/jq/download/

# Локальный запуск

Создайте в директории проекта папку `golangci-lint` и добавьте ее в `.gitignore`:

```bash
mkdir -p golangci-lint
```

В папке `golangci-lint` будут храниться:
- отчеты линтеров (проблемы, найденные в вашем коде)
- файлы с ошибками запуска `golangci-lint`
- кэш `golangci-lint` (для ускорения работы инструмента)

Для запуска `golangci-lint` мы воспользуемся:
- официальным docker-образом инструмента
- файлом конфигурации `.golangci.yml` (лежит в корне этого проекта)

Скопируйте `.golangci.yml` в корень вашего проекта и запустите `golangci-lint` при помощи команды:

```bash
docker run --rm \
    -v $(pwd):/app \
    -v $(pwd)/golangci-lint/.cache/golangci-lint/v1.57.2:/root/.cache \
    -w /app \
    golangci/golangci-lint:v1.57.2 \
        golangci-lint run \
            -c .golangci.yml \
        > ./golangci-lint/report-unformatted.json
```

Сейчас получившийся файл (`./golangci-lint/report-unformatted.json`) неотформатирован. Для упрощения чтения отформатируйте его при помощи `jq` (см. инструкции по установке здесь: https://jqlang.github.io/jq/download/):

```bash
cat ./golangci-lint/report-unformatted.json | jq > ./golangci-lint/report.json
```

После чего оригинальный файл можно удалить:

```bash
rm ./golangci-lint/report-unformatted.json
```

## Makefile

Вы можете скопировать `Makefile` из этой папки в свой проект (либо перенести правила из него в свой `Makefile`).

Для запуска `golangci-lint` вызовите:

```bash
make golangci-lint-run
```

Для удаления всех сгенерированный `golangci-lint` файлов вызовите:

```bash
make golangci-lint-clean
```

# Git pre-commit hook

Код для добавления линтинга в pre-commit hook находится в `golangci-lint-pre-commit.sh`.

# Настройка GitHub Actions

Скопируйте содержимое `workflows/golangci-lint.yml` в `.github/workflows/`, а `.golangci.yml` в корень вашего репозитория.
