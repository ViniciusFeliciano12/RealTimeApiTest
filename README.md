# Chat with real-time API.

Projeto de teste para criação de uma Real-Time API, e uma aplicação web em flutter que consuma essa API realizando um chat ao vivo. A API maneja banco de dados.


# Tutorial:

Instale o .net e o flutter na sua máquina.

Crie um arquivo chamado ".env" na pasta "SignalServer", e dentro dele siga o exemplo do ".env-example" para definir a ConnectionString do seu banco de dados. As tabelas já devem estar criadas, mas você pode usar "dotnet ef database update" para criar automaticamente as tabelas caso a ConnectionString esteja correta.

No terminal do projeto, digite "ls" para listar todos os diretórios. 
Entre no SignalServer com o comando "cd SignalServer"
Comando "dotnet watch run" para iniciar.

Crie um arquivo chamado ".env.json" dentro de PlataformaRPG. Esse arquivo deve seguir o modelo descrito em ".env_example.json", contendo o endereço IP da sua máquina
e a porta que será gerada pela API com / no fim. Este será um arquivo local para gerenciar a chave da API que você usará.

Abra um novo terminal.
Digite "ls" para listar os diretórios.
"cd PlataformaRPG"
Digite o comando "flutter run --dart-define-from-file=.env.json --debug -d web-server --web-hostname 0.0.0.0 --web-port 8989"

Este comando iniciará o bate-papo em um web-server na porta 8989 em todos os endereços IP da sua máquina, utilizando o arquivo ".env.json" para identificar a porta da API.
Para entrar nele, digite o seu endereço IP com a porta 8989 após inicializar.
Para iniciar em release, altere "--debug -d" por "--release -d".