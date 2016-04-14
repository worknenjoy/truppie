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

@user = User.find_by_email("joana.vmello@gmail.com") if User.find_by_email("joana.vmello@gmail.com").try(:update,@user_data) || User.create(@user_data)

@rio_city_data = {
  name: "Rio de Janeiro",
  city: "Rio de Janeiro",
  state: "RJ",
  country: "Brasil"
}

@rio_city =  Where.find_by_name("Rio de Janeiro") if Where.find_by_name("Rio de Janeiro").try(:update, @rio_city_data) || Where.create(@rio_city_data)

@rio_vidigal_data = {
  name: "Bairro do Vidigal",
  city: "Rio de Janeiro",
  state: "RJ",
  country: "Brasil"
}

@rio_vidigal = Where.find_by_name("Bairro do Vidigal") if Where.find_by_name("Bairro do Vidigal").try(:update,@rio_vidigal_data) || Where.create(@rio_vidigal_data)


@organizer_data = {
    name: "Utópicos Mundo Afora",
    description: "Agência de viagem e bem-estar",
    user: @user,
    email: 'reservas@utopicosmundoafora.com',
    website: 'http://www.utopicosmundoafora.com/',
    instagram: 'https://www.instagram.com/utopicosmundoafora/',
    facebook: 'https://www.facebook.com/utopicosmundoafora/',
    where: @rio_city,
    logo: ActionController::Base.helpers.image_url("logo_utopicos.png")
}

@organizer = Organizer.find_by_name("Utópicos Mundo Afora") if Organizer.find_by_name("Utópicos Mundo Afora").try(:update,@organizer_data) || Organizer.create(@organizer_data)

@cat_data = {
  name: 'Trilhas & Travessias'
}

@cat = Category.find_by_name('Trilhas & Travessias') || Category.create(@cat_data)


@tagone_data = {
  name: 'trilha'
}

@tagone = Tag.find_by_name('trilha') || Tag.create(@tagone_data)

@tagtwo_data = {
  name: 'praia'
}

@tagtwo = Tag.find_by_name('praia') || Tag.create(@tagtwo_data)


@tagtree_data = {
  name: 'Rio de Janeiro'
}

@tagtree = Tag.find_by_name('Rio de Janeiro') || Tag.create(@tagtree_data)

#@attraction_one = Attraction.create(
#  name: 'Morro dois irmãos',
#  text: "As praias selvagens é um refugio no rio para quem quer sair das praias badaladas da zona sul",
#  photo: "http://www.trilhaape.com.br/images/programacao/Praias%20selvagens_1.JPG"
#)

@language_default_data = {
  name: 'Português'
}

@language_default = Language.find_by_name('Português') || Language.create(@language_default_data)

@language_alt_data = {
  name: 'English'
}

@language_alt = Language.find_by_name('English') || Language.create(@language_alt_data)

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
  meetingpoint: 'Informado após confirmação da reserva',
  status: 'P'
}

@tour = Tour.find_by_title('Trilha do Morro Dois Irmãos') if Tour.find_by_title('Trilha do Morro Dois Irmãos').try(:update,@tour_data) || Tour.create(@tour_data)

#
# Another truppie
#

@cat_relax_data = {
  name: 'Relax'
}

@cat_relax = Category.find_by_name('Relax') || Category.create(@cat_relax_data)

@rio_aldeia_data = {
  name: "Aldeia Velha",
  city: "Silva Jardim",
  state: "RJ",
  country: "Brasil"
}

@rio_aldeia = Where.find_by_name("Aldeia Velha") || Where.create(@rio_aldeia_data)

@tagwaterfall_data = {
  name: 'cachoeira'
}

@tagwaterfall = Tag.find_by_name('cachoeira') || Tag.create(@tagwaterfall_data)

@tour_aldeia_velha_data = {

  title: 'Banho de Cachoeira, Meditação e Autoconhecimento',
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
  meetingpoint: 'Informado após confirmação da reserva',
  status: 'P'
}

