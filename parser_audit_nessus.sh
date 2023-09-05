#!/bin/bash

# Nome do arquivo .audit a ser analisado
audit_file="original.audit"

# Variáveis para armazenar informações do controle
type=""
description=""
info=""
solution=""
reference=""
see_also=""
value_type=""
value_data=""
password_policy=""

# Função para analisar o arquivo .audit
parse_audit() {
    while IFS= read -r line; do
        if [[ $line == *"<custom_item>"* ]]; then
            while IFS= read -r subline; do
                if [[ $subline == *"</custom_item>"* ]]; then
                    # Imprimir informações do controle
                    echo "Tipo: $type"
                    echo "Descrição: $description"
                    echo "Informações: $info"
                    echo "Solução: $solution"
                    echo "Referência: $reference"
                    echo "Veja também: $see_also"
                    echo "Tipo de Valor: $value_type"
                    echo "Dados do Valor: $value_data"
                    echo "Política de Senha: $password_policy"
                    echo "=================================================="
                    # Limpar as variáveis para o próximo controle
                    type=""
                    description=""
                    info=""
                    solution=""
                    reference=""
                    see_also=""
                    value_type=""
                    value_data=""
                    password_policy=""
                    break
                else
                    field=$(echo "$subline" | cut -d ':' -f 1 | tr -d '[:space:]')
                    value=$(echo "$subline" | cut -d ':' -f 2-)

                    case "$field" in
                        "type") type="$value" ;;
                        "description") description="$value" ;;
                        "info") info="$value" ;;
                        "solution") solution="$value" ;;
                        "reference") reference="$value" ;;
                        "see_also") see_also="$value" ;;
                        "value_type") value_type="$value" ;;
                        "value_data") value_data="$value" ;;
                        "password_policy") password_policy="$value" ;;
                    esac
                fi
            done
        fi
    done < "$audit_file"
}

# Chamar a função de análise do arquivo .audit
parse_audit