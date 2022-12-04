# Manager 

## Motivação

Estudando shell script (e linux) me deparei com uma ferramenta chamada dialog (extremamente importante) que é basicamente uma interface gráfica simples utilizada para compilação e instalação de diversos programas e ferramentas. 

Então tive a ideia de criar um programinha simples que traz uma interface "mais amigável" para gerenciamento de usuários e grupos por meio desse ferramenta.  

---

## Descrição

O programa tem a intenção de transformar os comandos usados para gerenciar usuários e grupos (criar, deletar, etc.) para uma interface gráfica, bastando o usuário digitar apenas o nome dos usuários ou grupos para adicioná-los ou removê-los do sistema.  

## Regras de Negócio

A Ferramenta tem apenas uma regra de negócio:
- Somente o usuário root pode executar o programa

## Funcionalidades 

- Usuários 
  - Listar usuários 
  - Remover usuários 
  - Adicionar usuário a um grupo
  - Remover usuário de um grupo
- Grupos 
  - Listar grupos do sistema 
  - Adiconar grupo no sistema
  - Remover grupo do sistema

--- 

## Tecnologias

- Linux (Ubuntu)
- Shell Script
- Editor Atom
- Editor Vim 

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)![Atom](https://img.shields.io/badge/Atom-%2366595C.svg?style=for-the-badge&logo=atom&logoColor=white)![Vim](https://img.shields.io/badge/VIM-%2311AB00.svg?style=for-the-badge&logo=vim&logoColor=white)

## Exemplo de Uso

````
./manager  
```` 

--- 

## Status do Projeto

![Badge em Desenvolvimento](https://img.shields.io/static/v1?label=STATUS&message=EM%20DESENVOLVIMENTO&color=GREEN&style=for-the-badge)

## Aprendizados 

Trabalhar nesse projeto me possibilitou melhorar um pouco mais minhas skills com linux e shell script, além disso me permitiu aprender a trabalhar com arquivos temporários, verificar e instalar "dependências" para o funcionamento do programa (no caso o dialog), também me pertiu estudar a indentificação de pradrões de arquivos no linux (nesse caso os arquivos /etc/passwd e /etc/group) e tratar exceções para o correto funcionamento do ferramenta. Por fim, por ser um projeto pequeno me possibilitou trabalhar com mais foco em cada uma das funcionalidades (inclusive identificando funcionalidades que não estavam no escopo inicial).


