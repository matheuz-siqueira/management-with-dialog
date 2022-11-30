#!/usr/bin/env bash

#############################################################
# script: manager.sh - gerenciador de usuários              #
#                                                           #
# Autor: Matheus Siqueira (matheussiqueira.work@gmail.com)  #
# Mantenedor: Matheus Siqueira                              #
#...........................................................#
# Descrição: O programa gerencia a insereção e remoção de   #
#            usuários e grupos no sistema                   #
#...........................................................#
# Exemplo de uso: ./manager.sh                              #
#...........................................................#
# Testado em: 5.1.16                                        #
#...........................................................#
# Histórico:                                                #
#          24/11/2022, Matheus                              #
#            - Criação do programa                          #
#            - Função listar usuários                       #
#          24/11/2022, Matheus                              #
#            - Função Valida Usuário                        #
#            - Função Deletar Usuaŕio                       #
#          27/11/2022, Matheus                              #
#            - Função Deletar Usuário (correção)            #
#            - Adicionando menu                             #
#            - Adicionando flag de versão                   #
#          29/11/2022, Matheus                              #
#            - Melhorando função menu                       #
#            - Função Adicionar Grupo                       #
#            - Função Listar Grupos                         #
#            - Função Remover Grupo                         #
#############################################################

#....................VARIÁVEIS....................#
USER="$(whoami)"
TEMP=temp.$$
SEP=:
VERSION="v1.0"
#....................TESTES....................#
[ "$USER" != "root" ] && echo "ERRO. apenas o usuário root pode executar o programa." && exit 1
[ ! "$(which dialog)" ] && echo "Instalando dependência..." && sudo apt-get install dialog > /dev/null 2>&1
#....................FUNÇÕES....................#

ListUsers()
{
  while read -r line
  do
    [ $(echo $line | cut -d $SEP -f 3) -lt 1000 ] && continue
    [ $(echo $line | cut -d $SEP -f 3) -gt 9999 ] && continue
    nome="$(echo $line | cut -d $SEP -f 1)"
    echo "$nome" >> "$TEMP"
  done < "/etc/passwd"

  dialog --title "Usuários do Sistema" --textbox "$TEMP" 6 40
  rm -f "$TEMP"
}

ValidateUsers()
{
  while read -r line
  do
    [ $(echo $line | cut -d $SEP -f 3) -lt 1000 ] && continue
    [ $(echo $line | cut -d $SEP -f 3) -gt 9999 ] && continue
    users="$(echo $line | cut -d $SEP -f 1)"
    echo "$users" >> "$TEMP"
  done < "/etc/passwd"

  grep -i -q "$1" "$TEMP"
  return $[ $? ]

}

Deleteuser()
{
  local user=$(dialog --title "Apagar usuário" --stdout --inputbox "Digite o nome" 6 40 )

  user=$(echo "$user" | tr [A-Z] [a-z])
  ValidateUsers "$user"
  if [ $? -eq 0 ]
  then
    deluser "$user" > /dev/null 2>&1
    dialog --title "Sucesso!" --msgbox "usuário removido com sucesso!" 6 40
  else
    dialog --title "Erro!" --msgbox "Usuário inexistente!" 6 40
  fi
  rm -f "$TEMP"
}


ValidateGroups()
{
  while read -r line
  do
    [ $(echo $line | cut -d $SEP -f 3) -lt 1000 ] && continue
    [ $(echo $line | cut -d $SEP -f 3) -gt 9999 ] && continue
    groups="$(echo $line | cut -d $SEP -f 1)"
    echo "$groups" >> "$TEMP"
  done < "/etc/group"

  grep -i -q "$1" "$TEMP"
  return $[ $? ]
}

ListGroup()
{
  while read -r line
  do
     [ $(echo $line | cut -d $SEP -f 3 ) -lt 1000 ] && continue
     [ $(echo $line | cut -d $SEP -f 3 ) -gt 9999 ] && continue
     group=$(echo "$line" | cut -d $SEP -f 1)
     echo "$group" >> "$TEMP"
  done < "/etc/group"

  dialog --title "Grupos do Sistema" --textbox "$TEMP" 6 40
  rm -f "$TEMP"
}

CreateGroup()
{
  group_name=$(dialog --title "Criar usuário" --stdout --inputbox "Digite o nome do grupo" 6 40)
  group_name=$(echo "$group_name" | tr [A-Z] [a-z])
  ValidateGroups "$group_name" || {
    addgroup "$group_name" > /dev/null 2>&1
    dialog --title "Sucesso!" --msgbox "Grupo criado com sucesso!" 0 0
    rm -rf "$TEMP" && return
  }
  dialog --title "Erro!" --msgbox "Grupo já existe no sistema!" 0 0

  rm -rf "$TEMP"

}

DeleteGroup()
{
  group_name=$(dialog --title "Criar usuário" --stdout --inputbox "Digite o nome do grupo" 6 40)
  group_name=$(echo "$group_name" | tr [A-Z] [a-z])
  ValidateGroups "$group_name" && {
    delgroup "$group_name" > /dev/null 2>&1
    dialog --title "Sucesso!" --msgbox "Grupo removido com sucesso!" 0 0
    rm -f "$TEMP" && return
  }
  dialog --title "Erro!" --msgbox "Grupo inexistente!" 0 0

  rm -rf "$TEMP"

}


#....................EXECUÇÃO....................#

if [ ! -z $1 ]
then
  while getopts "v" OPT
  do
    case "$OPT" in
      "v") echo "$VERSION";;
    esac
  done
  exit 0
fi

while :
do
  option=$(dialog --title "Gerenciamento" \
                  --stdout \
                  --menu "Escolha uma das opções abaixo:" \
                  0 0 0 \
                  usuarios "Gerenciamento de Usuários" \
                  grupos "Gerenciamento de Grupos")

  [ $? -eq 1 ] && exit
  case $option in
    usuarios)
      while :
      do
        action=$(dialog --title "Gerenciamento de Usuários" \
                        --stdout \
                        --menu "Escolha uma das opções abaixo:" \
                        0 0 0 \
                        Listar "Lista todos os usuários do sistema" \
                        Inserir "Adiciona um novo usuário no sistema" \
                        Remover "Remove um usuário do sistema")
       [ $? -ne 0 ] && break;
       case $action in
         Listar) ListUsers ;;
         Remover) Deleteuser ;;
      #  Inserir)  ;;
       esac
      done
    ;;
    grupos)
      while :
      do
        action=$(dialog --title "Gerenciamento de Grupos" \
                        --stdout \
                        --menu "Escolha uma das opções abaixo:" \
                        0 0 0 \
                        Listar "Listar grupos do sistema" \
                        Inserir "Inserir grupo no sistema" \
                        Remover "Remover um grupo do sistema")
        [ $? -ne 0 ] && break
        case $action in
          Listar) ListGroup ;;
          Inserir) CreateGroup ;;
          Remover) DeleteGroup ;;
        esac
      done
    ;;
  esac
done
