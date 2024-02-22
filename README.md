# storeapp_dlang
StoreApp escrito em D com acesso ao banco de dados MongoDB (Community)

# Como instalar

storeapp
storeapp/public
storeapp/public/js
storeapp/public/css (arquivos do bootstrap e bootstrap icons)
storeapp/public/css/fonts (arquivos do bootstrap icons)
storeapp/source
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

