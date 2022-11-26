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
# Exemplo de uso: <Building>                                #
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
#############################################################

#....................VARIÁVEIS....................#
USER="$(whoami)"
TEMP=temp.$$

#....................TESTES....................#
[ "$USER" != "root" ] && echo "ERRO. apenas o usuário root pode executar o programa." && exit 1
[ ! "$(which dialog)" ] && echo "Instalando dependência..." && sudo apt-get install dialog > /dev/null 2>&1


#....................FUNÇÕES....................#

ListUsers()
{
  while read -r line
  do
    [ $(echo $line | cut -d : -f 3) -lt 1000 ] && continue
    [ $(echo $line | cut -d : -f 3) -gt 9999 ] && continue
    nome="$(echo $line | cut -d : -f 1)"
    echo "$nome" >> "$TEMP"
  done < "/etc/passwd"

  dialog --title "Usuários do Sistema" --textbox "$TEMP" 6 40
  rm -f "$TEMP"
}

ValidateUsers()
{
  while read -r line
  do
    [ $(echo $line | cut -d : -f 3) -lt 1000 ] && continue
    [ $(echo $line | cut -d : -f 3) -gt 9999 ] && continue
    users="$(echo $line | cut -d : -f 1)"
    echo "$users" >> "$TEMP"
  done < "/etc/passwd"

  grep -i -q "$1" "$TEMP"
  rm -f "$TEMP"
}

DeleteUser()
{
  local user=$(dialog --title "Apagar usuário" --stdout --inputbox "Digite o nome" 6 40 )
  ValidateUsers "$user"  && {
    deluser "$user" > /dev/null 2>&1
    dialog --title "Sucesso!" --msgbox "Usuário deletado com sucesso!" 0 0
  }
}

CreateUser()
{
  local user=$(dialog --title "Criar usuário" --stdout --inputbox "Digite o nome" 6 40 )
  ValidateUsers "$user" && {
    dialog --title "Erro!" --msgbox "Usuário já existe" 0 0
  }
}

#....................EXECUÇÃO....................#