@tour_aldeia_velha = Tour.find_by_title('Banho de Cachoeira, Meditação e Autoconhecimento') if Tour.find_by_title('Banho de Cachoeira, Meditação e Autoconhecimento em Aldeia Velha').try(:update,@tour_aldeia_velha_data) || Tour.create(@tour_aldeia_velha_data)


#
# Marins, the last one seeding. Case of packages
#

@user_moura_data = {
    email: "contato@mantiex.com.br",
    name: "Carlos Moura",
    password: "12345678"
}

@user_moura = User.find_by_email("contato@mantiex.com.br") if User.find_by_email("contato@mantiex.com.br").try(:update,@user_moura_data) || User.create(@user_moura_data)

@local_piquete_data = {
  name: "Piquete",
  city: "Piquete",
  state: "SP",
  country: "Brasil"
}

@local_piquete = Where.find_by_name("Piquete") || Where.create(@local_piquete_data)

@cachoeira_paulista_city_data = {
  name: "Cachoeira Paulista",
  city: "Cachoeira Paulista",
  state: "SP",
  country: "Brasil"
}

@cachoeira_paulista_city = Where.find_by_name("Cachoeira Paulista") || Where.create(@cachoeira_paulista_city_data)

@organizer_mantiex_data = {
    name: "Mantiqueira Expedições",
    description: "Agência especializada na Serra da Mantiqueira",
    user: @user_moura,
    phone: '(12) 3103-4521 e (12) 98109-3292',
    email: 'contato@mantiex.com.br',
    website: 'http://mantiex.com.br',
    twitter: '@mantiex',
    logo: ActionController::Base.helpers.image_url("logos/mantiex.png"),
    facebook: 'https://www.facebook.com/gomantiex',
    where: @cachoeira_paulista_city
}

@organizer_mantiex = Organizer.find_by_name("Mantiqueira Expedições") if Organizer.find_by_name("Mantiqueira Expedições").try(:update,@organizer_mantiex_data) || Organizer.create(@organizer_mantiex_data)

@tag_mantiqueira_data = {
  name: 'mantiqueira'
}

@tag_mantiqueira = Tag.find_by_name('mantiqueira') || Tag.create(@tag_mantiqueira_data)

@tag_montanhismo_data = {
  name: 'montanhismo'
}

@tag_montanhismo = Tag.find_by_name('montanhismo') || Tag.create(@tag_montanhismo_data)

@tag_acampamento_data = {
  name: 'acampamento'
}

@tag_acampamento = Tag.find_by_name('acampamento') || Tag.create(@tag_acampamento_data)

@language_esp_data = {
  name: 'Espanhol'
}

@language_esp = Language.find_by_name('Espanhol') || Language.create(@language_esp_data)

@basico_data = {
  name: "Básico",
  value: 228,
  included: ["Dois guias capacitados;", "Comunicador/Rastreador Satelital de Segurança SPOT GEN3;", "Jantar na montanha*;", "Utensílios coletivos de cozinha: panelas, fogareiro, combustível, etc.;"]
}

@basico = Package.find_by_name('Básico') || Package.create(@basico_data)

@completo_data = {
  name: "Completo",
  value: 348,
  included: ["Um pernoite em quarto compartilhado em Cachoeira Paulista - SP (com café da manhã);", "Transporte in/out em veículo 4X4 a partir de Cachoeira Paulista;", "Dois guias capacitados;", "Comunicador/Rastreador Satelital de Segurança SPOT GEN3;", "Jantar na montanha*;", "Utensílios coletivos de cozinha: panelas, fogareiro, combustível, etc.;", "Estacionamento fechado em Cachoeira Paulista;", "Banho quente no final da trip;"]
}

@completo = Package.find_by_name('Completo') || Package.create(@completo_data)

