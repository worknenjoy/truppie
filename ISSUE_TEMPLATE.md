### Como chegar no cenário descrito

 - exemplo de que passos são necessários para chegar no passo descrito

## Como realizar esta mudança

### Parte 1: exemplo de onde ir para de fato executar a mudança

### Parte 2: outro passo para realizá-la

Critério de aceitação:

- [ ] Em forma de tarefas para entender melhor os critérios de aceitação (que potencialmente podem se tornar testes automatizados)

### Considerações sobre a plataforma:

- O que é usado na plataforma

### Requisitos para rodar a plataforma

- Ruby
- Postgres
- Se tornar administrador no sistema
(para isto, basta criar um arquivo .env com os campos:

```
 ADMIN_EMAIL=seuemail 
 ADMIN_EMAIL_ALT=outroemail
```

### Como realizar esta tarefa

1. Comente aqui manifestando o interesse em realizar esta tarefa, que entrarei em contato para obter os detalhes para realizar o pagamento
2. [Faça um fork do projeto](http://desenvolvimentoparaweb.com/miscelanea/como-fazer-fork-de-um-projeto-no-github/)
3. Faça um `clone` do projeto para o seu ambiente local

`rake test` (rodar os testes automatizados)

`rails db:migrate` (Rodar as `migrations` para o banco de dados)

`rails s` (Rodar o projeto)

4. Realize as modificações como descrito nesta Issue
5. [Enviar um Pull Request](https://blog.da2k.com.br/2015/02/04/git-e-github-do-clone-ao-pull-request/)
6. Certificar-se de que as modificações [passaram nos testes automatizados](https://blog.da2k.com.br/2015/02/04/git-e-github-do-clone-ao-pull-request/)
7. Um novo **ambiente para testes** será criado para validação das modificações com a nossa equipe
8. Receber os comentários e feedbacks sobre modificações
9. Enviar quaisquer modificações necessárias até ser aprovado
10. Você ganha então um 👍 
10. Quando o _Pull Request_ for finalizado, o **pagamento é enviado**

Se precisar de qualquer ajuda ou tiver qualquer dúvida basta comentar aqui que as dúvidas poderão ser respondidas por qualquer pessoa da comunidade ou quem contribui com o projeto e principalmente eu 👍 

Se quiser se familiarizar com o funcionamento de projetos de software livre, tem este [excelente guia do Tableless](https://tableless.com.br/contribuindo-em-projetos-open-source-com-o-github/)

### Como ter um pull request aceito e integrado da forma correta no projeto

Para que seu Pull Request seja aceito sem maiores problemas e integrado diretamente para que possa ir para produção você deve sempre estar integrado com o master do projeto, **sempre usando rebase como padrão**.

Se tiver dúvidas como fazer isto dá uma olhada aqui [neste post](http://www.arruda.blog.br/programacao/dicas-de-git-integrando-um-branch-no-master-rebase-ou-merge/)

Se precisar de qualquer ajuda ou tiver qualquer dúvida basta comentar aqui que as dúvidas poderão ser respondidas por qualquer pessoa da comunidade ou quem contribui com o projeto e principalmente eu 👍 o 
