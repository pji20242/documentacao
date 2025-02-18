#import "@preview/klaro-ifsc-sj:0.1.0": report
#import "@preview/codelst:2.0.1": sourcecode
#show heading: set block(below: 1.5em)
#show par: set block(spacing: 1.5em)
#set text(font: "Arial", size: 12pt)
#set text(lang: "pt")
#set page(
  footer: "Engenharia de Telecomunicações - IFSC-SJ",
)

#show: doc => report(
  title: "Sistema modular de coleta \n de dados da qualidade do ar",
  subtitle: "",
  authors: ("Arthur Cadore Matuella Barcella","Gustavo Paulo","Matheus Pires Salaza","Rhenzo Hideki Silva Kajikawa" ),
  date: "",
  doc,
)



= Introdução
O presente relatório documenta o desenvolvimento de um sistema integrado que abrange hardware, backend e frontend. O projeto, concebido e desenvolvido por PJI029008, sendo o grande motivador as queimadas que ocorreram no segundo semestre de 2024, junto com outros estudos públicados da mesma época debatendo assuntos climáticos como ilhas de calor. 

Este projeto tem como foco a coleta, processamento e visualização de dados provenientes de diversos sensores conectados a um ESP32. O sistema utiliza o protocolo MQTT para a comunicação dos dispositivos e conta com um conjunto de aplicações que englobam tanto a parte física (hardware) quanto as camadas de software (backend e frontend) para gerenciar e exibir as informações.

== Objetivo Geral

Desenvolver um sistema integrado para monitoramento de variáveis ambientais, que permita a coleta de dados através de sensores (temperatura, pressão, gás, umidade, luminosidade, etc.) conectados a um ESP32, e a transmissão desses dados via MQTT para uma plataforma central que os processa e disponibiliza em uma interface web.

== Objetivo Específicos
Projetar e construir um hardware próprio baseado em ESP32, com sensores adequados e circuitos de interface (incluindo reguladores de tensão e protoboard) para a medição das grandezas ambientais.
Implementar uma biblioteca modular para cada sensor, de modo a facilitar a manutenção e a extensão do código.
Estabelecer uma comunicação padrão via MQTT, definindo a estrutura das mensagens e os símbolos delimitadores para garantir a correta interpretação dos dados.
Desenvolver um backend capaz de receber, armazenar e processar os dados enviados pelos dispositivos.
Criar um frontend intuitivo que permita a visualização em tempo real dos dados coletados e a realização de análises históricas.
Fornecer documentação completa para que outros desenvolvedores possam replicar ou adaptar o sistema com seus próprios dispositivos.

#pagebreak()
= Fundamentação Teórica
Como o projeto tem um escopo grande , foi fundamental dividir este projeto em partes menores.
Assim o projeto foi dividido em partes menóres, sendo essas o frontend, hardware , backend. Será discutido mais a fundo cada frente desse projeto mais á frente.

Com essa divisão de tarefas possibilitou que os diferentes grupos tivessem melhor controle para fazer suas pesquisas e decisões em relação ao que era melhor para o projeto.

== Fundamentação do hardware
Dentro do hardware houveram diversos desafios relacionados ao sensores que seriam necessários, aos protocolos de comunicação, ao tipo de transmissão que seria feita , e até ao próprio microcontrolador necessário para a tarefa.

Primeiramentes foi feita a escolha do microcontrolador, 
pois estes são o núcleo do dispositivo IoT, 
resposável pelo processamento de dados e controle de periféricos. A escolha do microcontrolador adrquado depende de diferentes fatores
como o consumo de energia, conectividade, compatibilidade com os sensores, facilidade de uso e o seu custo.

ESP32 oferece conectividade Wi-Fi e Bluetooth integradas, com um consumo de energia moderado e diferentes modos de economia de energia.
Compatível com interfaces I2C, SPI e UART. Também sendo fácil de programar e injetar código neste. e sendo mais robusto e conhecido. 

STM32  destaca-se pelo consumo de energia muito baixo, com modos de ultrabaixo consumo. Oferece diversas opções de conectividade, incluindo LoRa com módulos adicionais. Compatível com I2C, SPI e UART, possui periféricos avançados e é programado principalmente através do STM32CubeMX.

Arduino MKR WAN 1310 é projetado para facilidade de uso, com conectividade LoRa integrada. Compatível com I2C, SPI e UART, é programado através do Arduino IDE. Inclui recursos como carregamento de bateria integrado, sendo ideal para aplicações que requerem conectividade LoRa e simplicidade no desenvolvimento.

Adafruit Feather M0 LoRa é um microcontrolador leve e compacto, com conectividade LoRa integrada. Compatível com I2C, SPI e UART, é fácil de programar usando o Arduino IDE. Adequado para projetos que necessitam de um dispositivo compacto com conectividade LoRa.

