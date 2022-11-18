# projeto1-filipe
Tutorial Git

Arquivos de Texto inseridos via git, utilizei usuário sem permissões administrativas, nesse caso foi necessário permitir acesso total na pasta de instalação do Git;
Outro ponto importante, o computador que utilizo possuí exploit ativado, também foi necessário executar os comandos abaixo como exceção no powershell;
OBS: Verificar o caminho de instalação do git, depis abra o powershell com privilégios administrativos; 
$files = (Get-ChildItem 'C:\Program Files\Git\usr\bin\*.exe').FullName
$files.ForEach({Set-ProcessMitigation $_ -Disable ForceRelocateImages})

Terceiro repositório criado;