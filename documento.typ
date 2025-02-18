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
Assim o projeto foi dividido em partes menores, sendo essas o frontend, hardware , backend. Será discutido mais a fundo cada frente desse projeto mais á frente.

Com essa divisão de tarefas possibilitou que os diferentes grupos tivessem melhor controle para fazer suas pesquisas e decisões em relação ao que era melhor para o projeto.

== Fundamentação do Hardware

O desenvolvimento do hardware envolveu diversos desafios, incluindo a seleção dos sensores necessários, a definição dos protocolos de comunicação, a escolha do tipo de transmissão e, principalmente, a determinação do microcontrolador mais adequado para a aplicação.

=== Escolha do Microcontrolador

O microcontrolador é o núcleo do dispositivo IoT, responsável pelo processamento de dados e controle dos periféricos. Sua escolha depende de fatores como consumo de energia, conectividade, compatibilidade com os sensores, facilidade de desenvolvimento e custo. As principais opções avaliadas foram:

    - ESP32: Oferece conectividade Wi-Fi e Bluetooth integrada, possui consumo energético moderado com modos de economia de energia e é compatível com interfaces I2C, SPI e UART. Além disso, é amplamente utilizado e de fácil programação.
    - STM32: Destaca-se pelo consumo extremamente baixo e oferece diversas opções de conectividade, incluindo LoRa com módulos adicionais. Conta com periféricos avançados e é programado principalmente através do STM32CubeMX.
    - Arduino MKR WAN 1310: Projetado para facilidade de uso, já conta com conectividade LoRa integrada. Compatível com I2C, SPI e UART, inclui recursos como carregamento de bateria integrado e é programado via Arduino IDE.
    - Adafruit Feather M0 LoRa: Compacto e leve, com conectividade LoRa integrada. Também compatível com I2C, SPI e UART, sendo programado via Arduino IDE, ideal para aplicações que requerem um dispositivo pequeno e eficiente.

Após a análise dessas opções, o ESP32 foi escolhido por sua flexibilidade, facilidade de uso e custo reduzido, uma vez que a equipe já possuía acesso a esse microcontrolador.
=== Seleção do Protocolo de Comunicação

A definição do protocolo de comunicação foi um aspecto crítico para garantir eficiência e confiabilidade na transmissão dos dados. As opções consideradas foram:

    - CoAP: Utiliza o modelo REST sobre UDP e é adequado para dispositivos com recursos restritos, garantindo comunicação eficiente com baixa sobrecarga.
    - HTTP: Amplamente utilizado, mas pode ser pesado para dispositivos com recursos limitados devido à sua sobrecarga. Mais indicado para aplicações com maior capacidade de processamento.
    - LoRaWAN: Focado em comunicação de longa distância com baixo consumo de energia, sendo ideal para transmissão de dados a longas distâncias com baixa taxa de dados.
    - MQTT: Protocolo leve, baseado no modelo de publicação/assinatura, ideal para dispositivos com recursos limitados e redes de baixa largura de banda.

O protocolo MQTT foi escolhido devido à sua leveza, facilidade de implementação e familiaridade da equipe com sua utilização.
=== Escolha dos Sensores

Os sensores são componentes essenciais do projeto, permitindo a coleta de dados ambientais. A seleção foi baseada nas grandezas físicas a serem monitoradas, resultando na escolha dos seguintes dispositivos:

    - DS18B20: Sensor de temperatura digital de alta precisão, utilizando comunicação 1-Wire.
    - BMP280: Sensor barométrico que mede pressão atmosférica e temperatura, compatível com interfaces I2C e SPI.
    - MQ-2 e MQ-7: Sensores para detecção de gases como GLP, metano e monóxido de carbono.
    - DHT-22: Sensor para medição de temperatura e umidade relativa do ar, com comunicação digital simples.
    - LDR: Resistor dependente de luz utilizado para medir a intensidade luminosa do ambiente.

Com essa configuração de hardware, o projeto garante um equilíbrio entre eficiência, confiabilidade e viabilidade econômica.
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

A metodologia adotada para o desenvolvimento do sistema modular de coleta de dados da qualidade do ar envolveu um planejamento detalhado e uma execução integrada entre as diversas frentes do projeto. Foram consideradas e sistematizadas as etapas de seleção, integração e validação dos componentes, garantindo que as escolhas fossem fundamentadas em critérios objetivos, embasamento teórico e na experiência prévia da equipe.
== Levantamento de Requisitos e Planejamento

  - Definição dos Objetivos:
    Inicialmente, foram identificadas as necessidades do projeto, considerando a importância do monitoramento ambiental e a relevância dos dados coletados para a avaliação da qualidade do ar.
  - Análise dos Conceitos:
    Realizou-se uma revisão dos conceitos teóricos relacionados à Internet das Coisas (IoT), microcontroladores, protocolos de comunicação e sensores, a fim de embasar a escolha dos componentes e orientar a implementação de cada módulo.
  - Identificação dos Componentes Essenciais:
    Foram definidos os sensores a serem utilizados – DS18B20, BMP280, MQ-2, MQ-7, DHT-22 e LDR – bem como o microcontrolador ESP32, levando em consideração fatores como custo, flexibilidade, compatibilidade e disponibilidade.
  - Estudo dos Protocolos de Comunicação:
    A análise comparativa dos protocolos (CoAP, HTTP, LoRaWAN e MQTT) evidenciou que o MQTT era o mais adequado para o cenário de redes com largura de banda restrita, devido à sua leveza e eficiência na transmissão dos dados.

