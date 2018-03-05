### How to reproduze the user scenario

 - Necessary steps to achieve the user context

### Design or screenshot attached

 - Get a design with the feature or a screenshot to reproduce the scenario

## Instructions of how to made the change proposal

Acceptance criteria

- [ ] Em forma de tarefas para entender melhor os critérios de aceitação (que potencialmente podem se tornar testes automatizados)
- [ ] Tasks with the acceptance criteria (That maybe turn into automated tests)

### Platform:

- Whats is used on the platform

### Requirements to run the project

- Ruby
- Postgres
- Be adminstrator
You need to create the `.env` file:

```
 ADMIN_EMAIL=youremail
 ADMIN_EMAIL_ALT=othermail
```

### How to work on this task

1. Make a comment here
2. You will be invited and be assign to the task
2. [Fork the project](https://help.github.com/articles/fork-a-repo/)
3. Clone the repo with `git clone` and run `rails s` to start the project

`rake test` (run tests and make sure is green)

`rails db:migrate` (Run the `migrations` for the database)

`rails s` (Rodar o projeto)

4. Make the necessary changes to this issue
5. [Send a pull request](https://help.github.com/articles/about-pull-requests/)
6. Verify if your changes didn't break the [automated tests](http://guides.rubyonrails.org/testing.html)
7. A new **application** will be created to be validated
8. You will receive feedback from team members
9. You will send changes until is approved
10. You get a approve 👍 
10. When the _Pull Request_ is merged, if is a paid task, the **payment is send**

If you have any doubt or need help just comment and you will be supported


### How to avoid issues when send the pull request

Para que seu Pull Request seja aceito sem maiores problemas e integrado diretamente para que possa ir para produção você deve sempre estar integrado com o master do projeto, **sempre usando rebase como padrão**.
You should be always up to date to the upstream master and use ***always rebase as default***

If you have doubts about it see [this post](http://www.arruda.blog.br/programacao/dicas-de-git-integrando-um-branch-no-master-rebase-ou-merge/)
