# Chat with real-time API.

Projeto de teste para criação de uma Real-Time API, e uma aplicação web em flutter que consuma essa API realizando um chat ao vivo. A API maneja banco de dados.

# Tutorial:

Dentro de Program.cs na folder SignalServer, você deve especificar a ConnectionString para o banco de dados da sua máquina. As tabelas já devem estar criadas, mas
você pode usar dotnet migration para criar automaticamente.

No terminal do projeto, digite "ls" para listar todos os diretórios. 
Digite "cd SignalServer"
dotnet watch run

Abra um novo terminal.
Digite "ls" para listar os diretórios.
"cd PlataformaRPG"
Digite "flutter run --dart-define-from-file=.env.json --debug -d web-server --web-hostname 0.0.0.0 --web-port 8989"