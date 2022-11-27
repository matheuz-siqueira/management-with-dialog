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

DeleteUser()
{
  local user=$(dialog --title "Apagar usuário" --stdout --inputbox "Digite o nome" 6 40 )
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
  action=$(dialog --title "Gerenciamento de Usuários" \
                  --stdout \
                  --menu "Escolha uma das opções abaixo:" \
                  0 0 0 \
                  Listar "Lista todos os usuários do sistema" \
                  Inserir "Adiciona um novo usuário no sistema" \
                  Remover "Remove um usuário do sistema")
 [ $? -eq 1 ] && exit 0
 case $action in
   Listar) ListUsers ;;
   Remover) DeleteUser ;;
#  Inserir)  ;;
 esac
done