Dentre essas várias opções foi concluido que a ESP32 seria o microcontrolador que nosso projeto usaria. Devido ao fato de ser mais fléxivel para nós e ser um microcontralador mais acessivel financeiramente pois já tinhamos acesso a uma.
#figure(
  image("Figures/esp32_wroom_32e.png",width:50%),
  caption: [
   Fonte: Elaborada pelo autor
  ],
  supplement: "Figura"
);
Após a escolha do hardware foi necessário escolher qual o protocolo de comunicação que seria utiliza.
Uma vez que é crucial para garantir a eficiência e confiablidade na transmissão de dados do dispositivo.

CoAP foi projetado para dispositivos restritos, utilizando o modelo REST sobre UDP. Adequado para aplicações que requerem comunicação eficiente e baixa sobrecarga.

- HTTP é amplamente utilizado, porém pode ser pesado para dispositivos com recursos limitados devido à sua sobrecarga. Mais adequado para dispositivos com maior capacidade de processamento e energia.

- LoRaWAN é um protocolo para comunicação de longa distância com baixo consumo de energia, ideal para aplicações que requerem transmissão de dados a longas distâncias com baixa taxa de dados.

-MQTT é leve, ideal para dispositivos com recursos limitados e redes com largura de banda restrita. Utiliza um modelo de publicação/assinatura, permitindo comunicação eficiente entre dispositivos e servidores.

#figure(
  image("Figures/mqtt-architecture.png",width:50%),
  caption: [
   Fonte: Elaborada pelo autor
  ],
  supplement: "Figura"
);

Dessa forma , foi escolhida MQTT , pois além de ser leve , tem uma implementação fácil se comparado com os outros e a equipe já havia trabalhado com este protocolo anteriormente.

Por fim o componente mais importante para o projeto na parte do hardware, os sensores. Estes são os
componentes fundamentais para o projeto, permitindo a coleta de dados do ambientes.
A escolha dos sensores depende das grandezas físicas desejadas.
Como o projéto trabalha com vários sensores foram escolhidos seguintes:
DS18B20: Sensor de temperatura digital com alta precisão, utilizando comunicação 1-Wire.

- BMP280: Sensor barométrico que mede pressão atmosférica e temperatura, utilizando interfaces I2C ou SPI.

- MQ-2 e MQ-7: Sensores de gás que detectam a presença de gases como GLP, metano, monóxido de carbono, entre outros.

- DHT-22: Sensor que mede temperatura e umidade relativa do ar, com comunicação digital simples.

- LDR: Resistor dependente de luz utilizado para medir a intensidade luminosa do ambiente.

== Fundamentação do Frontend

O desenvolvimento do frontend do sistema modular de coleta de dados da qualidade do ar teve como objetivo principal criar uma interface intuitiva, responsiva e eficiente para a visualização dos dados coletados pelos sensores. Para alcançar esses objetivos, foram adotadas tecnologias modernas que garantem boa performance, escalabilidade e facilidade de manutenção.

=== Tecnologias Utilizadas

A escolha das tecnologias para o frontend considerou aspectos como facilidade de desenvolvimento, performance e compatibilidade com a arquitetura do projeto. As principais tecnologias utilizadas foram:

- React.js: Biblioteca JavaScript utilizada para a construção da interface do usuário de forma modular e reutilizável. Sua abordagem baseada em componentes facilita a manutenção e evolução do sistema.

- Tailwind CSS: Framework CSS utilizado para estilização da interface, proporcionando uma abordagem eficiente e flexível na personalização do design.

- Vite: Ferramenta utilizada para o build e desenvolvimento do frontend, garantindo maior velocidade e otimização na entrega do código ao usuário.

- Axios: Biblioteca para realizar requisições HTTP e facilitar a comunicação entre o frontend e a API do backend.

- Recharts: Biblioteca para a visualização gráfica dos dados coletados pelos sensores, permitindo a criação de gráficos dinâmicos e interativos.

=== Estrutura do Frontend

O frontend foi projetado para fornecer uma experiência fluida e responsiva aos usuários, garantindo a apresentação eficiente dos dados coletados. A estrutura principal foi dividida em três seções:

- Página Principal: Exibe um mapa que mostra a localização dos dispositivos do usuário em questão.

- Cooperativas: Tela que o administrador do sistema pode visualizar todas as cooperativas cadastradas e suas respectivas informações.

- Usuários: Tela em que o dono da cooperativa pode acessar e gerenciar as informações dos usuários de sua cooperativa.

- Dispositivos: Mostra cada dispositivo que o usuário tiver, também pode direcionar para visualizar informações detalhadas das medições dos sensores, exibindo os dados coletados pelos sensores em tempo real, utilizando gráficos interativos e indicadores numéricos. Permitindo a visualização de dados passados, possibilitando a análise de tendências e padrões ambientais.

=== Comunicação com o Backend