@tour_marins_data = {

  title: 'Trekking e acampamento no Pico dos Marins',
  description: '<p class="spaced-down">Com exatos 2420,7 metros acima do nível do mar, o Pico dos Marins está entre as dez maiores montanhas do estado de São Paulo. Ficou nacionalmente conhecida em 1982, com o desaparecimento de um escoteiro nas proximidades do Morro do Careca (laje de pedra na base do Marins) e desde então vem sendo procurada por mais e mais pessoas. O impressionante visual de 360° do seu cume - com vista para a Serra Fina, o Vale do Paraíba, a Serra da Bocaina e as montanhas do sul de Minas Gerais, além dos espetaculares pôr e nascer do sol - faz do Pico dos Marins o desejo de muitos montanhistas. Embora bastante acessado, o trekking ao Pico dos Marins não pode ser considerado fácil, uma vez que exige bastante esforço físico do trekker, além de conter rampas íngremes de pedra e lances de escalaminhada.</p><h5>DISTÂNCIA, ALTIMETRIA E TEMPO DE PERCURSO:</h5><ul><li>Distância: 6,5 km (desde a Base Marins até o Pico dos Marins)</li><li>Altitude Base Marins: 1542 m</li><li>Altitude Pico dos Marins: 2421m</li><li>Ganho de Elevação: 879m</li><li>Tempo de Percurso: 7 horas</li></ul><h5>Programação detalhada</h5><ul><li>SEXTA-FEIRA – 17/06: Após as 18h00 – Pousada em Cachoeira Paulista.</li><li>SÁBADO – 18/06 – Cachoeira Paulista x Pico dos Marins:</li><li><p>05h00 – Café da manhã na pousada;</p><p>06h00 – Saída da Pousada em Cachoeira Paulista e saída em direção à Base</p><p>Marins (onde ficará o carro/início da trilha);</p><p>08h00 – Chegada Base Marins, alongamento;</p><p>08h30 – Início do trekking;</p><p>14h30 – Chegada no Pico dos Marins;</p><p>18h00 – Início da preparação da janta.</p></li><li>DOMINGO – 19/06 – Pico dos Marins x Cachoeira Paulista:</li><li><p>0h30 – Despertar;</p><p>06h30 – Café da manhã;</p><p>08h00 – Desmontar acampamento;</p><p>09h00 – Início da descida</p><p>09h00 – Início da descida</p><p>15h00 – Chegada Base Marins;</p><p></p>16h00 – Retorno Cachoeira Paulista;</li><li>17h30 – Chegada Pousada Clara Luz Cachoeira Paulista e final da operação.</li></ul>',
  currency: 'BRL',
  organizer: @organizer_mantiex,
  start: '2016-06-18 17:30:00',
  end: '2016-06-19 17:30:00',
  photo: ActionController::Base.helpers.image_url("trilhas/marins.png"),
  availability: 10,
  minimum: 7,
  maximum: 10,
  where: @local_piquete,
  difficulty: 4,
  address: 'Cachoeira Paulista - SP',
  user: @user_moura,
  included: ['Um pernoite em quarto compartilhado em Cachoeira Paulista - SP (com café da manhã);', 'Transporte in/out em veículo 4X4 a partir de Cachoeira Paulista;', 'Dois guias capacitados;', "Comunicador/Rastreador Satelital de Segurança SPOT GEN3;", "Jantar na montanha;", "Utensílios coletivos de cozinha: panelas, fogareiro, combustível, etc.;", "Estacionamento fechado em Cachoeira Paulista;", "Banho quente no final da trip."],
  nonincluded: ['Lanche de trilha e café da manhã na montanha;', 'Seguro contra acidentes pessoais.'],
  take: ["Mochila cargueira - de 50 a 60L;", "Barraca;", "Saco de dormir - conforto mínimo 5°C, preferência 0°C;", "Isolante térmico com espessura mínima de 1cm - prefira inflável;","Lanterna - prefira headlamp (lanterna de cabeça) pela praticidade;", "Um par de bastões de caminhada - equilíbrio, estabilidade, reduz impacto nas articulações e o sobrepeso dos membros inferiores - uma unidade já ajuda.", "Duas camisetas de secagem rápida", "Uma calça de poliamida, tactel ou semelhante, que são transpiráveis.", "Água:  recipiente suficiente para 3L;", "Sanduíche natural - enrole no papel alumínio e proteja para não amassar;", "Bisnaguinha;"],
  goodtoknow: ['Evite qualquer roupa de ALGODÃO para a caminhada. O algodão retém muita água e demora em secar. Sobre o sistema de camadas: http://www.mochileiros.com/como-vestir-se-em-locais-frios-sistema-de-camadas-anorak-fleece-underwear-t32962.html', "O peso da comida será dividido entre todos os participantes;", "Os horários poderão sofrer variações de acordo com o ritmo de caminhada do grupo e fatores externos, como variação do tempo (meteorológico) e outros; "],
  category: @cat,
  tags: [@tag_mantiqueira, @tag_montanhismo, @tag_acampamento],
  languages: [@language_default, @language_esp],
  meetingpoint: 'Cachoeira Paulista - SP',
  packages: [@basico, @completo],
  status: 'P'
}

