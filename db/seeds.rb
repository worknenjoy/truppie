# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@user_data = {
    email: "joana.vmello@gmail.com",
    name: "Joana Mello",
    password: "12345678"
}

@user = User.find_by_email("joana.vmello@gmail.com") if User.find_by_email("joana.vmello@gmail.com").update(@user_data) || User.create(@user_data)

@rio_city_data = {
  name: "Rio de Janeiro",
  city: "Rio de Janeiro",
  state: "RJ",
  country: "Brasil"
}

@rio_city =  Where.find_by_name("Rio de Janeiro") if Where.find_by_name("Rio de Janeiro").update(@rio_city_data) || Where.create(@rio_city_data)

@rio_vidigal_data = {
  name: "Bairro do Vidigal",
  city: "Rio de Janeiro",
  state: "RJ",
  country: "Brasil"
}

@rio_vidigal = Where.find_by_name("Bairro do Vidigal") if Where.find_by_name("Bairro do Vidigal").update(@rio_vidigal_data) || Where.create(@rio_vidigal_data)


@organizer_data = {
    name: "Utópicos Mundo Afora",
    description: "Agência de viagem e bem-estar",
    user: @user,
    email: 'reservas@utopicosmundoafora.com',
    website: 'http://www.utopicosmundoafora.com/',
    instagram: 'https://www.instagram.com/utopicosmundoafora/',
    facebook: 'https://www.facebook.com/utopicosmundoafora/',
    where: @rio_city
}

@organizer = Organizer.find_by_name("Utópicos Mundo Afora") if Organizer.find_by_name("Utópicos Mundo Afora").update(@organizer_data) || Organizer.create(@organizer_data)

@cat_data = {
  name: 'Trilhas & Travessias'
}

@cat = Category.find_by_name('Trilhas & Travessias') if Category.find_by_name('Trilhas & Travessias').update(@cat_data) || Category.create(@cat_data)


@tagone_data = {
  name: 'trilha'
}

@tagone = Tag.find_by_name('trilha') if Tag.find_by_name('trilha').update(@tagone_data) || Tag.create(@tagone_data)

@tagtwo_data = {
  name: 'praia'
}

@tagtwo = Tag.find_by_name('praia') if Tag.find_by_name('praia').update(@tagtwo_data) || Tag.create(@tagtwo_data)


@tagtree_data = {
  name: 'Rio de Janeiro'
}

@tagtree = Tag.find_by_name('Rio de Janeiro') if Tag.find_by_name('Rio de Janeiro').update(@tagtree_data) || Tag.create(@tagtree_data)

#@attraction_one = Attraction.create(
#  name: 'Morro dois irmãos',
#  text: "As praias selvagens é um refugio no rio para quem quer sair das praias badaladas da zona sul",
#  photo: "http://www.trilhaape.com.br/images/programacao/Praias%20selvagens_1.JPG"
#)

@language_default_data = {
  name: 'Português'
}

@language_default = Language.find_by_name('Português') if Language.find_by_name('Português').update(@language_default_data) || Language.create(@language_default_data)

@language_alt_data = {
  name: 'English'
}

@language_alt = Language.find_by_name('English') if Language.find_by_name('English').update(@language_alt_data) || Language.create(@language_alt_data)

@tour_data = {
  title: 'Trilha do Morro Dois Irmãos',
  description: 'O Morro Dois Irmãos - localizado no bairro do Vidigal - proporciona uma linda vista da Zona Sul da cidade (bairros Leblon, Ipanema, Lagoa, Cristo), da Floresta da Tijuca, da Rocinha, das Ilhas Cagarras e de Niterói. Com seus 533 metros de altura, ele é mais alto que o Pão de Açúcar. A trilha é um excelente “esforço-benefício”, já que não é uma caminhada muito longa nem puxada, e o prêmio lá em cima é totalmente recompensador!',
  value: 35,
  currency: 'BRL',
  organizer: @organizer,
  start: '2016-04-10 07:30:00',
  end: '2016-04-10 10:30:00',
  photo: ActionController::Base.helpers.image_url("trilhas/morro_dois_irmaos.jpg"),
  availability: 18,
  minimum: 4,
  maximum: 18,
  difficulty: 3,
  where: @rio_vidigal,
  address: 'Bairro do Vidigal - Rio de Janeiro - RJ',
  user: @user,
  take: ['Tênis ou bota para caminhada', 'Roupas leves', 'Água', 'Lanche para trilha (sugestões: barra de cereal, frutas, biscoitos, sanduiche)','Óculos escuros, chapéu ou boné','Kit de Primeiros Socorros','Repelente e protetor solar', 'Saco de lixo', ],
  goodtoknow: ['O transporte até o ponto de encontro fica por sua conta, ok? Mas nós gostamos de promover a carona solidária (mais detalhes após a reserva)', 'Do ponto de encontro até o ponto de início da trilha, é preciso pegar uma  van (serviço local), que custa R$ 7,00 (ida e volta) e não está incluído no valor do evento - leve dinheiro em espécie;', 'Em caso de chuva, o evento será remarcado. Mas fique tranquilo que ficaremos de olho na previsão do tempo e te avisaremos em tempo hábil!', 'Para dúvidas específicas sobre esta truppie, entre em contato com o guia pelo e-mail informado acima'],
  category: @cat,
  tags: [@tagone, @tagtwo, @tagtree],
  languages: [@language_default, @language_alt],
  meetingpoint: 'Informado após confirmação da reserva'
}