== Seleção e Desenvolvimento do Hardware

Esta etapa envolveu a escolha criteriosa dos componentes e a integração física dos mesmos:
=== Escolha dos Componentes

  - Microcontrolador:
    Foram avaliadas opções como ESP32, STM32, Arduino MKR WAN 1310 e Adafruit Feather M0 LoRa.
    Critérios de avaliação: consumo de energia, conectividade (Wi-Fi, Bluetooth, LoRa), facilidade de programação e custo.
    Decisão: O ESP32 foi escolhido por sua flexibilidade, facilidade de uso e custo reduzido, além de já estar disponível para a equipe.

  - Protocolo de Comunicação:
    Foram analisados diferentes protocolos quanto à eficiência e à sobrecarga para dispositivos com recursos limitados.
    Decisão: O protocolo MQTT foi selecionado pela sua leveza, facilidade de implementação e pela compatibilidade com a infraestrutura do projeto.

  - Sensores:
    A seleção dos sensores levou em conta as grandezas físicas a serem monitoradas e a precisão necessária para cada medição.
    Componentes escolhidos:
      -  DS18B20: Sensor de temperatura digital com alta precisão (comunicação 1-Wire).
      -  BMP280: Sensor barométrico que mede pressão atmosférica e temperatura (interfaces I2C/SPI).
      -  MQ-2 e MQ-7: Sensores para detecção de gases como GLP, metano e monóxido de carbono.
      -  DHT-22: Sensor para medição de temperatura e umidade com interface digital.
      -  LDR: Utilizado para medir a intensidade luminosa do ambiente.

=== Projeto e Montagem do Circuito

  - Desenho do Circuito:
    Com os componentes selecionados, foi realizado o projeto do circuito, garantindo a correta interligação entre sensores, microcontrolador e demais periféricos, com atenção especial à estabilidade dos sinais.
  -  Montagem e Testes Iniciais:
    Após a montagem, foram executados testes individuais para verificar o funcionamento de cada sensor e a integridade das conexões, permitindo ajustes e refinamentos que garantiram a precisão na coleta dos dados.

== Implementação do Firmware

  -  Desenvolvimento do Firmware:
    Foi criado um firmware específico para o ESP32, que integra a leitura dos sensores e a transmissão dos dados via MQTT.
  -  Modularização:
    Bibliotecas modulares foram desenvolvidas para cada sensor, facilitando futuras manutenções e expansões do sistema.
  -  Testes Unitários:
    Cada módulo foi testado individualmente para assegurar seu funcionamento correto e a eficácia da comunicação entre os sensores e o microcontrolador.

== Desenvolvimento do Backend e Frontend

  -  Backend:
        Foi implementado um banco de dados para o armazenamento das informações coletadas, permitindo o gerenciamento, consulta e análise histórica dos dados.
        Uma API foi desenvolvida em Go, escolhida por seu desempenho e escalabilidade, garantindo a correta interpretação das mensagens MQTT e seu armazenamento.
  -  Frontend:
        Desenvolvida uma interface web intuitiva e responsiva utilizando React JS e Tailwind CSS, que possibilita a visualização em tempo real e a análise histórica dos dados.
        Testes de usabilidade foram conduzidos para garantir uma experiência interativa e eficiente para o usuário.

== Integração e Validação do Sistema

  -  Integração:
    Todas as camadas do sistema – hardware, firmware, backend e frontend – foram integradas e validadas de forma colaborativa.
    Testes de Integração:
    Foram realizados testes em ambiente controlado para verificar a comunicação via MQTT e a robustez do fluxo completo de dados, desde a coleta até a exibição.
  -  Ajustes e Otimizações:
    Com base nos resultados dos testes, foram implementadas melhorias que asseguraram maior eficiência e robustez do sistema.

== Documentação e Gestão do Projeto

  -  Controle de Versões:
    O desenvolvimento foi acompanhado através de versionamento no GitHub, permitindo rastreabilidade e colaboração contínua.
  -  Reuniões e Feedback:
    Reuniões periódicas e revisões de progresso foram realizadas para alinhar expectativas, identificar problemas precocemente e implementar soluções eficazes.
  -  Registro e Análise:
    Toda a metodologia e as decisões técnicas foram documentadas, permitindo uma análise crítica dos resultados e a identificação de pontos de melhoria para projetos futuros.



#pagebreak()
= Resultados e Discussão

#pagebreak()
= Considerações Finais

#pagebreak()
= Referências