@tour_marins = Tour.find_by_title('Trekking e acampamento no Pico dos Marins') if Tour.find_by_title('Trekking e acampamento no Pico dos Marins').try(:update,@tour_marins_data) || Tour.create(@tour_marins_data)


#
#
# Mais do utopicos
#
#

@barra_data = {
  name: "Barra da Tijuca",
  city: "Rio de Janeiro",
  state: "RJ",
  country: "Brasil"
}

@barra_da_tijuca =  Where.find_by_name("Barra da Tijuca") if Where.find_by_name("Barra da Tijuca").try(:update, @barra_data) || Where.create(@barra_data)

@tour_gavea_data = {
  title: 'Trilha da Pedra da Gávea',
  description: 'A trilha da Pedra da Gávea é, sem dúvida, a mais desafiante da cidade! São aproximadamente 3 horas de subida, mas chegar ao topo com certeza é muito gratificante. A vista de cima dos 847m de altura da Pedra dá uma visão de toda a orla do Rio de Janeiro, entre a Zona Sul e Zona Oeste. Além disso, é possível ver as montanhas que descem da Floresta da Tijuca. É indescritível! A trilha é longa e de nível de dificuldade alto, e ainda conta com a famosa “carrasqueira” - um paredão de pedra, quase reto, que é transposto com auxilio de pés e mãos. Basta permanecer calmo, a subida é mais simples do que parece e para minimizar os riscos, iremos levar equipamentos e monitorar o uso.',
  value: 90,
  currency: 'BRL',
  organizer: @organizer,
  start: '2016-04-30 07:30:00',
  end: '2016-04-30 12:30:00',
  photo: ActionController::Base.helpers.image_url("trilhas/pedra_da_gavea.jpg"),
  availability: 10,
  minimum: 4,
  maximum: 10,
  difficulty: 5,
  where: @barra_da_tijuca,
  address: 'Barra da Tijuca - Rio de Janeiro - RJ',
  user: @user,
  take: ['Tênis ou bota para caminhada', 'Roupas leves', 'Água (pelo menos 2 litros)', 'Lanche para trilha (sugestões: barra de cereal, frutas, biscoitos, sanduíche)', 'Óculos escuros, chapéu ou boné', 'Kit de Primeiros Socorros', 'Repelente e protetor solar', 'Saco de lixo'],
  goodtoknow: ['Em caso de chuva, o evento será remarcado. Mas fique tranquilo que ficaremos de olho na previsão do tempo e te avisaremos em tempo hábil!', 'Para dúvidas específicas sobre esta truppie, entre em contato com o guia pelo e-mail informado acima.'],
  category: @cat,
  tags: [@tagone, @tagtwo, @tagtree],
  languages: [@language_default, @language_alt],
  meetingpoint: 'Informado após confirmação da reserva',
  status: 'P'
}

@tour_gavea = Tour.find_by_title('Trilha da Pedra da Gávea') if Tour.find_by_title('Trilha da Pedra da Gávea').try(:update,@tour_gavea_data) || Tour.create(@tour_gavea_data)