@tour = Tour.find_by_title('Trilha do Morro Dois Irmãos') if Tour.find_by_title('Trilha do Morro Dois Irmãos').update(@tour_data) || Tour.create(@tour_data)

#
# Another truppie
#

@cat_relax_data = {
  name: 'Relax'
}

@cat_relax = Category.find_by_name('Relax') if Category.find_by_name('Relax').update(@cat_relax_data) || Category.create(@cat_relax_data)

@rio_aldeia_data = {
  name: "Aldeia Velha",
  city: "Silva Jardim",
  state: "RJ",
  country: "Brasil"
}

@rio_aldeia = Where.find_by_name("Aldeia Velha") if Where.find_by_name("Aldeia Velha").update(@rio_aldeia_data) || Where.create(@rio_aldeia_data)

@tagwaterfall_data = {
  name: 'cachoeira'
}

@tagwaterfall = Tag.find_by_name('cachoeira') if Tag.find_by_name('cachoeira').update(@tagwaterfall_data) || Tag.create(@tagwaterfall_data)

@tour_aldeia_velha_data = {

  title: 'Banho de Cachoeira, Meditação e Autoconhecimento em Aldeia Velha',
  description: '<p class="spaced-down">Que tal sair da rotina e curtir um dia diferente, meditando e relaxando imerso da natureza, com muito banho de cachoeira para lavar a alma? Este encontro proporcionará um momento de profunda conexão consigo mesmo. </p><h5>Sobre o roteiro:</h5> <p class="spaced-down">Sairemos às 7h30 em uma van rumo à Cachoeira das Sete Quedas, em Aldeia Velha. Depois de um delicioso almoço e um tempo para relaxar, faremos uma meditação, para auxiliar no processo de contato com o mundo interno e equilíbrio através da respiração e fortalecimento da presença. Em seguida, faremos a Rodada do Beija-Flor - uma Leitura de Aura Coletiva - em que cada pessoa recebe uma mensagem sobre o seu momento atual. Por ser um trabalho coletivo, as mensagens de uns vão enriquecendo as mensagens dos outros, formando um grande campo que permite mais clareza, abertura de percepção e insights. Finalizaremos a vivência com partilha, música e mais banho de cachoeira. Retorno previsto para as 17h00.<h5>Sobre a facilitadora:</h5> Mariana Rattes é Terapeuta Holística. Trabalha com Leitura de Aura, Gestalt Terapia e Grupos de Autoconhecimento. Atualmente, se dedica a unir trabalhos terapêuticos e de autoconhecimento individuais e em grupo com arte, poesia, expressividade e o feminino.</p>',
  value: 150,
  currency: 'BRL',
  organizer: @organizer,
  start: '2016-04-17 07:30:00',
  end: '2016-04-17 17:00:00',
  photo: ActionController::Base.helpers.image_url("trilhas/aldeia_velha.jpg"),
  availability: 14,
  maximum: 14,
  where: @rio_aldeia,
  address: 'Cachoeira das 7 quedas, Aldeia Velha, Silva Jardim - Rio de Janeiro - RJ',
  user: @user,
  included: ['Transporte (van) ida e volta a partir de alguns pontos de referência no Rio de Janeiro', 'Entrada na Cachoeira Sete Quedas em Aldeia Velha', 'Almoço', 'Meditação', 'Rodada de Beija-Flor (leitura de aura coletiva)'],
  take: ['Roupa de banho', 'Canga ou toalha', 'Muda de roupa para a volta', 'Repelente e protetor solar','Garrafa de água própria','Saco de lixo'],
  goodtoknow: ['Em caso de chuva, o evento acontecerá normalmente (salvo em caso de tempestade ou alguma situação que prejudique a segurança do evento).', 'Para dúvidas específicas sobre esta truppie, entre em contato com o guia pelo e-mail informado acima.'],
  category: @cat_relax,
  tags: [@tagwaterfall],
  languages: [@language_default, @language_alt],
  meetingpoint: 'Informado após confirmação da reserva'
}

@tour_aldeia_velha = Tour.find_by_title('Banho de Cachoeira, Meditação e Autoconhecimento em Aldeia Velha') if Tour.find_by_title('Banho de Cachoeira, Meditação e Autoconhecimento em Aldeia Velha').update(@tour_aldeia_velha_data) || Tour.create(@tour_aldeia_velha_data)


