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
    description: "Não há ferramenta melhor para planejar uma viagem do que blog de mochileiro. Nele encontramos todas as informações importantes acerca de preços, meios de transporte, segurança e programas imperdíveis para além daqueles roteiros já manjados.",
    members: [@member],
    user: @user,
    website: 'http://utopicos.com.br'
)

@where = Where.create(
  name: "Barra da Tijuca",
  city: "Rio de Janeiro",
  state: "Rio de Janeiro",
  country: "Rio de Janeiro"
)

@cat = Category.create(
  name: 'Trilha'
)

@tagone = Tag.create(
  name: 'montanha'
)

@tagtwo = Tag.create(
  name: 'praia'
)

@attraction_one = Attraction.create(
  name: 'Praias Selvagens',
  text: "As praias selvagens e um refugio no rio para quem quer sair das praias badaladas da zona sul",
  photo: "http://www.trilhaape.com.br/images/programacao/Praias%20selvagens_1.JPG"
)

@attraction_two = Attraction.create(
  name: 'Pedra do Telegrafo',
  text: "A pedra do telegrafo e famosa pela foto das pessoas parecerem que estao penduradas",
  photo: "https://media-cdn.tripadvisor.com/media/photo-s/07/59/12/ba/adrenalina-pura.jpg"
)

@language = Language.create(
  name: 'Portugues'
)

@tour = Tour.create(

  title: 'Subida a Pedra do Telegrafo',
  description: 'A pedidos, vamos subir a pedra do telegrafo',
  value: 45,
  currency: 'BRL',
  organizer: @organizer,
  start: '2016-03-12 06:00:00',
  end: '2016-03-12 12:00:00',
  photo: 'http://1.bp.blogspot.com/-RRVQXEOr2Fg/VZtDRtAOo_I/AAAAAAAAFOo/6bCSAYsqeL4/s640/DSC00279.JPG',
  availability: 7,
  minimum: 2,
  maximum: 7,
  difficulty: 2,
  where: @where,
  address: 'praia de grumari, s/n',
  user: @user,
  included: 'carona solidaria',
  nonincluded: 'comida',
  category: @cat,
  tags: [@tagone, @tagtwo],
  attractions: [@attraction_one, @attraction_two],
  languages: [@language],
  meetingpoint: 'Praia da Barra'
)