A interação entre o frontend e o backend foi implementada através de uma API REST, permitindo o consumo dos dados processados pelo servidor.
O fluxo de comunicação segue os seguintes passos:
#linebreak()
1. O frontend realiza uma requisição HTTP à API para obter os dados coletados.

2. A API retorna as informações em formato JSON.

3. O frontend processa os dados e os exibe de maneira visualmente compreensível para o usuário.

#linebreak()
A escolha das tecnologias e a estruturação do frontend proporcionam diversos benefícios ao projeto, tais como:

- Responsividade: A interface se adapta a diferentes tamanhos de tela, garantindo uma boa experiência de uso em dispositivos móveis e desktops.

- Performance otimizada: O uso de React.js e Vite melhora o tempo de carregamento da aplicação, proporcionando uma navegação fluida.

- Modularidade: A abordagem baseada em componentes facilita a manutenção e expansão da aplicação.

- Atualização em tempo real: Permitindo que os dados sejam exibidos de forma dinâmica, sem a necessidade de recarregar a página

#pagebreak()
= Metodologia

A metodologia adotada para o desenvolvimento do sistema modular de coleta de dados da qualidade do ar envolveu um planejamento detalhado e uma execução integrada entre as diversas frentes do projeto, garantindo que o hardware, firmware, backend e frontend fossem desenvolvidos de maneira colaborativa e iterativa. 

== Etapas do Desenvolvimento

=== Levantamento de Requisitos e Planejamento

Com base nos objetivos gerais e específicos, foi realizada uma análise detalhada das necessidades do projeto, considerando a importância do monitoramento ambiental e a relevância dos dados coletados. Inicialmente, foram analisados os objetivos e definidos os componentes essenciais, como os sensores DS18B20, BMP280, MQ-2, MQ-7, DHT-22 e LDR, além da escolha do microcontrolador ESP32, considerando fatores como custo, flexibilidade e compatibilidade. O estudo dos protocolos de comunicação revelou que o MQTT era o mais adequado, devido à sua leveza e eficiência na transmissão dos dados, especialmente em redes com largura de banda restrita.

=== Desenvolvimento do Hardware

No desenvolvimento do hardware, os circuitos foram projetados e montados para integrar os sensores ao ESP32, com atenção especial à estabilidade dos sinais e à interface entre os dispositivos. Após a montagem, foram realizados testes iniciais para verificar o funcionamento individual dos sensores e a integridade da conexão com o microcontrolador, permitindo ajustes e refinamentos que garantiram a precisão na coleta dos dados ambientais.

=== Implementação do Firmware

A implementação do firmware envolveu a criação de bibliotecas modulares para cada sensor, facilitando a manutenção e a expansão do sistema, além do desenvolvimento de código específico para o ESP32, que coletava os dados e os transmitia via MQTT para a plataforma central. Testes unitários asseguraram o correto funcionamento de cada módulo e a eficácia da comunicação entre os sensores e o microcontrolador.

=== Desenvolvimento do Backend

No backend, foi criado um banco de dados para armazenar todas as informações coletadas, o que possibilitou o gerenciamento, a consulta e a análise histórica dos dados. Paralelamente, desenvolvemos uma API utilizando a linguagem Go, escolhida por suas vantagens atuais, como alto desempenho, escalabilidade e suporte robusto para aplicações web modernas. A estruturação das mensagens MQTT, com a definição de formatos e símbolos delimitadores, foi essencial para a correta interpretação e armazenamento dos dados no banco.

=== Desenvolvimento do Frontend

Para a camada de frontend, projetamos uma interface web intuitiva e responsiva que proporcionasse uma experiência interativa ao usuário. A escolha das tecnologias React JS e Tailwind CSS permitiu uma construção ágil, moderna e de alta performance, facilitando a manutenção e a evolução da interface. A integração entre o frontend e a API garantiu que os dados fossem exibidos em tempo real e que análises históricas pudessem ser realizadas com facilidade. Testes de usabilidade foram realizados para identificar possíveis melhorias e assegurar a facilidade de uso da plataforma.

=== Integração e Validação do Sistema

Ao final, a integração de todas as camadas do sistema foi cuidadosamente validada por meio de testes que verificaram a comunicação eficiente via MQTT e a robustez do fluxo completo de dados, desde a coleta até a exibição. Essa abordagem colaborativa e iterativa permitiu a identificação precoce de problemas e a implementação de soluções eficazes, resultando em um sistema robusto, escalável e capaz de atender aos desafios do monitoramento da qualidade do ar com tecnologias modernas e eficientes.

A metodologia adotada enfatizou a importância do trabalho em equipe e da comunicação constante entre as diversas frentes do projeto. Reuniões periódicas, revisões de progresso e feedback contínuo foram essenciais para alinhar as expectativas e solucionar desafios de forma colaborativa, garantindo que todas as etapas se integrassem harmoniosamente.



#pagebreak()
= Resultados e Discussão

#pagebreak()
= Considerações Finais

#pagebreak()
= Referências
