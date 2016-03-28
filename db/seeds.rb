# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@user = User.create(
    email: "joana.vmello@gmail.com",
    password: "12345678"
)

@rio_city = Where.create(
  name: "Rio de Janeiro",
  city: "Rio de Janeiro",
  state: "RJ",
  country: "Brasil"
)

@rio_vidigal = Where.create(
  name: "Bairro do Vidigal",
  city: "Rio de Janeiro",
  state: "RJ",
  country: "Brasil"
)

@organizer = Organizer.create(
    name: "Utópicos Mundo Afora",
    description: "Agência de viagem e bem-estar",
    user: @user,
    email: 'reservas@utopicosmundoafora.com',
    website: 'http://www.utopicosmundoafora.com/',
    instagram: 'https://www.instagram.com/utopicosmundoafora/',
    facebook: 'https://www.facebook.com/utopicosmundoafora/',
    where: @rio_city
)

@cat = Category.create(
  name: 'Trilhas & Travessias'
)

@tagone = Tag.create(
  name: 'trilha'
)

@tagtwo = Tag.create(
  name: 'praia'
)

@tagtree = Tag.create(
  name: 'Rio de Janeiro'
)

#@attraction_one = Attraction.create(
#  name: 'Morro dois irmãos',
#  text: "As praias selvagens é um refugio no rio para quem quer sair das praias badaladas da zona sul",
#  photo: "http://www.trilhaape.com.br/images/programacao/Praias%20selvagens_1.JPG"
#)

@language_default = Language.create(
  name: 'Português'
)

@language_alt = Language.create(
  name: 'English'
)

@tour = Tour.create(

  title: 'Trilha do Morro Dois Irmãos',
  description: 'O Morro Dois Irmãos - localizado no bairro do Vidigal - proporciona uma linda vista da Zona Sul da cidade (bairros Leblon, Ipanema, Lagoa, Cristo), da Floresta da Tijuca, da Rocinha, das Ilhas Cagarras e de Niterói. Com seus 533 metros de altura, ele é mais alto que o Pão de Açúcar. A trilha é um excelente “esforço-benefício”, já que não é uma caminhada muito longa nem puxada, e o prêmio lá em cima é totalmente recompensador!',
  value: 38,
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
  goodtoknow: ['O transporte até o ponto de encontro fica por sua conta, ok? Mas nós gostamos de promover a carona solidária (mais detalhes após a reserva)', 'Do ponto de encontrato até o ponto de início da trilha, é preciso pegar uma  van (serviço local), que custa aproximadamente R$6,00 (ida e volta) e não está incluído no valor do evento - leve dinheiro em espécie', 'Em caso de chuva, o evento será remarcado. Mas fique tranquilo que ficaremos de olho na previsão do tempo e te avisaremos em tempo hábil!', 'Para dúvidas específicas sobre esta truppie, entre em contato com o guia pelo e-mail informado acima'],
  category: @cat,
  tags: [@tagone, @tagtwo, @tagtree],
  languages: [@language_default, @language_alt],
  meetingpoint: 'Informado após confirmação da reserva'
)


