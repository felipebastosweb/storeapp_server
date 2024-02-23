# storeapp_dlang
StoreApp escrito em D com acesso ao banco de dados MongoDB (Community)

Esse trabalho visa construir um aplicativo do tipo binário para gestão de lojas de comércio (ou pequenas fábricas artesanais), que consiga rodar um computadores de 32 e 64 bits com alto desempenho, sendo que o banco de dados, por questão de suporte de hardware, deverá estar em um computador de 64 bits. Foi observado em análise prévia que a maioria das linguagens de programação não dão mais suporte a computadores de 32 bits, o que não acontece com a linguagem D que ainda é compatível com esse tipo de hardware. Foi observado também que linguagens de programação como o Ruby, que apresenta bom desempenho no desenvolvimento do sistema pela equipe apresenta um péssimo rendimento em execução do sistema em computadores de 64 bits, tornando assim o custo computacional muito alto. Desta forma, a linguagem de programação D foi escolhida por se tratar de uma linguagem com recursos modernos, ser orientada a objetos, e apresentar ótimo rendimento em tempo de execução tanto em hardwares de 32 quanto de 64 bits (i386 e amd64). Isto se mostrou um fator muito importante no aproveitamento do poder computacional de dispositivos como netbooks e computadores mais antigos em lojas de pequeno porte. Ou nos foi permitido pensar, até mesmo, no aproveitamento de recursos computacionais em países pobres através de sucatas de informática. Desta forma, fica explícito também o carater social desse projeto ao qual visa abranger a inclusão tecnológica de todos os países, principalmente os mais pobres ou as populações mais carentes.

# Como instalar
Para instalar à partir do código-fonte basta baixar esse projeto (git clone), ou fazer o download e extrair do arquivo zip, e ao abrir o console ou shell na pasta do projeto executar o comando dub --build, caso deseje apenas que compile ou o comando dub para compilar e executar. Caso você deseje apenas fazer o download do arquivo binário (storeapp.exe) basta baixar o arquivo na seção de releases localizada à direita dessa página --->>.

Para fazer a atualização do projeto basta baixar o arquivo binário storeapp.exe na seção de releases ou baixar o código-fonte do projeto e fazer conforme já indicado para recompilar.

storeapp
storeapp/dub.json
storeapp/public
storeapp/public/js
storeapp/public/css (arquivos do bootstrap e bootstrap icons)
storeapp/public/css/fonts (arquivos do bootstrap icons)
storeapp/source
storeapp/source/apis
storeapp/source/controllers
storeapp/source/models
storeapp/views

# Rodar
Execute o comando dub na pasta storeapp que irá compilar e executar o .exe. Depois, basta executar o .exe. Caso não queira compilar novamente basta abrir o executável no shell ou console de sua preferência (Prompt de Comandos, Power Shell, etc) usando o comando: .\storeapp.exe.

Abra a página http://localhost:8080 no navegador.

# O que já funciona
Aqui estão descritas algumas das telas que já estão funcionando (falta fazer o print das demais telas de CRUD destes recursos).

## Tela Principal
A tela principal tem os principais recursos do sistema
![Tela principal](https://github.com/felipebastosweb/storeapp_dlang/blob/main/screenshots/home.png)

## Tela de Lista de Usuários
A Tela com a lista de usuários exibe os usuários cadastrados no sistema
![Tela de Lista de Usuários](https://github.com/felipebastosweb/storeapp_dlang/blob/main/screenshots/users_index.png)

## Tela de Lista de Marcas
Essa tela lista as marcas de produtos cadastradas no sistema
![Tela de Lista de Marcas](https://github.com/felipebastosweb/storeapp_dlang/blob/main/screenshots/brands_index.png)

## Tela de Lista de Fornecedores
A Tela com a lista de usuários exibe os fornecedores cadastrados no sistema. A lista de fornecedores visa auxiliar o lojista a identificar as compras de produtos para revenda ou de insumos de produção.
![Tela de Lista de Fornecedores](https://github.com/felipebastosweb/storeapp_dlang/blob/main/screenshots/suppliers_index.png)

## Tela de Lista de Produtos

![Tela de Lista de Fornecedores](https://github.com/felipebastosweb/storeapp_dlang/blob/main/screenshots/products_index.png)

## Tela de Lista de Compras

# O que será produzido em breve
Estes são os próximos recursos a serem desenvolvidos no sistema:
  - Autenticação de Usuário e Permissão
  - Adição de Itens à Compra efetuada
  - Cadastro de Pagamento da Compra (forma de pagamento, data de pagamento, datas de parcelas do cartão)
  - Cancelamento de Compra
  - Cadastro de Clientes
  - Gráfico de Crescimento de Cadastro de Clientes na Tela Home
  - Cadastro de Pedidos
  - Gráfico de Crescimento de Pedidos na Tela Home
  - Adição de Itens ao Pedido efetuado pelo Cliente
  - Cancelamento de Pedido
  - Cadastro de Pagamento efetuados ao Pedido
  - Cadastro de Contas à Pagar
  - Cadastro de Contas à Receber

