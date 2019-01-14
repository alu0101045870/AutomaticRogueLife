# AutomaticRogueLife: 
###### Desarrollado por Fernando González Petit en lenguaje Prolog
  Version 1.0

### Introducción: 
> Breve descripción de funcionamiento y propósito del programa

AutomaticRogueLife es, en esencia, un juego estilo roguelike, con la particularidad de que la lógica y las funciones de juego están implementadas en Prolog. Mi propósito es crear una aplicación interactiva y a la vez de operación automática que simule la experiencia de los juegos de rol de ordenador viejos, basados en decisiones.

En el juego, "controlas" a un personaje ("Hiro" por defecto) que acaba de despertar en un subterráneo junto a su amigo Julian. Su misión es encontrar al resto de compañeros en el subterráneo, recopilar los recursos necesarios para abrirse paso por la 'dungeon' y abrir la trampilla que lleva al exterior. Cada uno de sus amigos tiene algo importante para salir, así que lo más probable es que pases por cada uno de ellos hasta encontrar la salida y tener lo necesario regresar a la superficie.

###### Notas de versión: La idea es añadir funcionalidad con el tiempo; por el momento el programa está en un estado en el que el juego es demasiado secillo, pero mejorar la experiencia de usuario y añadir funcionalidades con el tiempo es mi idea.

### Notas de implementación:
> Resumen de funcionalidad y descripción de relaciones más importantes en la lógica del programa.

El 'mundo' del juego, consta en una matriz. Pero espera, ¿cómo va a ser una matriz si Prolog no es un lenguaje de programación orientado a objetos? La respuesta es sencilla: *Como todos los objetos del juego, se simula a través de lógica*

Una matriz se basa en las siguientes normas:
  - **Definición de adyacencia de números** -> 1 es adyacente a 2, 2 no es adyacente a 4
  - **Definición de "casilla"** -> Una casilla en una lista con dos elementos numéricos, un par [X, Y]. X horizontal, Y vertical, para hacerse la imagen mental.
  - **Definición de adyacencia de casillas** -> Una casilla es adyacente a otra si una de las coordenadas es adyacente con la respectiva en la otra.
  - **Importante: Tamaño del mundo** -> Se fuerza a que el valor de WorldSize (WS) sea un número determinado. Solo se permitirán casillas cuyas coordenadas estén en el rango (1..WS)
  - **Elementos que 'viven' en el mundo** -> Desde el personaje que manejamos hasta NPC's y monstruos e incluso contando la trampilla de salida.
  
Empecemos por los NPC's. Al subterráneo bajan contigo (Julian, Abigail, Nero, Margarette). Esta es su posición en la lista de la base de conocimiento y se puede conocer su posición a través de la relación where_is(NPC, Pos). 
  - Al dar con un NPC, generalmente se parará el movimiento automático. Al hablar con ellos por primera vez, te darán sus respectivos **objetos importantes**: 
    + Nero tiene un arma. Más de una, de hecho. No preguntes por qué.
    + Abigail tiene la llave. Es buena encontrando cosas, qué decir.
    + Margarette sabe donde se encuentra la salida (en un futuro podría saber la ubicación de otros lugares importantes)
    + Julian sabe donde está Abigail.

Por otro lado están los monstruos. Son entes inmóviles localizados aleatoriamente en el mapa. De momento no tienen mucha mayor relevancia, aunque la idea es que supongan una verdadera amenaza para el agente.

Ahora, en cuanto al agente lógico que operamos, nuestro personaje:
  - **Atributo posición** -> Un valor dinámico que indica la casilla
  - **CurrentGoal o 'meta actual'** -> Un valor dinámico que indica el destino hacia el que se mueve el agente automáticamente.
  - **Vector de casillas visitadas** -> En la versión actual, permite la traza del recorrido que realiza el agente cuando se le pide moverse.
  - **Vector de percepciones** -> El agente no es omnisciente, sino que cuenta con un vector sencillo de percepciones que le permiten relacionarse con el resto de elementos en el mundo:
    + Vista: El agente tiene ojos para las casillas inmediatamente adyacentes. Puede ver la luz de un fuego u hoguera, lo que indicaría que hay un NPC cerca.
    + Olfato: Si detecta que huele mal en las casillas adyacentes sabrá que hay un monstruo. Trataré su patrón de actuación en profundidad para estos casos más adelante.
    + Sensación de viento: Un motivo un tanto abstracto, pero el agente interpreta el flujo de aire como la presencia.
  - **Posesión de arma** -> Solo con un arma en mano puedes hacer frente a los monstruos del subterráneo.
  - **Posesión de llave** -> Solo con la llave puedes salir de la mazmorra.

#### El jugador

En cualquier videojuego, al final, es el elemento más importante. La experiencia del usuario es en sí un aspecto relevante para el programa y se ha tenido en cuenta en el desarrollo en todo momento. Esto genera también una serie de dificultades asociadas, pero es a su vez parte de la magia del asunto.

Para poner en marcha el juego con nuevos valores de aleatoriedad y desde el inicio, el usuario debe cargar la base de conocimiento y escribir "start." en la terminal de Prolog. 

###### Nota de versión(1.0): 
A partir de aquí, el patrón de juego es relativamente simple y cuenta con los siguientes comandos:
  - **"behave"** -> ordena al agente interactuar con el entorno. Esta interacción supone hablar con NPC's, actuar ante monstruos o abrir la trampilla para salir (si se tiene la llave, claro)
  - **"move"** -> ordena al agente desplazarse hacia la meta actual. El agente se parará si encuentra a alguien o algo por el camino digno de su atención.
  - **"oneStep"** -> Avanza solo un paso hacia la meta actual. (Puede resultar más útil en futuras versiones)
  - **"help"** -> Muestra la ayuda de comandos.
  
  
### Desarrollo del programa
