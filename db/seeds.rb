# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@user = User.create(
    email: "joanautopicos@gmail.com",
    password: "12345678"
)

@user_member = User.create(
    email: "paola@gmail.com",
    password: "12345678"
)

@member = Member.create(
    user: @user_member
)

@organizer = Organizer.create(
    name: "Utopicos Mundo afora",
    description: "Agência de viagem e bem-estar",
    members: [@member],
    user: @user,
    email: 'reservas@utopicosmundoafora.com',
    website: 'http://www.utopicosmundoafora.com/'
)

@where = Where.create(
  name: "Barra de Guaratiba",
  city: "Rio de Janeiro",
  state: "RJ",
  country: "Brasil"
)

@cat = Category.create(
  name: 'Trilha'
)

@tagone = Tag.create(
  name: 'trilha'
)

@tagtwo = Tag.create(
  name: 'praia'
)

@attraction_one = Attraction.create(
  name: 'Praias Selvagens',
  text: "As praias selvagens é um refugio no rio para quem quer sair das praias badaladas da zona sul",
  photo: "http://www.trilhaape.com.br/images/programacao/Praias%20selvagens_1.JPG"
)

@attraction_two = Attraction.create(
  name: 'Barra de Guaratiba',
  text: "A Barra de Guaratiba, bairro situado na zona oeste do Rio de Janeiro, conta com lindas praias, mangues e morros com muita Mata Atlântica. Há opções de trilhas que levam a mirantes com uma vista exuberante das Praias Selvagens, Pontal do Recreio, Grumari e toda a Restinga da Marambaia.",
  photo: "http://www.etrilhas.com.br/static/media/display/marapendi03_1.jpg"
)

@language = Language.create(
  name: 'Portugues'
)

@tour = Tour.create(

  title: 'Trilha da Pedra do Telégrafo',
  description: 'A Pedra do Telégrafo ficou famosa pelas fotos criativas e aparentemente perigosas que as pessoas tiram nela. A trilha para chegar até lá tem aproximadamente 3km (ida e volta).<br />Recomendações:<br/> Calçar bota ou tênis de caminhada<br />Levar água, repelente, protetor solar e corta vento<br />Não esquecer documentação (Identidade e carteira de plano de saúde)',
  value: 45,
  currency: 'BRL',
  organizer: @organizer,
  start: '2016-03-27 07:00:00',
  end: '2016-03-27 12:00:00',
  photo: 'http://mochilando.com.br/wp-content/uploads/2015/05/pedra-do-telegrafo-rj-dicas.jpg',
  availability: 20,
  minimum: 5,
  maximum: 20,
  difficulty: 3,
  where: @where,
  address: 'Barra de Guaratiba - Rio de Janeiro - RJ',
  user: @user,
  included: 'carona solidaria',
  nonincluded: 'Alimentação, Transporte',
  category: @cat,
  tags: [@tagone, @tagtwo],
  attractions: [@attraction_one, @attraction_two],
  languages: [@language],
  meetingpoint: 'Informado após a confirmação'
)


