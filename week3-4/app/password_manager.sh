#!/bin/bash

init_encrypt_file_if_not_exists() {
    if [ ! -f "credentials.gpg" ]
    then
        touch credentials.txt
        encrypt_and_shred_file
    fi
}

encrypt_and_shred_file() {
    gpg -c --quiet --batch --passphrase-file "passphrase.txt" -o credentials.gpg credentials.txt
    shred -u credentials.txt
}

decrypt_and_shred_file() {
    gpg -d --quiet --batch --passphrase-file "passphrase.txt" -o credentials.txt credentials.gpg
    shred -u credentials.gpg
}

add_password() {
    read -p 'サービス名を入力してください：' service_name
    read -p 'ユーザー名を入力してください：' user_name
    read -sp 'パスワードを入力してください：' password
    echo

    decrypt_and_shred_file

    echo "$service_name:$user_name:$password" >> credentials.txt

    encrypt_and_shred_file

    echo 'パスワードの追加は成功しました。'
}

get_password() {
    read -p 'サービス名を入力してください：' input_service_name

    decrypt_and_shred_file

    matched_credentials=$(grep "^$input_service_name" credentials.txt)

    encrypt_and_shred_file

    if [ -z "$matched_credentials" ]
    then
        echo 'そのサービスは登録されていません。'
        return
    fi

    while IFS=":" read -ra credential_parts; do
        echo "サービス名：${credential_parts[0]}"
        echo "ユーザー名：${credential_parts[1]}"
        echo "パスワード：${credential_parts[2]}"
    done <<< "$matched_credentials"
}

exit_script() {
    echo 'Thank you!'
    exit 1
}

echo 'パスワードマネージャーへようこそ！'

init_encrypt_file_if_not_exists

while :
do
    read -p '次の選択肢から入力してください(Add Password/Get Password/Exit)：' user_action

    case $user_action in
    'Add Password')
        add_password
        ;;
    'Get Password')
        get_password
        ;;
    'Exit')
        exit_script
        ;;
    *)
        echo '入力が間違えています。Add Password/Get Password/Exit から入力してください。'
    esac
done

