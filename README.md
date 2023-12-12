# Profile-Powershell

### Arquivo profile.ps1

- Importa módulo posh-git
- Funções:
    - **gig** - Importa gitignore
    - **ln** - Cria symlink
    - **rm-bin** - rm pastas bin
    - **rm-directory** - rm pastas
    - **vpn-wsl** - resolve conflito Cisco VPN x WSL
    - **sudo** - executa comando como admin
    - **touch** - cria arquivo
    - **vpn-setup** - conecta na vpn + resolve conflito
    - **vpn-connect** - conecta na vpn
    - **vpn-disconnect** - desconecta da vpn

- Alias:
    - **grep** - findstr
    - **vs** - Visual Studio 2022
    - **k** - kubectl
    - **g** - git
    - **vim**
    - **which** - where

### Arquivo vpn.ps1

- Possibilita fixar alguns valores e configurar a vpn

- Você pode adicioná-lo no PATH