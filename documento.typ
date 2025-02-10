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
= Referenciais Teóricos


#pagebreak()
= Metodologia

#pagebreak()
= Resultados e Discussão

#pagebreak()
= Considerações Finais

#pagebreak()
= Referências